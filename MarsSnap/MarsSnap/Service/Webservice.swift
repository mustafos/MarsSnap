//
//  Webservice.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 16.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

import Foundation

enum NetworkError: LocalizedError {
    case invalidRequest
    case offline
    case timedOut
    case server
    case decoding

    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "Those filters can't be searched."
        case .offline:
            return "You appear to be offline. Check the connection and try again."
        case .timedOut:
            return "The photo service took too long to answer."
        case .server:
            return "The photo service is unavailable right now."
        case .decoding:
            return "The photo service returned something unexpected."
        }
    }
}

struct PhotoPage {
    let photos: [Photo]
    let page: Int
    let hasMore: Bool
}

struct Webservice {
    private let session: URLSession = .shared
    private let pageSize = 25

    func fetchPhotos(request: PhotoRequest, page: Int) async throws -> PhotoPage {
        guard let rover = Rover(rawValue: request.rover) else {
            throw NetworkError.invalidRequest
        }
        let url = try photosURL(rover: rover, camera: request.camera, date: request.date, page: page)
        let envelope: PhotosEnvelope = try await load(url)
        let photos = envelope.images.compactMap { dto -> Photo? in
            Photo(dto: dto, rover: rover.rawValue)
        }
        return PhotoPage(photos: photos, page: max(page, 1), hasMore: envelope.pagination.hasNext)
    }

    func fetchCameras(rover: String) async throws -> [RoverCamera] {
        guard let rover = Rover(rawValue: rover.lowercased()) else {
            throw NetworkError.invalidRequest
        }
        let url = Constants.Urls.photosBase
            .appendingPathComponent(rover.rawValue)
            .appendingPathComponent("cameras")
        let envelope: CamerasEnvelope = try await load(url)
        return envelope.cameras.map { RoverCamera(code: $0.code, fullName: $0.fullName) }
    }

    private func photosURL(rover: Rover, camera: String?, date: String?, page: Int) throws -> URL {
        guard var components = URLComponents(
            url: Constants.Urls.photosBase.appendingPathComponent(rover.rawValue),
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkError.invalidRequest
        }

        var items = [
            URLQueryItem(name: "limit", value: String(pageSize)),
            URLQueryItem(name: "page", value: String(max(page, 1))),
            URLQueryItem(name: "sort", value: "date"),
            URLQueryItem(name: "order", value: "desc")
        ]
        if let camera, !camera.isEmpty {
            items.append(URLQueryItem(name: "camera", value: camera))
        }
        if let date, !date.isEmpty {
            guard let end = MarsCalendar.dayAfter(date) else { throw NetworkError.invalidRequest }
            items.append(URLQueryItem(name: "date_from", value: date))
            items.append(URLQueryItem(name: "date_to", value: end))
        }
        components.queryItems = items
        guard let url = components.url else { throw NetworkError.invalidRequest }
        return url
    }

    private func load<T: Decodable>(_ url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.timeoutInterval = 20
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("MarsSnap/1.0", forHTTPHeaderField: "User-Agent")

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
                throw NetworkError.offline
            case .timedOut:
                throw NetworkError.timedOut
            default:
                throw NetworkError.server
            }
        } catch {
            throw NetworkError.server
        }

        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw NetworkError.server
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding
        }
    }
}

private extension Photo {
    init?(dto: ImageDTO, rover: String) {
        let day = dto.date.count >= 10 ? String(dto.date.prefix(10)) : dto.date
        var urlString = dto.imageURL
        if urlString.hasPrefix("http://") {
            urlString = "https://" + urlString.dropFirst("http://".count)
        }
        guard let url = URL(string: urlString) else { return nil }
        self.init(
            id: dto.id,
            sol: dto.sol,
            cameraCode: dto.camera,
            earthDate: day,
            imageURL: url,
            rover: rover,
            title: dto.title ?? ""
        )
    }
}

private struct PhotosEnvelope: Decodable {
    let images: [ImageDTO]
    let pagination: PaginationDTO
}

private struct PaginationDTO: Decodable {
    let hasNext: Bool

    private enum CodingKeys: String, CodingKey {
        case hasNext = "has_next"
    }
}

private struct ImageDTO: Decodable {
    let id: Int
    let sol: Int
    let camera: String
    let date: String
    let imageURL: String
    let title: String?

    private enum CodingKeys: String, CodingKey {
        case id, sol, camera, date, title
        case imageURL = "image_url"
    }
}

private struct CamerasEnvelope: Decodable {
    let cameras: [CameraDTO]
}

private struct CameraDTO: Decodable {
    let code: String
    let fullName: String

    private enum CodingKeys: String, CodingKey {
        case code
        case fullName = "full_name"
    }
}
