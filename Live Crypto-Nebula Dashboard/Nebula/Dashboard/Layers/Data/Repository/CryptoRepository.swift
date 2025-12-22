//
//  CryptoRepositoryImpl.swift
//  Live Crypto-Nebula Dashboard
//
//  Created by Tiago Oliveira on 21/12/25.
//

import Foundation

protocol CryptoRepository {
    func fetchAllTickers() async throws -> [TickerModel]
}

final class CryptoRepositoryImpl: CryptoRepository {
    private let remoteDataSource: CryptoRemoteDataSource

    init(remoteDataSource: CryptoRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchAllTickers() async throws -> [TickerModel] {
        try await remoteDataSource.fetchTickers()
    }
}
