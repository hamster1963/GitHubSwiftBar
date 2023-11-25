//
//  TagItem.swift
//  GitHubTag
//
//  Created by Hamster on 2023/11/23.
//

import Foundation
import SwiftUI

struct TagItemView: View {
    var text: String
    @StateObject var tagViewModel: TagViewModel // 使用 StateObject
    @Environment(\.colorScheme) var colorScheme // 添加环境属性以获取当前的颜色方案
    @ObservedObject private var globalState = GlobalState.shared

    var body: some View {
        HStack {
            Text(text.split(separator: Character("/"))[1])
                .fontWeight(.medium)

            Spacer() // Pushes the badge to the right

            Text(tagViewModel.tag) // 使用来自 viewModel 的动态数据
                .font(.caption)
                .fontWeight(.bold)
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .background(Color.indigo.opacity(colorScheme == .dark ? 0.6 : 1))
                .cornerRadius(3)
                .foregroundColor(.white)
        }
        .onAppear {
            handleVisibilityChange(isVisible: globalState.isPopoverVisible)
        }
        .onChange(of: globalState.isPopoverVisible) { isVisible in
            handleVisibilityChange(isVisible: isVisible)
        }
    }

    private func handleVisibilityChange(isVisible: Bool) {
        if isVisible {
            tagViewModel.startFetchingTags(for: text, interval: 5)
        } else {
            tagViewModel.timer?.cancel()
        }
    }
}
