//
//  HistoryView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 12.04.2024.
//

import SwiftUI

struct HistoryView: View {
    
    // MARK: – PROPERTIES
    @ObservedObject var observer = MarsPhotoManager()
    @Environment(\.presentationMode) var presentationMode
    @State private var isEmptyHistory: Bool = true
    @State private var showFilterMenuSheet: Bool = false

    // MARK: – BODY
    var body: some View {
        VStack {
            HeaderView()
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    Spacer()
                    if isEmptyHistory {
                        ZStack {
                            Image("empty")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 193, height: 186)
                                .padding(.top, 200)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ForEach(observer.datas) { mars in
                            CardComponent(mars: mars, isFilterCard: true)
                                .onTapGesture {
                                    showFilterMenuSheet.toggle()
                                }
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
                    }
                } //: SCROLL
            } //: ZSTACK
            .background(Color.backgroundOne)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        } //: VSTACK
        .navigationBarBackButtonHidden(true)
        .background(Color.accentOne)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .actionSheet(isPresented: $showFilterMenuSheet, content: filterSheet)
    }
    
    private func filterSheet() -> ActionSheet {
        let useButton = ActionSheet.Button.default(Text("Use")) {
            withAnimation {
                feedback.impactOccurred()
            }
        }
        let deleteOutButton = ActionSheet.Button.destructive(Text("Delete")) {
            withAnimation {
                feedback.impactOccurred()
            }
        }
        let cancelButton = ActionSheet.Button.cancel(Text("Cancel")) {
            withAnimation {
                feedback.impactOccurred()
            }
        }
        let buttons: [ActionSheet.Button] = [useButton, deleteOutButton, cancelButton]
        
        return ActionSheet(title: Text("Menu Filter"), buttons: buttons)
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        ZStack {
            HStack {
                Button {
                    withAnimation {
                        feedback.impactOccurred()
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Image("back")
                        .frame(width: 44, height: 44)
                }
                Spacer()
            } //: HSTACK
            Text("History")
                .font(.largeTitle)
                .fontWeight(.bold)
        } //: ZSTACK
        .padding(.top, 50)
        .padding(.horizontal)
        .padding(.bottom, 10)
        .background(Color.accentOne)
        .edgesIgnoringSafeArea(.all)
    }
}
