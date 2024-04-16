//
//  MarsPhoto.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//  Copyright © 2024 Mustafa Bekirov. All rights reserved.

import Foundation
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
    
    @StateObject var networkManager = NetworkManager.shared
    
    @State private var employees = [Employee]()
    
    @State private var showProgress: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        ZStack {
            List(employees, id: \.self) { employee in
                HStack {
                    Text(employee.employee_name)
                    Spacer()
                    Text(employee.employee_salary, format: .number)
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
struct Employee: Decodable, Hashable {
    let id: Int
    let employee_name: String
    let employee_salary: Int
}

struct Query: Decodable {
    let status: String
    let data: [Employee]
}

extension Employee {
    static let example = Employee(id: 1, employee_name: "Tim Cook", employee_salary: 30000)
}

struct Card: Decodable, Hashable {
    let id: Int
    let camera: Camera
    let img_src: String
    let earth_date: String
    let rover: Rover
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

extension Card {
    static let card = Card(id: "103383", camera: Camera(full_name: "Navigation Camera"), img_src: "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/ncam/NLB_486272784EDR_F0481570NCAM00415M_.JPG", earth_date: "2015-05-30", rover: Rover(name: "Curiosity"))
}
extension Cameras {
    static let camera = Cameras(name: "FHAZ", full_name: "Front Hazard Avoidance Camera")
}

//curiosity spirit opportunity perseverance
