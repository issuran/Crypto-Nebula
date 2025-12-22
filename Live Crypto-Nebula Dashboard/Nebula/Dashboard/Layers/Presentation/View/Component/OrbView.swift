//
//  Untitled.swift
//  Live Crypto-Nebula Dashboard
//
//  Created by Tiago Oliveira on 21/12/25.
//

import SwiftUI

struct OrbView: View {
    let ticker: TickerModel
    let namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            // Radial gradient
            Circle()
                .fill(
                    RadialGradient(colors: [.blue.opacity(0.8), .black],
                                   center: .center, startRadius: 1, endRadius: 60)
                )
                .matchedGeometryEffect(id: "shape_\(ticker.symbol)", in: namespace)
            
            VStack {
                Text(ticker.symbol.replacingOccurrences(of: "USDT", with: ""))
                    .font(.caption.bold())
                Text("$\(Double(ticker.weightedAvgPrice) ?? 0, specifier: "%.2f")")
                    .font(.system(size: 8, weight: .light))
            }
            .foregroundColor(.white)
        }
        .frame(width: 80, height: 80)
    }
}
