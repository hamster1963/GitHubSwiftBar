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
    var statusViewModel = StatusViewModel()

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        setupPopover()
    }

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "cabinet", accessibilityDescription: "Taskbar App")
            button.action = #selector(togglePopover(_:))
        }
    }

    private func setupPopover() {
        popover.contentViewController = NSHostingController(rootView: PopoverContentView(viewModel: workflowViewModel, statusModel: statusViewModel))
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover()
        } else {
            showPopover()
        }
    }

    func showPopover() {
        GlobalState.shared.isPopoverVisible = true
        if let button = statusItem?.button {
            workflowViewModel.startFetchingWorkflows(interval: 1)
            statusViewModel.startFetchingStatus(interval: 5)
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    func closePopover() {
        GlobalState.shared.isPopoverVisible = false
        workflowViewModel.timer?.cancel()
        popover.performClose(nil)
    }
}

struct PopoverContentView: View {
    @ObservedObject var viewModel: WorkflowViewModel
    @ObservedObject var statusModel: StatusViewModel // 使用 StateObject
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            userSection
            Divider()
            statusSection
            Divider()
            recentActionsSection
            Divider()
            tagsSection
            Divider()
            versionSection
            settingsAndQuitSection
        }
        .padding()
        .frame(width: 400)
    }

    private var userSection: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("User:")
                .opacity(0.5)
                .font(.caption)
                .frame(width: 50, alignment: .leading)

            Spacer()

            Text("Hasmter1963")
                .font(.caption)
                .fontWeight(.bold)
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .background(Color.blue.opacity(colorScheme == .dark ? 0.6 : 1))
                .cornerRadius(3)
                .foregroundColor(.white)
                .frame(width: 100, alignment: .trailing)
        }
    }
    
    private var statusSection: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("连接状态:")
                .opacity(0.5)
                .font(.caption)
                .frame(width: 50, alignment: .leading)
            
            Spacer()

            HStack(spacing: 3) {
                Image(systemName: statusModel.status ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(statusModel.status ? .green : .red)
                
                Text(statusModel.status ? "已连接" : "未连接")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 3)
                    .background(statusModel.status ? Color.green.opacity(colorScheme == .dark ? 0.6 : 1):Color.red.opacity(colorScheme == .dark ? 0.6 : 1))
                    .cornerRadius(3)
                    .foregroundColor(.white)
            }
            .frame(width: 100, alignment: .trailing)
        }
    }

    

    private var recentActionsSection: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Recent Actions")
                    .opacity(0.5)
                    .font(.caption)
                Spacer()
            }
            ForEach(viewModel.workflows) { workflow in
                ActionItemView(workflow: workflow)
            }
        }
    }

    private var tagsSection: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Tags")
                    .opacity(0.5)
                    .font(.caption)
                Spacer()
            }
            ForEach(tagsData, id: \.self) { tagText in
                TagItemView(text: tagText, tagViewModel: TagViewModel())
            }
        }
    }

    private var versionSection: some View {
        HStack {
            Text("Version 0.0.6")
                .opacity(0.5)
                .font(.caption)
            Spacer()
        }
    }

    private var settingsAndQuitSection: some View {
        VStack(spacing:5) {
            Button(action: {}) {
                HStack {
                    Image(systemName: "gear")
                    Text("Settings...")
                    Spacer()
                }
            }
            .buttonStyle(PlainButtonStyle())
            Button(action: { NSApplication.shared.terminate(nil) }) {
                HStack {
                    Image(systemName: "power")
                    Text("Quit")
                    Spacer()
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    private var tagsData: [String] {
        return [
            "hamster1963/HomeDash",
            "hamster1963/order-new-next",
            "hamster1963/home-everything-watcher",
            "hamster1963/home-bark-push-go",
            "hamster1963/hamster-blog-new",
            "hamster1963/GitHubSwiftBar",
            "KES-IT/KES-Speed-Backend",
            "KES-IT/Food-Order-Backend",
            "KES-IT/Speed-Cron",
            "pandora-next/deploy",
            "vercel/next.js",
            "gogf/gf"
        ]
    }
}

// struct PopoverContentView_Previews: PreviewProvider {
//    static var previews: some View{
//        PopoverContentView(viewModel: WorkflowViewModel())
//    }
// }
