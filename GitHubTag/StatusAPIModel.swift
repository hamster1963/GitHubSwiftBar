//
//  StatusAPIModel.swift
//  GitHubSwiftBar
//
//  Created by Hamster on 2023/12/4.
//

import Foundation
import Combine



struct StatusResponse: Codable {
    var code: Int
    var msg: String
}


class StatusViewModel: ObservableObject {
    @Published var status: Bool = false
    var timer: AnyCancellable?

    func fetchStatus() {
        guard let url = URL(string: "https://www.buycoffee.top/api/go-func/getPlaying") else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            // 打印接收到的原始数据
            // if let jsonString = String(data: data, encoding: .utf8) {
            //     print("接收到的 JSON 数据: \(jsonString)")
            // }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(StatusResponse.self, from: data)
                DispatchQueue.main.async {
                    if response.code == 200 {
                        self?.status = true
                    } else {
                        self?.status = false
                    }
                }
            } catch {
                print("解码失败: \(error)")
                self?.status = false
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


