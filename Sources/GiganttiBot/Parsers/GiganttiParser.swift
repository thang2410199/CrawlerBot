//
//  GiganttiParser.swift
//  
//
//  Created by Thang Ngo Quoc on 8.12.2021.
//

import Foundation
import SwiftSoup

class GiganttiParser: Parser {

    func parse(source: String, item: Item) throws -> [DiscountedItem] {
        print("Start parsing")
        let doc = try SwiftSoup.parse(source)
        let div = try doc.getElementById("searchProductsInfo")
        let itemContainers = try div?.getElementsByClass("col-mini-product")

        var results = [DiscountedItem]()

        try itemContainers?.forEach {
            let linkElement = try $0.select("a").first()!
            let link = try linkElement.attr("href")
            let name = try linkElement.attr("title")

            let normalPrice = try $0.getElementsByClass("sales-point").first()?.text()
                .replacingOccurrences(of: "Hinta uutena:", with: "").trimmed()
            let price = String(try $0.getElementsByClass("product-price").first()!.text()
                .split(separator: " ").first!)

            let pathId = (try? $0.select("path").first()?.id()) ?? ""
            let energyClass = getEnergyClass(from: pathId)

            print("Found item: \(name) price \(price) normalPrice \(normalPrice)")

            if let normalPrice = Double(normalPrice ?? price), let price = Double(price) {
                let discountedItem = DiscountedItem(
                    price: price,
                    normalPrice: normalPrice,
                    energyClass: energyClass,
                    name: name,
                    link: link
                )

                if discountedItem.discountPercentage >= item.requiredDiscount &&
                    (energyClass ?? .G).value  <= (item.energyClass ?? .G).value  {
                    results.append(discountedItem)
                }
            }
        }

        print("Finish parsing")
        return results
    }

    private func getEnergyClass(from: String) -> ItemEnergyClass? {
        switch from {
        case "A-value":
            return .A
        case "B-value":
            return .B
        case "C-value":
            return .C
        case "D-value":
            return .D
        case "E-value":
            return .E
        case "F-value":
            return .F
        case "G-value":
            return .G
        default:
            return nil
        }
    }
}
