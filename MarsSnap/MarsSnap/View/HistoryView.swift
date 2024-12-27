//
//  HistoryView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 12.04.2022.
//  Copyright © 2022 Mustafa Bekirov. All rights reserved.

//import SwiftUI
//
//struct HistoryView: View {
//    
//    // MARK: – PROPERTIES
//    @Environment(\.presentationMode) var presentationMode
//    @State private var history = [Card]()
//    @State private var showFilterMenuSheet: Bool = false
//    
//    // MARK: – BODY
//    var body: some View {
//        VStack {
//            HeaderView()
//            ZStack {
//                ScrollView(.vertical, showsIndicators: false) {
//                    Spacer()
//                    if !history.isEmpty {
//                        ForEach(history, id: \.self) { history in
//                            FilterCardComponent(history: history)
//                                .onTapGesture {
//                                    showFilterMenuSheet.toggle()
//                                }
//                        } //: LOOP
//                        
//                        HStack {
//                            Spacer()
//                            Text("Copyright © 2024 Mustafa Bekirov. \nAll rights reserved.")
//                                .font(.footnote)
//                                .multilineTextAlignment(.center)
//                            Spacer()
//                        } //: HSTACK
//                        .padding(10)
//                    } else {
//                        ZStack {
//                            Image("empty")
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 193, height: 186)
//                                .padding(.top, 200)
//                        }
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    }
//                } //: SCROLL
//            } //: ZSTACK
//            .background(Color.backgroundOne)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .edgesIgnoringSafeArea(.all)
//        } //: VSTACK
//        .navigationBarBackButtonHidden(true)
//        .background(Color.accentOne)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .edgesIgnoringSafeArea(.all)
//        .actionSheet(isPresented: $showFilterMenuSheet, content: filterSheet)
//    }
//    
//    private func filterSheet() -> ActionSheet {
//        let useButton = ActionSheet.Button.default(Text("Use")) {
//            withAnimation {
//                Constants.feedback.impactOccurred()
//            }
//        }
//        let deleteOutButton = ActionSheet.Button.destructive(Text("Delete")) {
//            withAnimation {
//                Constants.feedback.impactOccurred()
//                    showFilterMenuSheet = false
//            }
//        }
//        let cancelButton = ActionSheet.Button.cancel(Text("Cancel")) {
//            withAnimation {
//                Constants.feedback.impactOccurred()
//            }
//        }
//        let buttons: [ActionSheet.Button] = [useButton, deleteOutButton, cancelButton]
//        
//        return ActionSheet(title: Text("Menu Filter"), buttons: buttons)
//    }
//    
//    @ViewBuilder
//    private func HeaderView() -> some View {
//        ZStack {
//            HStack {
//                Button {
//                    withAnimation {
//                        Constants.feedback.impactOccurred()
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                } label: {
//                    Image("back")
//                        .frame(width: 44, height: 44)
//                }
//                Spacer()
//            } //: HSTACK
//            Text("History")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//        } //: ZSTACK
//        .padding(.top, 50)
//        .padding(.horizontal)
//        .padding(.bottom, 10)
//        .background(Color.accentOne)
//        .edgesIgnoringSafeArea(.all)
//    }
//}
