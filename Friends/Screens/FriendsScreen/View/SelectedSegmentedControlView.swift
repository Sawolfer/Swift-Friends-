//
//  SelectedSegmentedControlView.swift
//  Friends
//
//  Created by Алексей on 03.04.2025.
//

import SwiftUI

struct SelectedSegmentedControlView: View {
    // MARK: - Constants

    private enum Constants {
        static let segmentedViewTopOffset: CGFloat = 75

        static let segmentedControlHeight: CGFloat = 40
        static let segmentedControlPadding: CGFloat = 15
    }

    @ObservedObject var viewModel: FriendsViewModel

    let segments = ["Группы", "Друзья"]

    var body: some View {
        Picker("", selection: $viewModel.selectedSegment) {
            ForEach(0..<segments.count, id: \.self) { index in
                Text(segments[index]).tag(index)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, Constants.segmentedControlPadding)
        .frame(height: Constants.segmentedControlHeight)
        .onChange(of: viewModel.selectedSegment) { _ in
            viewModel.segmentedChanged()
        }
    }
}
