//
//  CryptoPriceStream.swift
//  Live Crypto-Nebula Dashboard
//
//  Created by Tiago Oliveira on 22/12/25.
//

import Foundation
import Combine

protocol CryptoPriceStream {
    var pricePublisher: AnyPublisher<LivePriceUpdate, Never> { get }
    func connect(symbols: [String])
    func disconnect()
}

final class BinanceWebSocketService: CryptoPriceStream {
    private var webSocketTask: URLSessionWebSocketTask?
    private let subject = PassthroughSubject<LivePriceUpdate, Never>()
    private let decoder = JSONDecoder()

    var pricePublisher: AnyPublisher<LivePriceUpdate, Never> {
        subject.eraseToAnyPublisher()
    }

    func connect(symbols: [String]) {
        let streams = symbols
            .map { "\($0.lowercased())@miniTicker" }
            .joined(separator: "/")

        let url = URL(
            string: "wss://stream.binance.com:9443/stream?streams=\(streams)"
        )!

        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()

        receive()
    }

    private func receive() {
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }

            if case let .success(.string(text)) = result,
               let data = text.data(using: .utf8),
               let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let payload = root["data"],
               let payloadData = try? JSONSerialization.data(withJSONObject: payload),
               let update = try? decoder.decode(LivePriceUpdate.self, from: payloadData) {

                subject.send(update)
            }

            self.receive()
        }
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
    }
}
