//
//  Globais.swift
//  Cryptos
//
//  Created by Swift on 31/01/2018.
//  Copyright © 2018 Swift. All rights reserved.
//

import Foundation
import CoreData


var nome : String = ""
var simbolo : String = ""
var preco : String = ""
var strMarketCap : String = ""
var vol24h : String = ""
var percChange1h : String = ""
var percChange24h : String = ""
var percChange7D : String = ""




//MARK: - Propriedades
typealias Coins = [Coin]


struct Coin: Codable {
    var id, name, symbol, rank: String
    let priceUsd, priceBtc, the24HVolumeUsd, marketCapUsd: String
    let availableSupply, totalSupply: String
    let maxSupply: String?
    let percentChange1H, percentChange24H, percentChange7D, lastUpdated: String?
    let priceBrl, the24HVolumeBrl, marketCapBrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, symbol, rank
        case priceUsd = "price_usd"
        case priceBtc = "price_btc"
        case the24HVolumeUsd = "24h_volume_usd"
        case marketCapUsd = "market_cap_usd"
        case availableSupply = "available_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case percentChange1H = "percent_change_1h"
        case percentChange24H = "percent_change_24h"
        case percentChange7D = "percent_change_7d"
        case lastUpdated = "last_updated"
        case priceBrl = "price_brl"
        case the24HVolumeBrl = "24h_volume_brl"
        case marketCapBrl = "market_cap_brl"
    }
}

var moedas : Coins = []

var coinJSON : Coins = []

var coinFavoritos : Coins = []
var coinFavoritosTriagem : Coins = []


///////
func converteValor(_ preco : Double) -> String{
    var currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = NumberFormatter.Style.currency
    // localize to your grouping and decimal separator
    currencyFormatter.locale = NSLocale.current
    let priceString = currencyFormatter.string(from: preco as NSNumber)
return priceString!
    
}
///////


