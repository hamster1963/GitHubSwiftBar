//
//  GitHubTagApp.swift
//  GitHubTag
//
//  Created by Hamster on 2023/11/23.
//

import AppKit
import SwiftUI

@main
struct GitHubTagApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class GlobalState: ObservableObject {
    static let shared = GlobalState()
    @Published var isPopoverVisible: Bool = false
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover = NSPopover()
    var workflowViewModel = WorkflowViewModel()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // 创建状态栏项
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "cabinet", accessibilityDescription: "Taskbar App")
            button.action = #selector(togglePopover(_:))
        }

        // 设置弹出视图的内容
        popover.contentViewController = NSHostingController(rootView: PopoverContentView(viewModel: workflowViewModel))
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover()
        } else {
            showPopover()
        }
    }

    func showPopover() {
        print("Popover 显示")
        GlobalState.shared.isPopoverVisible = true
        if let button = statusItem?.button {
            workflowViewModel.startFetchingWorkflows(interval: 1) // 开始定时获取数据
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    func closePopover() {
        print("Popover 隐藏")
        GlobalState.shared.isPopoverVisible = false
        workflowViewModel.timer?.cancel() // 停止定时器
        popover.performClose(nil)
    }
}

struct PopoverContentView: View {
    @State private var isHovering = false // 用于跟踪鼠标悬停状态的状态变量
    @ObservedObject var viewModel: WorkflowViewModel
    @Environment(\.colorScheme) var colorScheme //

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("User:")
                    .opacity(0.5)
                    .font(.caption)
                    .frame(width: 50, alignment: .leading) // 给定宽度并左对齐

                Spacer() // 使用间隔器将两个文本视图分开

                Text("Hasmter1963") // 使用来自 viewModel 的动态数据
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 3)
                    .background(Color.blue.opacity(colorScheme == .dark ? 0.6 : 1))
                    .cornerRadius(3)
                    .foregroundColor(.white)
                    .frame(width: 100, alignment: .trailing) // 给定宽度并右对齐
            }

            Divider()
            HStack {
                Text("Recent Actions")
                    .opacity(0.5)
                    .font(.caption)
                Spacer()
            }
            VStack(spacing: 5) {
                ForEach(viewModel.workflows) { workflow in
                    ActionItemView(workflow: workflow)
                }
            }
            .onAppear {
                viewModel.startFetchingWorkflows(interval: 5) // 开始定时获取数据
            }
            .onDisappear {
                viewModel.timer?.cancel() // 停止定时器
            }

            Divider()
            HStack {
                Text("Tags")
                    .opacity(0.5)
                    .font(.caption)
            }
            VStack(spacing: 5) {
                TagItemView(text: "hamster1963/HomeDash", tagViewModel: TagViewModel())
                TagItemView(text: "hamster1963/order-new-next", tagViewModel: TagViewModel())
                TagItemView(text: "hamster1963/home-everything-watcher", tagViewModel: TagViewModel())
                TagItemView(text: "hamster1963/home-bark-push-go", tagViewModel: TagViewModel())
                TagItemView(text: "hamster1963/hamster-blog-new", tagViewModel: TagViewModel())
                TagItemView(text: "KES-IT/KES-Speed-Backend", tagViewModel: TagViewModel())
                TagItemView(text: "KES-IT/Food-Order-Backend", tagViewModel: TagViewModel())
                TagItemView(text: "KES-IT/Speed-Cron", tagViewModel: TagViewModel())
                TagItemView(text: "pandora-next/deploy", tagViewModel: TagViewModel())
                TagItemView(text: "vercel/next.js", tagViewModel: TagViewModel())
                TagItemView(text: "gogf/gf", tagViewModel: TagViewModel())
            }

            Divider()
            HStack {
                Text("Version 0.0.4")
                    .opacity(0.5)
                    .font(.caption)
                Spacer()
            }

            VStack {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "gear")
                        Text("Settings...")
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            VStack {
                Button(action: {NSApplication.shared.terminate(nil)}) {
                    HStack {
                        Image(systemName: "power")
                        Text("Quit")
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .frame(width: 350)
    }
}

// struct PopoverContentView_Previews: PreviewProvider {
//    static var previews: some View{
//        PopoverContentView(viewModel: WorkflowViewModel())
//    }
// }
