//
//  NebulaDashboardView.swift
//  Live Crypto-Nebula Dashboard
//
//  Created by Tiago Oliveira on 21/12/25.
//

import SwiftUI

struct NebulaDashboardView: View {
    // MARK: - Variables
    @ObservedObject var viewModel: CryptoListViewModel
    @Namespace private var nebulaNamespace
    @State private var selectedTicker: TickerModel?
    @State private var positions: [String: CGPoint] = [:]
    @State private var activeDragSymbol: String? = nil
    @State private var dragStartPosition: CGPoint?
    
    var body: some View {
        VStack {
            Button {
                viewModel.handleLiveUpdates()
            } label: {
                Text(viewModel.isNRTStreaming ? "Stop NRT" : "Start NRT")
            }
            
        }
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                // MARK: - Nebula Orbs
                if selectedTicker == nil {
                    ForEach(viewModel.cryptos, id: \.symbol) { ticker in
                        OrbView(
                            ticker: ticker,
                            namespace: nebulaNamespace
                        )
                        .position(
                            x: positions[ticker.symbol]?.x ?? 0,
                            y: positions[ticker.symbol]?.y ?? 0
                        )
                        .gesture(dragGesture(for: ticker))
                        .onTapGesture {
                            withAnimation(.heroSpring) {
                                selectedTicker = ticker
                            }
                        }
                    }
                }
                
                // MARK: - Detail View (Hero Transition)
                if let selected = selectedTicker {
                    DetailView(
                        ticker: selected,
                        namespace: nebulaNamespace
                    ) {
                        withAnimation(.heroSpring) {
                            selectedTicker = nil
                        }
                    }
                }
            }
            .task {
                await viewModel.load()
            }
            // Pass the geometry size to the function
            .onChange(of: viewModel.cryptos.count) { _, _ in
                initializePositionsIfNeeded(for: viewModel.cryptos, in: geometry.size)
            }
            .onAppear {
                // Initial load check
                initializePositionsIfNeeded(for: viewModel.cryptos, in: geometry.size)
            }
            .onDisappear {
                viewModel.stopLiveUpdates()
            }
        }
    }
}

// MARK: - Gestures

private extension NebulaDashboardView {
    func dragGesture(for ticker: TickerModel) -> some Gesture {
        DragGesture()
            .onChanged { value in
                if activeDragSymbol == nil {
                    activeDragSymbol = ticker.symbol
                    dragStartPosition = positions[ticker.symbol]
                }

                guard activeDragSymbol == ticker.symbol,
                      let start = dragStartPosition else { return }

                positions[ticker.symbol] = CGPoint(
                    x: start.x + value.translation.width,
                    y: start.y + value.translation.height
                )
            }
            .onEnded { _ in
                dragStartPosition = nil
                activeDragSymbol = nil
            }
    }
}

// MARK: - Position Initialization

private extension NebulaDashboardView {
    func initializePositionsIfNeeded(for tickers: [TickerModel], in size: CGSize) {
        guard positions.isEmpty else { return }
        
        for ticker in tickers {
            positions[ticker.symbol] = randomPosition(within: size)
        }
    }
    
    // Updated to use the provided size instead of UIScreen.main
    func randomPosition(within size: CGSize) -> CGPoint {
        return CGPoint(
            x: CGFloat.random(in: 80...(size.width - 80)),
            y: CGFloat.random(in: 120...(size.height - 200))
        )
    }
}

extension Animation {
    static var heroSpring: Animation {
        .spring(response: 0.6, dampingFraction: 0.8)
    }
}

#Preview {
    let remoteDataSource = BinanceCryptoRemoteDataSource()
    let repository = CryptoRepositoryImpl(
        remoteDataSource: remoteDataSource
    )
    let useCase = GetTop20CryptosUseCaseImpl(
        repository: repository
    )
    NebulaDashboardView(viewModel: CryptoListViewModel(getTopCryptosUseCase: useCase))
}
