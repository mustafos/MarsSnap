//
//  MarsPhoto.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//  Copyright © 2024 Mustafa Bekirov. All rights reserved.

import Foundation
import Combine
import SwiftUI

struct NetworkGETDataView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    EmployeesView()
                } label: {
                    HStack {
                        Text("Employees")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                }
                
                Spacer()
            }
            .navigationTitle("Fetching Data")
        }
    }
}

struct EmployeesView: View {
    
    @StateObject var networkManager = MarsPhotoManager.shared
    
    @State private var employees = [Card]()
    
    @State private var showProgress: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        ZStack {
            List(employees, id: \.self) { employee in
                HStack {
                    Text(employee.rover.name)
                    Spacer()
                    Text(employee.camera.full_name)
                }
            }
            
            ProgressView()
                .progressViewStyle(.circular)
                .opacity(showProgress ? 1 : 0)
        }
        .alert(isPresented: $showError, content: {
            Alert(title: Text(errorMessage))
        })
        .onAppear {
            showProgress = true
            networkManager.fetchEmployees { result in
                showProgress = false
                switch result {
                case .success(let decodedEmployees):
                    print("success")
                    
                    employees = decodedEmployees
                    
                case .failure(let networkError):
                    print("feilure: \(networkError)")
                    errorMessage = warningMessage(error: networkError)
                    showError = true
                }
            }
        }
    }
}

//________________________________________________________ Model
struct Card: Decodable, Hashable {
    let id: Int
    let camera: Camera
    let img_src: String
    let earth_date: String
    let rover: Rover
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(camera.full_name)
        hasher.combine(img_src)
        hasher.combine(earth_date)
        hasher.combine(rover.name)
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        // Implement your equality logic here
        // For example, comparing properties:
        return lhs.id == rhs.id &&
        lhs.camera.full_name == rhs.camera.full_name &&
               lhs.img_src == rhs.img_src &&
               lhs.earth_date == rhs.earth_date &&
        lhs.rover.name == rhs.rover.name
    }
}

struct Camera: Decodable {
    let full_name: String
}

struct Rover: Decodable {
    let name: String
    let cameras: [Cameras]
}

struct Cameras: Decodable, Hashable {
    let name: String
    let full_name: String
}

struct Query1: Decodable {
    let photos: [Card]
}

// Sample data for extension purposes
extension Card {
    static let card = Card(id: 103383, camera: Camera(full_name: "Navigation Camera"), img_src: "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/ncam/NLB_486272784EDR_F0481570NCAM00415M_.JPG", earth_date: "2015-05-30", rover: Rover(name: "Curiosity", cameras: []))
}

extension Cameras {
    static let camera = Cameras(name: "FHAZ", full_name: "Front Hazard Avoidance Camera")
}
