//
//  GroupCellPreview.swift
//  Friends
//
//  Created by Алексей on 03.04.2025.
//

import SwiftUI

struct GroupCellPreview: View {
    // MARK: Constants

    private enum Constants {
        static let imageSpacingH: CGFloat = 15
        static let imageSize: CGFloat = 45
        static let imageSubtitleFontSize: CGFloat = 14

        static let extraFriendsBackgroundOpacity: CGFloat = 0.35
        static let previewFriendsLimit: Int = 4
    }

    @ObservedObject var viewModel: FriendsViewModel
    @Binding var friends: [Person]
    let namespace: Namespace.ID

    var body: some View {
        HStack(alignment: .top, spacing: Constants.imageSpacingH) {
            ForEach(friends.prefix(Constants.previewFriendsLimit).indices, id: \.self) { index in
                VStack {
                    Image("image")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                        .matchedGeometryEffect(id: "image\(index)", in: namespace)
                    Text(friends[index].name)
                        .font(.system(size: Constants.imageSubtitleFontSize, weight: .regular))
                        .matchedGeometryEffect(id: "text\(index)", in: namespace)
                }
            }
            if viewModel.getFriendsAndPreviewDifference(friendsCount: friends.count) > 0 {
                ZStack {
                    Circle()
                        .fill(Color(.lightGray).opacity(Constants.extraFriendsBackgroundOpacity))
                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                    Text("+" + String(viewModel.getFriendsAndPreviewDifference(friendsCount: friends.count)))
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}
