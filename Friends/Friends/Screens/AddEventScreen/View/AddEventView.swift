//
//  AddEventView.swift
//  Friends
//
//  Created by тимур on 27.03.2025.
//

import SwiftUI

struct AddEventView: View {
    @StateObject private var viewModel = AddEventViewModel(rows: 16, columns: 7)
    @State var isShowingSelectFriendsView: Bool = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            ZStack(alignment: .trailing) {
                HStack {
                    Spacer()
                    Text("New Event")
                        .fontWeight(.medium)
                    Spacer()
                }

                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    Spacer()
                    Button("Create") {
                        dismiss()
                    }
                    .disabled(viewModel.event.title.isEmpty || viewModel.selectedCells.isEmpty)
                    .fontWeight(.bold)
                }
            }
            .padding([.horizontal, .top])

            List {
                Section {
                    TextField("Title", text: $viewModel.event.title)
                    TextField("Description", text: $viewModel.event.description)
                }

                Section {
                    HStack {
                        Image(systemName: "location.square.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(Color.blue)
                        Toggle("Location", isOn: $viewModel.addLocation)
                    }
                    if viewModel.addLocation {
                        TextField("Start typing", text: $viewModel.locationText)
                    }
                }

                Section {
                    ForEach(viewModel.selectedFriendsList) { person in
                        HStack {
                            Image(uiImage: person.icon)
                                .resizable()
                                .frame(width: 40.0, height: 40.0)
                                .clipShape(Circle())
                            Text(person.name)
                            Spacer()
                        }
                    }

                    Button(viewModel.selectedFriends.isEmpty ? "Add Friends" : "Edit List") {
                        isShowingSelectFriendsView = true
                    }
                } header: {
                    Text("friends")
                }

                Section {
                    VStack(alignment: .trailing) {
                        HStack {
                                ForEach(0..<7) { offset in
                                    let date = Date().addingTimeInterval(TimeInterval(86400 * offset))
                                    Text("\(viewModel.getFormattedDate(from: date))")
                                        .font(.system(size: 16))
                                        .foregroundStyle(Color.gray)
                                        .frame(maxWidth: .infinity)
                                }
                        }
                        .padding(.leading, 20)

                        HStack {
                            VStack {
                                let hours = Array(8...23)
                                ForEach(hours, id: \.self) { hour in
                                    Text("\(hour)")
                                        .foregroundStyle(Color.gray)
                                        .font(.system(size: 12))
                                        .frame(maxHeight: .infinity)
                                }
                            }

                            TimeGrid(selectedCells: $viewModel.selectedCells, rows: 16, columns: 7)
                        }
                    }
                    .padding(.vertical)
                    .listRowBackground(Color.white)
                } header: {
                    HStack {
                        Text("Time")
                        Spacer()
                        Button(action: {
                            viewModel.selectAllCells()
                        }) {
                            Text("Select All")
                                .textCase(.none)
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                        }
                        .padding(.trailing, 10)
                        Button(action: {
                            viewModel.clearCells()
                        }) {
                            Text("Clear")
                                .textCase(.none)
                                .font(.system(size: 16))
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
            .sheet(isPresented: $isShowingSelectFriendsView) {
                SelectFriendsView(viewModel: viewModel)
            }
        }
        .background(Color.background)
    }
}
