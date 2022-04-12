//
//  JimmsParser.swift
//  
//
//  Created by Thang Ngo Quoc on 6.4.2022.
//

import Foundation
import SwiftSoup

class JimmsParser: Parser {
    func parse(source: String, item: Item) throws -> [DiscountedItem] {
        let doc = try SwiftSoup.parse(source)
        let items = try doc.getElementsByClass("p_listTmpl1")
        var result = [DiscountedItem]()
        
        for i in items {
            let div = try i.getElementsByClass("p_col_info").first()!
            if try div.getElementsByClass("ok1").size() > 0 {
                let link = try div.select("a").first()
                let name = try link?.text() ?? ""
                let url = "https://www.jimms.fi" + (try! link?.attr("href") ?? "")
                
                if let keyword = item.containName {
                    if name.contains(keyword) != true {
                        continue
                    }
                }
                
                let priceDiv = try i.getElementsByClass("p_col_price").first()!
                let priceString = try priceDiv.select("span").first()?.text().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "") ?? ""
                let price = (Double(priceString) ?? 0) / 100
                
                if let max = item.maximumPrice, price > max {
                    continue
                }
                
                if let min = item.minimumPrice, price < min {
                    continue
                }
                
                result.append(DiscountedItem(price: price, normalPrice: nil, energyClass: nil, name: name, link: url))
            }
        }
        
        return result
    }
}
