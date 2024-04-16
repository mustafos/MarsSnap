//
//  HistoryView.swift
//  MarsSnap
//
//  Created by Mustafa Bekirov on 12.04.2024.
//  Copyright © 2024 Mustafa Bekirov. All rights reserved.

import SwiftUI
import RealmSwift

struct HistoryView: View {
    
    // MARK: – PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.realm) var realm
    @State var filterHistory: Results<History>?
    @State private var showFilterMenuSheet: Bool = false
    
    // MARK: – BODY
    var body: some View {
        VStack {
            HeaderView()
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    Spacer()
                    if let filterHistory = filterHistory, !filterHistory.isEmpty {
                        ForEach(filterHistory, id: \.self) { history in
                            FilterCardComponent(history: history)
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
                    } else {
                        ZStack {
                            Image("empty")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 193, height: 186)
                                .padding(.top, 200)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    
    private func fetchFilterHistory() {
        filterHistory = realm.objects(History.self)
    }
    
    private func deleteFilterCard(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        if let history = filterHistory?[index] {
            try? realm.write {
                realm.delete(history)
            }
        }
    }
    
    private func filterSheet() -> ActionSheet {
        let useButton = ActionSheet.Button.default(Text("Use")) {
            withAnimation {
                Constants.feedback.impactOccurred()
            }
        }
        let deleteOutButton = ActionSheet.Button.destructive(Text("Delete")) {
            withAnimation {
                Constants.feedback.impactOccurred()
                if let _ = filterHistory {
                    showFilterMenuSheet = false
                    deleteFilterCard(at: IndexSet(integer: 0))
                }
            }
        }
        let cancelButton = ActionSheet.Button.cancel(Text("Cancel")) {
            withAnimation {
                Constants.feedback.impactOccurred()
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
                        Constants.feedback.impactOccurred()
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
