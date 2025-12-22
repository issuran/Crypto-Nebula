//
//  DetailView.swift
//  Live Crypto-Nebula Dashboard
//
//  Created by Tiago Oliveira on 21/12/25.
//

import SwiftUI

struct DetailView: View {
    let ticker: TickerModel
    let namespace: Namespace.ID
    var onClose: () -> Void
    
    var body: some View {
        VStack {
            // This circle matches the orb from the dashboard
            Circle()
                .fill(Color.blue.opacity(0.2))
                .matchedGeometryEffect(id: "shape_\(ticker.symbol)", in: namespace)
                .frame(height: 300)
                .overlay(
                    VStack {
                        Text(ticker.symbol).font(.largeTitle.bold())
                        Text("Volume: \(ticker.quoteVolume)")
                    }
                )
            
            // Placeholder for high-frequency price chart
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.2))
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(Text("Live Chart (Async Data)").foregroundColor(.gray))
            
            Button("Close", action: onClose)
                .buttonStyle(.borderedProminent)
        }
        .background(Color.black)
        .ignoresSafeArea()
    }
}
