//
//  EventView.swift
//  Friends
//
//  Created by тимур on 31.03.2025.
//

import SwiftUI

struct ViewEventView: View {
    @StateObject var viewModel: ViewEventViewModel
    @State var isShowingSelectFriendsView: Bool = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Header(viewModel: viewModel)
                .padding([.horizontal, .top])

            List {
                Section {
                    Text(viewModel.event.title)
                    Text(viewModel.event.description)
                }

                Section {
                    LocationView(address: viewModel.event.address)
                }

                Section {
                    FriendsList(attendiesInfo: viewModel.attendiesInfo)
                } header: {
                    Text("friends")
                }

                Section {
                    VStack(alignment: .trailing) {
                        DaysView(viewModel: viewModel)
                            .padding(.leading, 20)

                        HStack {
                            HoursView()

                            TimeGrid(selectedCells: $viewModel.selectedCells, rows: 16, columns: 7, isEditable: viewModel.myStatus == .noReply)
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
        }
        .background(Color.background)
        .onAppear {
            viewModel.loadFriends()
        }
    }

    private struct Header: View {
        @ObservedObject var viewModel: ViewEventViewModel
        @Environment(\.dismiss) var dismiss

        var body: some View {
            ZStack(alignment: .trailing) {
                HStack {
                    Spacer()
                    if viewModel.isHost {
                        Text(viewModel.event.isTimeFixed ? "View Event" : "Choose Time")
                            .fontWeight(.medium)
                    }
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
        let attendiesInfo: [(Person, EventModels.AttendanceStatus)]

        var body: some View {
            ForEach(attendiesInfo, id: \.0.id) { info in
                HStack {
                    Image(uiImage: info.0.icon)
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                        .clipShape(Circle())
                    Text(info.0.name)
                    Spacer()
                    switch info.1 {
                    case .attending:
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.green)
                    case .declined:
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.red)
                    case .noReply:
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundStyle(Color.yellow)
                    }
                }
            }
        }
    }

    private struct LocationView: View {
        let address: String

        var body: some View {
            HStack {
                Image(systemName: "location.square.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(Color.blue)
                Text(address)
            }
        }
    }

    private struct DaysView: View {
        @ObservedObject var viewModel: ViewEventViewModel

        var body: some View {
            HStack {
                ForEach(0..<7) { offset in
                    let date = viewModel.event.creationDate.addingTimeInterval(TimeInterval(86400 * offset))
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
