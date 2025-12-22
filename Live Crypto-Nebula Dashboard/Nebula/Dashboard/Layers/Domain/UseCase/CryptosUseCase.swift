//
//  CryptosUseCase.swift
//  Live Crypto-Nebula Dashboard
//
//  Created by Tiago Oliveira on 21/12/25.
//

import Foundation

protocol GetTopCryptosUseCase {
    func execute() async throws -> [TickerModel]
}

final class GetTop20CryptosUseCaseImpl: GetTopCryptosUseCase {
    private let repository: CryptoRepository

    init(repository: CryptoRepository) {
        self.repository = repository
    }

    func execute() async throws -> [TickerModel] {
        let tickers = try await repository.fetchAllTickers()

        return tickers
            .filter { $0.symbol.hasSuffix("USDT") }
            .sorted { $0.quoteVolume > $1.quoteVolume }
            .prefix(20)
            .map { $0 }
    }
}
