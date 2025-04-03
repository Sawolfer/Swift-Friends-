//
//  AddEventView.swift
//  Friends
//
//  Created by тимур on 27.03.2025.
//

import SwiftUI

struct AddEventView: View {
    @StateObject private var viewModel = AddEventViewModel()
    @State var isShowingSelectFriendsView: Bool = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Header(viewModel: viewModel)
                .padding([.horizontal, .top])

            List {
                Section {
                    TextField("Title", text: $viewModel.event.title)
                    TextField("Description", text: $viewModel.event.description)
                }

                Section {
                    LocationView(addLocation: $viewModel.addLocation, address: $viewModel.event.address)
                }

                Section {
                    FriendsList(viewModel: viewModel, isShowingSelectFriendsView: $isShowingSelectFriendsView)
                } header: {
                    Text("friends")
                }

                Section {
                    VStack(alignment: .trailing) {
                        DaysView(viewModel: viewModel)
                            .padding(.leading, 20)

                        HStack {
                            HoursView()

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
                        }, label: {
                            Text("Select All")
                                .textCase(.none)
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                        })
                        .padding(.trailing, 10)
                        Button(action: {
                            viewModel.clearCells()
                        }, label: {
                            Text("Clear")
                                .textCase(.none)
                                .font(.system(size: 16))
                        })
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
            .sheet(isPresented: $isShowingSelectFriendsView) {
                SelectFriendsView(friends: viewModel.friends, selectedFriends: $viewModel.selectedFriends)
            }
        }
        .background(Color.background)
        .onAppear {
            viewModel.loadFriends()
        }
    }

    private struct Header: View {
        @ObservedObject var viewModel: AddEventViewModel
        @Environment(\.dismiss) var dismiss

        var body: some View {
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
        }
    }

    private struct FriendsList: View {
        @ObservedObject var viewModel: AddEventViewModel
        @Binding var isShowingSelectFriendsView: Bool

        var body: some View {
            ForEach(Array(viewModel.selectedFriends)) { person in
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
        }
    }

    private struct LocationView: View {
        @Binding var addLocation: Bool
        @Binding var address: String

        var body: some View {
            HStack {
                Image(systemName: "location.square.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(Color.blue)
                Toggle("Location", isOn: $addLocation)
            }

            if addLocation {
                TextField("Start typing", text: $address)
            }
        }
    }

    private struct DaysView: View {
        @ObservedObject var viewModel: AddEventViewModel

        var body: some View {
            HStack {
                ForEach(0..<7) { offset in
                    let date = Date().addingTimeInterval(TimeInterval(86400 * offset))
                    Text("\(viewModel.getFormattedDate(from: date))")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.gray)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private struct HoursView: View {
        var body: some View {
            VStack {
                let hours = Array(8...23)
                ForEach(hours, id: \.self) { hour in
                    Text("\(hour)")
                        .foregroundStyle(Color.gray)
                        .font(.system(size: 12))
                        .frame(maxHeight: .infinity)
                }
            }
        }
    }
}

#Preview {
    AddEventView()
}
