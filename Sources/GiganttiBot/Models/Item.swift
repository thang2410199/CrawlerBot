//
//  Item.swift
//  
//
//  Created by Thang Ngo Quoc on 8.12.2021.
//

import Foundation

enum ItemSource: String, Codable {
    case gigantti

    var parser: Parser {
        switch self {
        case .gigantti: return GiganttiParser()
        }
    }
}

enum ItemEnergyClass: String, Codable {
    case A, B, C, D, E, F, G

    var value: Int {
        switch self {
        case .A:
            return 1
        case .B:
            return 2
        case .C:
            return 3
        case .D:
            return 4
        case .E:
            return 5
        case .F:
            return 6
        case .G:
            return 7
        }
    }
}

struct Item: Decodable {
    let source: ItemSource
    let url: String
    /// 0.4 for 40% off
    let requiredDiscount: Double
    let maximumPrice: Double?
    let minimumPrice: Double?
    let energyClass: ItemEnergyClass?
    let channelId: String
    let botToken: String
}

struct ItemCatelog: Decodable {
    let items: [Item]

    static func load() -> ItemCatelog {
        do {
            let url = Bundle.module.url(forResource: "Catalog", withExtension: "json")
            let data = try Data(contentsOf: url!)
            return try JSONDecoder().decode(ItemCatelog.self, from: data)
        } catch {
            assertionFailure(error.localizedDescription)
            fatalError()
        }
    }
}
