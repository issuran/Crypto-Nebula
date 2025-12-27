//
//  LivePriceUpdateModel.swift
//  Live Crypto-Nebula Dashboard
//
//  Created by Tiago Oliveira on 22/12/25.
//

@preconcurrency import Combine
import Foundation

struct LivePriceUpdate: Decodable, Sendable {
    let s: String   // symbol
    let c: String   // last price
}
