//
//  VerkkokauppaParser.swift
//  
//
//  Created by Thang Ngo Quoc on 6.4.2022.
//

import Foundation
import SwiftSoup

class VerkkokauppaParser: Parser {
    func parse(source: String, item: Item) throws -> [DiscountedItem] {
        let doc = try SwiftSoup.parse(source)
        let items: [DiscountedItem]? = try? doc.select("article").map {
            let name = try? $0.select("a").first()?.attr("title")
            var priceString = try? $0.getElementsByAttributeValue("data-price", "current").first()?.attr("value")
            let price = Double(priceString!)
            priceString = try? $0.getElementsByAttributeValue("data-price", "previous").first()?.attr("value")
            let normalPrice = Double(priceString!)
            let link = "https://www.verkkokauppa.com" + (try! $0.select("a").first()?.attr("href") ?? "")
            return DiscountedItem(price: price!, normalPrice: normalPrice!, energyClass: nil, name: name!, link: link)
        }
        return filter(discountedItem: items, item: item)
    }
    
    private func filter(discountedItem: [DiscountedItem]?, item: Item) -> [DiscountedItem] {
        guard let discountedItem = discountedItem else {
            return []
        }
        
        return discountedItem.filter {
            if let minimumPrice = item.minimumPrice, $0.price < minimumPrice {
                return false
            }
            
            if let maximumPrice = item.maximumPrice, $0.price > maximumPrice {
                return false
            }
            
            if let normalPrice = $0.normalPrice, $0.price / normalPrice < item.requiredDiscount {
                return false
            }
            
            if let name = item.containName, !$0.name.contains(name) {
                return false
            }
            
            return true
        }
    }
}
