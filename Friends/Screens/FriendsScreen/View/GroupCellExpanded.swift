//
//  GroupCellExpanded.swift
//  Friends
//
//  Created by Алексей on 03.04.2025.
//

import SwiftUI

struct GroupCellExpanded: View {
    // MARK: Constants

    private enum Constants {
        static let imageSpacingH: CGFloat = 15
        static let imageSize: CGFloat = 45
        static let imageSubtitleFontSize: CGFloat = 14
    }

    @Binding var friends: [Person]
    let namespace: Namespace.ID

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.imageSpacingH) {
            ForEach(friends.indices, id: \.self) { index in
                HStack {
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
        }
    }
}
