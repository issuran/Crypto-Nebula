//
//  TickerModel.swift
//  Live Crypto-Nebula Dashboard
//
//  Created by Tiago Oliveira on 21/12/25.
//

import Foundation

struct TickerModel: Codable {
    let symbol: String
    let weightedAvgPrice: String
    let quoteVolume: String
}
