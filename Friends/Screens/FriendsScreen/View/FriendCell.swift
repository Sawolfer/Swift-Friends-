//
//  FriendCell.swift
//  Friends
//
//  Created by Алексей on 03.04.2025.
//

import SwiftUI

struct FriendCell: View {
    // MARK: Constants

    private enum Constants {
        static let wrapRadius: CGFloat = 20
        static let wrapOffsetV: CGFloat = 5

        static let itemOffset: CGFloat = 15
        static let titleFontSize: CGFloat = 14

        static let imageSpacingH: CGFloat = 15
        static let imageSize: CGFloat = 45
        static let imageSubtitleFontSize: CGFloat = 14
    }

    let title: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: Constants.wrapRadius)
                .fill(Color.white)
                .padding(.top, Constants.wrapOffsetV)
            HStack {
                Image("image")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: Constants.imageSize, height: Constants.imageSize)
                    .padding(.top, Constants.itemOffset)
                    .padding(.leading, Constants.itemOffset)
                Text(title)
                    .font(.system(size: Constants.titleFontSize, weight: .medium))
                    .padding(.top, Constants.itemOffset)
                    .padding(.leading, Constants.itemOffset)
            }
        }
    }
}
