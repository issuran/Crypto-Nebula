//
//  LivePriceUpdateModel.swift
//  Live Crypto-Nebula Dashboard
//
//  Created by Tiago Oliveira on 22/12/25.
//

import Foundation

struct LivePriceUpdate: Decodable {
    let s: String   // symbol
    let c: String   // last price
}
