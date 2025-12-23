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
    
    private var price: Double {
        Double(ticker.weightedAvgPrice) ?? 0
    }
    
    private var energy: Double {
        min(max(price / 50_000, 0.6), 1.4)
    }
    
    private var orbColor: Color {
        switch energy {
        case ..<0.9: return .blue
        case ..<1.1: return .purple
        default: return .pink
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            orbColor.opacity(0.9),
                            orbColor.opacity(0.2),
                            .black
                        ],
                        center: .center,
                        startRadius: 1,
                        endRadius: 80
                    )
                )
                .scaleEffect(energy)
                .blur(radius: 20)
                .clipShape(Circle())
                .drawingGroup()
            
            // Core Orb
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            orbColor.opacity(0.9),
                            orbColor.opacity(0.2),
                            .black
                        ],
                        center: .center,
                        startRadius: 1,
                        endRadius: 80
                    )
                )
                .scaleEffect(energy)
                .blur(radius: 20)
                .compositingGroup()
                .clipShape(Circle())
                .drawingGroup()
            
            // Name and price
            VStack(spacing: 2) {
                Text(ticker.symbol.replacingOccurrences(of: "USDT", with: ""))
                    .font(.caption.bold())
                
                Text("$\(price, specifier: "%.2f")")
                    .font(.system(size: 8, weight: .light))
            }
            .foregroundColor(.white)
        }
        .frame(width: 80, height: 80)
    }
}
