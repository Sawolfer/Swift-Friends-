//
//  AddEventView.swift
//  Friends
//
//  Created by тимур on 27.03.2025.
//

import SwiftUI

struct AddEventView: View {
    @StateObject private var viewModel = AddEventViewModel(rows: 16, columns: 7, event: EventModel())

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Button("Cancel") {}
                Spacer()
                Text("New Event")
                    .fontWeight(.medium)
                Spacer()
                Button("Add") {}
                    .fontWeight(.bold)
                    .disabled(true)
            }
            .padding([.horizontal, .top])

            List {
                Section {
                    TextField("Title", text: $viewModel.event.title)
                    TextField("Description", text: $viewModel.event.description)
                }
                
                Section {
                    HStack {
                        
                    }
                    
                    HStack {
                        
                    }
                    
                } header: {
                    Text("friends")
                }

                Section {
                    VStack(alignment: .trailing) {
                        HStack {
//                            Button("Select All") {
//                                viewModel.selectAllCells()
//                            }
//
//                            Spacer()

                            Button("Clear") {
                                viewModel.clearCells()
                            }
                        }
                        .padding(.vertical, 7)

                        HStack {
                            ForEach(0..<7) { offset in
                                let date = Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * offset))
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

                            ScheduleMatrix(selectedCells: $viewModel.selectedCells, rows: 16, columns: 7)
                        }
                        .padding(.bottom)
                    }
                    .listRowBackground(Color.white)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)

            Spacer()
        }
        .background(Color.background)
    }
}

// Preview
struct ContentView: View {
    @State private var showModal = true

    var body: some View {
        VStack {
            Text("Main View")
                .font(.largeTitle)
                .padding()

            Button("Show Modal") {
                showModal.toggle()
            }
            .sheet(isPresented: $showModal) {
                AddEventView()
            }
        }
    }
}

#Preview {
    ContentView()
}
