//
//  CryptoListViewModel.swift
//  Live Crypto-Nebula Dashboard
//
//  Created by Tiago Oliveira on 21/12/25.
//

import Foundation
import Combine

@MainActor
final class CryptoListViewModel: ObservableObject {
    @Published var cryptos: [TickerModel] = []

    private let getTopCryptosUseCase: GetTopCryptosUseCase
    private let priceStream: CryptoPriceStream
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        getTopCryptosUseCase: GetTopCryptosUseCase,
        priceStream: CryptoPriceStream = BinanceWebSocketService()
    ) {
        self.getTopCryptosUseCase = getTopCryptosUseCase
        self.priceStream = priceStream
    }

    func load() async {
        do {
            cryptos = try await getTopCryptosUseCase.execute()
            startLiveUpdates()
        } catch {
            print("Failed: \(error)")
        }
    }
    
    func startLiveUpdates() {
        let symbols = cryptos.map(\.symbol)
        
        priceStream.connect(symbols: symbols)
        
        priceStream.pricePublisher
            .throttle(
                for: .milliseconds(10),
                scheduler: RunLoop.main,
                latest: true
            )
            .sink { [weak self] update in
                self?.apply(update)
            }
            .store(in: &cancellables)
    }
    
    func stopLiveUpdates() {
        priceStream.disconnect()
        cancellables.removeAll()
    }
    
    private func apply(_ update: LivePriceUpdate) {
        guard let index = cryptos.firstIndex(where: { $0.symbol == update.s }) else {
            return
        }
        
        let old = cryptos[index]
        
        cryptos[index] = TickerModel(
            symbol: old.symbol,
            weightedAvgPrice: update.c,
            quoteVolume: old.quoteVolume
        )
    }
}
