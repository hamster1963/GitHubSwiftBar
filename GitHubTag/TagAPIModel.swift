//
//  TagAPIModel.swift
//  GitHubTag
//
//  Created by Hamster on 2023/11/24.
//

import Foundation
import Combine


struct TagResponse: Codable {
    var status: Int
    var msg: String
    var data: TagData
}

struct TagData: Codable {
    var tag: String
}

class TagViewModel: ObservableObject {
    @Published var tag: String = ""
    var timer: AnyCancellable?

    func fetchTag(for repo: String) {
        guard let url = URL(string: "http://120.24.211.49:10401/GetRepoLatestTag?repo=\(repo)") else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            // 打印接收到的原始数据
            // if let jsonString = String(data: data, encoding: .utf8) {
            //     print("接收到的 JSON 数据: \(jsonString)")
            // }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(TagResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.tag = response.data.tag
                }
            } catch {
                print("解码失败: \(error)")
            }
        }.resume()
    }
    func startFetchingTags(for repo: String,interval: TimeInterval = 60) {
        fetchTag(for: repo)
            timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
                .sink { [weak self] _ in
                    self?.fetchTag(for: repo)
                }
        }
}
