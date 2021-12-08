import Foundation
import Alamofire

var timer: Timer?
var postedItems = [DiscountedItem]()

func main() {
    let catalog = ItemCatelog.load()
    print("Catalog loaded")

    // Check every 5 minutes
    // TODO: Move configuration to a env file
    timer = Timer.scheduledTimer(withTimeInterval: 5 * 60, repeats: true) { _ in
        crawl(catalog: catalog)
    }
    timer?.fire()
}

func crawl(catalog: ItemCatelog) {
    print("Start crawl")
    for item in catalog.items {
        AF.request(item.url).responseString { response in
            guard let webSource = response.value else {
                print("Error getting source from \(item.url)")
                return
            }
            let parser = item.source.parser
            let interestedItems = try? parser.parse(source: webSource, item: item)
            if let interestedItems = interestedItems {
                let filteredItems = interestedItems.filter { !postedItems.contains($0) }
                if let message = formatMessage(items: filteredItems) {
                    TelegramService(botToken: item.botToken).send(message: message, to: item.channelId)
                }
                postedItems.append(contentsOf: filteredItems)
                print("Finished crawl, found \(filteredItems.count) new items")
            }
        }
    }
}

func formatMessage(items: [DiscountedItem]) -> String? {
    guard !items.isEmpty else {
        return nil
    }

    return items.map(\.telegramMessage).joined(separator: "\n")
}

extension String {

    mutating func line(_ string: String) {
        self += ("\n" + string)
    }
}

extension Double {

    func messageFormat() -> String {
        String(format: "%.02f", self)
    }

    func percentageMessageFormat() -> String {
        "-" + String(format: "%.00f", self * 100) + "%"
    }
}

main()
RunLoop.main.run()
