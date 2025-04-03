//
//  GroupsView.swift
//  Friends
//
//  Created by Алексей on 31.03.2025.
//

import SwiftUI

enum Orientation {
    case vertical
    case horizontal
}

struct FriendsView: View {
    // MARK: - Constants

    private enum Constants {
        static let addButtonTitleFontSize: CGFloat = 14
        static let addButtonWidth: CGFloat = 100
        static let addButtonHeight: CGFloat = 30
        static let addButtonPadding: CGFloat = 20
    }

    @StateObject var viewModel: FriendsViewModel = FriendsViewModel()

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea(.all)
            VStack {
                SelectedSegmentedControlView(viewModel: viewModel)
                HStack {
                    Spacer()
                    Button(action: {
                        // TODO: Действие при нажатии
                    }, label: {
                        Text("Добавить +")
                            .frame(width: Constants.addButtonWidth, height: Constants.addButtonHeight)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .font(.system(size: Constants.addButtonTitleFontSize, weight: .bold))
                    })
                    .padding(.trailing, Constants.addButtonPadding)
                }
                ListsView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    FriendsView()
}
