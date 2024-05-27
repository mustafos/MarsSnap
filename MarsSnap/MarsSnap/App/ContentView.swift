//
//  ContentView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 11.04.2024.
//  Copyright © 2024 Mustafa Bekirov. All rights reserved.

import SwiftUI

struct ContentView: View {
    
    // MARK: – PROPERTIES
    @StateObject var networkManager = MarsPhotoManager.shared
    @State private var cardData = [Card]()
    @State private var showSaveFilterAlert: Bool = false
    @State private var isSheetCameraPresented: Bool = false
    @State private var isSheetRoverPresented: Bool = false
    @State private var selectedRoverFilter = String()
    @State private var selectedCameraFilter = String()
    @State private var presentDatePickerFilter: Bool = false
    @State private var selectedDate = Date()
    @State private var tempSelectedDate = Date()
    @State private var shouldLoadMoreData = true
    @State private var showProgress: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
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
                
                if isSheetRoverPresented {
                    GeneralFilterComponent(isFilterCamera: false, selectedFilter: $selectedRoverFilter)
                        .onNegativeButtonTap {
                            isSheetRoverPresented.toggle()
                        }
                        .onPositiveButtonTap { filter in
                            isSheetRoverPresented.toggle()
                            selectedRoverFilter = filter
                        }
                }
                
                if isSheetCameraPresented {
                    GeneralFilterComponent(selectedFilter: $selectedCameraFilter)
                        .onNegativeButtonTap {
                            isSheetCameraPresented.toggle()
                        }
                        .onPositiveButtonTap { filter in
                            isSheetCameraPresented.toggle()
                            selectedCameraFilter = filter
                        }
                }
                
                Group {
                    VStack {
                        HeaderView()
                        ZStack {
                            if showProgress {
                                ProgressView()
                            } else {
                                ScrollView(.vertical, showsIndicators: true) {
                                    Spacer()
                                    ForEach(cardData, id: \.self) { photo in
                                        NavigationLink(destination: MarsImageView(marsPhoto: photo)) {
                                            CardComponent(mars: photo)
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
                                } //: SCROLL
                            }
                        } //: ZSTACK
                        .background(Color.backgroundOne)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                        .alert(isPresented: $showError) {
                            Alert(title: Text(errorMessage))
                        }
                        .task {
                            showProgress = true
                            networkManager.fetchEmployees(from: Link.photos.url) { result in
                                showProgress = false
                                switch result {
                                case .success(let newPhotos):
                                    cardData = newPhotos
                                case .failure(let someError):
                                    errorMessage = warningMessage(error: someError)
                                    showError = true
                                }
                            }
                        }
                    } //: VSTACK
                    .background(Color.accentOne)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
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
                            Constants.feedback.impactOccurred()
                            // TODO: – Save data from filter
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
                        Constants.feedback.impactOccurred()
                        presentDatePickerFilter.toggle()
                    }
                }, label: {
                    Image("calendar")
                })
            } //: HSTACK
            HStack {
                Button(action: {
                    withAnimation {
                        Constants.feedback.impactOccurred()
                        isSheetRoverPresented.toggle()
                    }
                }, label: {
                    HStack(alignment: .center, spacing: 7) {
                        Image("cpu")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24, alignment: .center)
                        
                        Text(selectedRoverFilter.isEmpty ? "All" : selectedRoverFilter)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .lineLimit(1)
                        
                        Spacer()
                    } //: HSTACK
                    .padding(7)
                    .background(Color.white.cornerRadius(10))
                }) //: BUTTON
                Button(action: {
                    withAnimation {
                        Constants.feedback.impactOccurred()
                        isSheetCameraPresented.toggle()
                    }
                }, label: {
                    HStack(alignment: .center, spacing: 7) {
                        Image("camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24, alignment: .center)
                        
                        Text(selectedCameraFilter.isEmpty ? "All" : selectedCameraFilter)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .lineLimit(1)
                        
                        Spacer()
                    } //: HSTACK
                    .padding(7)
                    .background(Color.white.cornerRadius(10))
                }) //: BUTTON
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        Constants.feedback.impactOccurred()
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
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: selectedDate)
    }
}
