import Foundation
import Alamofire
import Erik
import WebKit

var timer: Timer?
var postedItems = [DiscountedItem]()
var browser: Erik?

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
        item.shouldUseHeadlessBrowsing ? headlessCrawl(item) : htmlCrawl(item)
    }
}

func headlessCrawl(_ item: Item) {
    browser = Erik()
    browser?.visit(urlString: item.url) { _, _ in
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            browser?.currentContent { doc, error in
                handleInterestedItems(webSource: doc?.body?.toHTML, item: item)
            }
        }
    }
}

func htmlCrawl(_ item: Item) {
    AF.request(item.url).responseString { response in
        guard let webSource = response.value else {
            print("Error getting source from \(item.url)")
            return
        }
        
        handleInterestedItems(webSource: webSource, item: item)
    }
}

func handleInterestedItems(webSource: String?, item: Item) {
    if let webSource = webSource, let interestedItems = try? item.source.parser.parse(source: webSource, item: item) {
        let filteredItems = interestedItems.filter { !postedItems.contains($0) }
        if let message = formatMessage(items: filteredItems) {
            TelegramService(botToken: item.botToken).send(message: message, to: item.channelId)
        }
        postedItems.append(contentsOf: filteredItems)
        print("Finished crawl, found \(filteredItems.count) new items")
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
