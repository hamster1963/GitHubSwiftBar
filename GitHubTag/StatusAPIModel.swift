//
//  StatusAPIModel.swift
//  GitHubSwiftBar
//
//  Created by Hamster on 2023/12/4.
//

import Combine
import Foundation

struct StatusResponse: Codable {
    var code: Int
    var msg: String
}

class StatusViewModel: ObservableObject {
    @Published var status: Bool = false
    var timer: AnyCancellable?

    func fetchStatus() {
        guard let url = URL(string: "https://www.buycoffee.top/api/activity") else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }

            // 打印接收到的原始数据
            if let jsonString = String(data: data, encoding: .utf8) {
                print("接收到的 JSON 数据: \(jsonString)")
                if jsonString.starts(with: "data:") {
                    DispatchQueue.main.async {
                        self?.status = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.status = false
                    }
                }
            }

        }.resume()
    }

    func startFetchingStatus(interval: TimeInterval = 5) {
        fetchStatus()
        timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                self?.fetchStatus()
            }
    }
}
