//
//  CryptoListViewModel.swift
//  Live Crypto-Nebula Dashboard
//
//  Created by Tiago Oliveira on 21/12/25.
//

import Combine

@MainActor
final class CryptoListViewModel: ObservableObject {
    @Published var cryptos: [TickerModel] = []

    private let getTopCryptosUseCase: GetTopCryptosUseCase

    init(getTopCryptosUseCase: GetTopCryptosUseCase) {
        self.getTopCryptosUseCase = getTopCryptosUseCase
    }

    func load() async {
        do {
            cryptos = try await getTopCryptosUseCase.execute()
        } catch {
            print(error)
        }
    }
}
