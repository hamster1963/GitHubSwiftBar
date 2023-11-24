//
//  ActionItem.swift
//  GitHubTag
//
//  Created by Hamster on 2023/11/23.
//

import Foundation


import Foundation
import SwiftUI

struct ActionItemView: View {
    var workflow: Workflow
    @Environment(\.colorScheme) var colorScheme // 添加环境属性以获取当前的颜色方案
        
        var body: some View {
            HStack {
                Text(workflow.repo) // Use workflow name
                    .fontWeight(.medium)

                Spacer()

                Image(systemName: self.iconName(for: workflow.workflowStatus))
                    .foregroundColor(self.iconColor(for: workflow.workflowStatus))
                    .font(.caption)

                Text(workflow.workflowName) // Use update time or another relevant property as badge text
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 3)
                    .background(self.backgroundColor(for: workflow.workflowStatus))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
        }
    
    // 辅助方法，用于根据状态确定图标名称、颜色和背景颜色
    func iconName(for status: String) -> String {
        switch status {
        case "queued":
            return "hourglass"
        case "in_progress":
            return "hourglass"
        case "completed":
            return "checkmark.circle"
        case "error":
            return "xmark.circle"
        default:
            return ""
        }
    }
    
    func iconColor(for status: String) -> Color {
        switch status {
        case "queued":
            return .orange // 或表示加载中的任何颜色
        case "in_progress":
            return .blue // 或表示加载中的任何颜色
        case "completed":
            return .green
        case "error":
            return .red
        default:
            return .indigo
        }
    }
    
    func backgroundColor(for status: String) -> Color {
            let opacity: Double = colorScheme == .dark ? 0.6 : 1 // 根据模式调整透明度

            switch status {
            case "queued":
                return .orange.opacity(opacity)
            case "in_progress":
                return .blue.opacity(opacity)
            case "completed":
                return .green.opacity(opacity)
            case "error":
                return .red.opacity(opacity)
            default:
                return .gray.opacity(opacity) // 默认值也许需要调整
            }
        }
}

