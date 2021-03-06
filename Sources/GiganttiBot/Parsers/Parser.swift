//
//  Parser.swift
//  
//
//  Created by Thang Ngo Quoc on 8.12.2021.
//

import Foundation

protocol Parser {
    
    func parse(source: String, item: Item) throws -> [DiscountedItem]
}

struct DiscountedItem: Equatable {
    let price: Double
    let normalPrice: Double?
    let energyClass: ItemEnergyClass?
    let name: String
    let link: String

    var discountPercentage: Double {
        guard let normalPrice = normalPrice else {
            return 0
        }

        return 1 - price / normalPrice
    }

    var discount: Double {
        max((normalPrice ?? 0) - price, 0)
    }

    var telegramMessage: String {
        var message = ""
        message.line(name)
        message.line("⚡️⚡️⚡️ " + discountPercentage.percentageMessageFormat())
        message.line("\(price.messageFormat()) normal price: \(normalPrice?.messageFormat() ?? "")")
        message.line(link)
        return message
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.link == rhs.link
    }
}
