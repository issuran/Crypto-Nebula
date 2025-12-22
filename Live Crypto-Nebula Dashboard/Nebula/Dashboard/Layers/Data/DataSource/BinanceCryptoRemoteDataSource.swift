//
//  BinanceCryptoRemoteDataSource.swift
//  Live Crypto-Nebula Dashboard
//
//  Created by Tiago Oliveira on 21/12/25.
//

import Foundation

protocol CryptoRemoteDataSource {
    func fetchTickers() async throws -> [TickerModel]
}

final class BinanceCryptoRemoteDataSource: CryptoRemoteDataSource {
    func fetchTickers() async throws -> [TickerModel] {
        let url = URL(string: "https://api.binance.com/api/v3/ticker/24hr")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([TickerModel].self, from: data)
    }
}
