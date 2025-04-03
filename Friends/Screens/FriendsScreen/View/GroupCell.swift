//
//  GroupCell.swift
//  Friends
//
//  Created by Алексей on 03.04.2025.
//

import SwiftUI

struct GroupCell: View {
    // MARK: Constants

    private enum Constants {
        static let wrapRadius: CGFloat = 20
        static let wrapOffsetV: CGFloat = 5

        static let itemOffset: CGFloat = 15
        static let titleFontSize: CGFloat = 24
    }

    @ObservedObject var viewModel: FriendsViewModel
    @Binding var group: GroupModels.Group
    @State var orientation: Orientation = .horizontal
    @Namespace var animationNamespace

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: Constants.wrapRadius)
                .fill(Color.white)
                .padding(.top, Constants.wrapOffsetV)

            VStack(alignment: .leading) {
                Text(group.title)
                    .font(.system(size: Constants.titleFontSize, weight: .medium))
                    .padding(.top, Constants.itemOffset)
                    .padding(.leading, Constants.itemOffset)
                Group {
                    switch orientation {
                    case .horizontal:
                        GroupCellPreview(viewModel: viewModel, friends: $group.friends, namespace: animationNamespace)
                    case .vertical:
                        GroupCellExpanded(friends: $group.friends, namespace: animationNamespace)
                    }
                }
                .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.8), value: orientation)
                .padding(.leading, Constants.itemOffset)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: orientation)
        .onTapGesture {
            switch orientation {
            case .vertical:
                orientation = .horizontal
            case .horizontal:
                orientation = .vertical
            }
        }
    }
}
