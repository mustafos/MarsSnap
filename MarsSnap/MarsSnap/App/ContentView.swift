//
//  ContentView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    // MARK: – PROPERTIES
    @ObservedObject var manager = MarsPhotoManager()
    @State private var selectedRover = Rover.perseverance
    @State private var selectedCamera = Camera.all
    @State private var selectedEarthDate = EarthDate.latest
    
    @State private var showSaveFilterAlert: Bool = false
    @State private var isSheetPresented: Bool = false
    @State private var selectedFilter = String()
    @State private var presentDatePickerFilter: Bool = false
    @State private var selectedDate = Date()
    @State private var tempSelectedDate = Date()
    
    let realm = try! Realm()
    
    // MARK: – BODY
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                if presentDatePickerFilter {
                    DatePickerComponent(title: "Date", selectedDate: $tempSelectedDate)
                        .onNegativeButtonTap {
                            presentDatePickerFilter.toggle()
                        }
                        .onPositiveButtonTap { date in
                            presentDatePickerFilter.toggle()
                            selectedDate = tempSelectedDate
                        }
                }
                
                if isSheetPresented {
                    GeneralFilterComponent(selectedFilter: $selectedFilter)
                        .onNegativeButtonTap {
                            isSheetPresented.toggle()
                        }
                        .onPositiveButtonTap { filter in
                            isSheetPresented.toggle()
                            selectedFilter = filter
                        }
                }
                Group {
                    VStack {
                        HeaderView()
                        ZStack {
                            ScrollView(.vertical, showsIndicators: false) {
                                Spacer()
                                ForEach(manager.filteredData(selectedRover: selectedRover, selectedCamera: selectedCamera, selectedEarthDate: selectedEarthDate)) { marsData in
                                    NavigationLink(destination: MarsImageView(mars: marsData)) {
                                        CardComponent(mars: marsData)
                                    } //: LINK
                                } //: LOOP
                                HStack {
                                    Spacer()
                                    Text("Copyright © 2024 Mustafa Bekirov. \nAll rights reserved.")
                                        .font(.footnote)
                                        .multilineTextAlignment(.center)
                                    Spacer()
                                } //: HSTACK
                                .padding(10)
                                .animation(.easeIn)
                            } //: SCROLL
                        } //: ZSTACK
                        .background(Color.backgroundOne)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        
                    } //: VSTACK
                    .background(Color.accentOne)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                } //: GROUP
                .navigationBarHidden(true)
                
                HistoryButton()
                
            } //: ZSTACK
            .alert(isPresented: $showSaveFilterAlert) {
                Alert(
                    title: Text("Save Filters"),
                    message: Text("The current filters and the date you have chosen can be saved to the filter history."),
                    primaryButton: .default(Text("Save"), action: {
                        withAnimation {
                            feedback.impactOccurred()
                            saveFilterHistory()
                        }
                    }),
                    secondaryButton: .cancel()
                )
            }
        } //: NAVIGATION
    }
    
    // MARK: – VIEW BUILDER
    @ViewBuilder
    private func HeaderView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("mars.camera".uppercased())
                        .font(.system(size: 34, weight: .bold))
                    Text(formattedDate)
                }
                Spacer()
                Button(action: {
                    withAnimation {
                        feedback.impactOccurred()
                        presentDatePickerFilter.toggle()
                    }
                }, label: {
                    Image("calendar")
                })
            } //: HSTACK
            HStack {
                Button(action: {
                    withAnimation {
                        feedback.impactOccurred()
                    }
                }, label: {
                    HStack(alignment: .center, spacing: 7) {
                        Image("cpu")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24, alignment: .center)
                        
                        Text("All")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        Spacer()
                    } //: HSTACK
                    .padding(7)
                    .background(Color.white.cornerRadius(10))
                }) //: BUTTON
                Button(action: {
                    withAnimation {
                        feedback.impactOccurred()
                        isSheetPresented.toggle()
                    }
                }, label: {
                    HStack(alignment: .center, spacing: 7) {
                        Image("camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24, alignment: .center)
                        
                        Text("All")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        Spacer()
                    } //: HSTACK
                    .padding(7)
                    .background(Color.white.cornerRadius(10))
                }) //: BUTTON
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        feedback.impactOccurred()
                        showSaveFilterAlert.toggle()
                    }
                }, label: {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16, alignment: .center)
                        .foregroundColor(.black)
                }) //: BUTTON
                .padding(11)
                .background(Color.white.cornerRadius(10))
            } //: HSTACK
        } //: VSTACK
        .padding(.top, 50)
        .padding(.horizontal)
        .padding(.bottom, 10)
        .background(Color.accentOne)
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    private func HistoryButton() -> some View {
        NavigationLink {
            HistoryView()
        } label: {
            Circle()
                .frame(width: 70, height: 70)
                .foregroundColor(.accentOne)
                .shadow (radius: 5)
                .overlay(Image("archive"))
        }
        .edgesIgnoringSafeArea(.all)
        .padding(.trailing, 20)
        .padding(.bottom, 10)
    }
    
    // MARK: – METHODS
    private func saveToHistory(marsData: Mars) {
        try! realm.write {
            let history = History()
            history.selectedRover = selectedRover.rawValue
            history.selectedCamera = selectedCamera.rawValue
            history.selectedEarthDate = selectedDate
            realm.add(history)
        }
    }
    
    private func saveFilterHistory() {
        try! realm.write {
            let filterHistory = History()
            filterHistory.selectedRover = selectedRover.rawValue
            filterHistory.selectedCamera = selectedCamera.rawValue
            filterHistory.selectedEarthDate = selectedDate
            realm.add(filterHistory)
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: selectedDate)
    }
}
