//
//  Live_Crypto_Nebula_DashboardApp.swift
//  Live Crypto-Nebula Dashboard
//
//  Created by Tiago Oliveira on 21/12/25.
//

import SwiftUI

@main
struct Live_Crypto_Nebula_DashboardApp: App {
    var body: some Scene {
        WindowGroup {
            let remoteDataSource = BinanceCryptoRemoteDataSource()
            let repository = CryptoRepositoryImpl(
                remoteDataSource: remoteDataSource
            )
            let useCase = GetTop20CryptosUseCaseImpl(
                repository: repository
            )
            
            NebulaDashboardView(
                viewModel: CryptoListViewModel(
                    getTopCryptosUseCase: useCase
                ))
        }
    }
}
