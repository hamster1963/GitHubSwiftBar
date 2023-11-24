//
//  ActionAPIModel.swift
//  GitHubTag
//
//  Created by Hamster on 2023/11/24.
//

import Foundation
import Combine

struct ApiResponse: Codable {
    var status: Int
    var msg: String
    var data: WorkflowData
}

struct WorkflowData: Codable {
    var workFlowList: [Workflow]

    enum CodingKeys: String, CodingKey {
        case workFlowList = "work_flow_list"
    }
}

struct Workflow: Codable, Identifiable {
    var id: Int
    var repo: String
    var workflowId: String
    var workflowName: String
    var workflowUrl: String
    var workflowStatus: String

    enum CodingKeys: String, CodingKey {
        case id, repo
        case workflowName = "workflow_name"
        case workflowUrl = "workflow_url"
        case workflowId = "workflow_id"
        case workflowStatus = "workflow_status"
    }
}


class WorkflowViewModel: ObservableObject {
    @Published var workflows = [Workflow]()
    var timer: AnyCancellable?

    func fetchWorkflows() {
        guard let url = URL(string: "http://120.24.211.49:10401/GetLatestWorkFlow") else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            

            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ApiResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.workflows = response.data.workFlowList
                }
            } catch {
                print("解码失败: \(error)")
            }
        }.resume()
    }
    
    func startFetchingWorkflows(interval: TimeInterval = 60) {
        fetchWorkflows()
            timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
                .sink { [weak self] _ in
                    self?.fetchWorkflows()
                }
        }
}
