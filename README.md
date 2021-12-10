# CrawlerBot

Crawler CLI tool to notify user on telegram channel / group when a new item fit required discount percentage is available

## Requirement

* MacOS with Xcode 13.1 installed
* Telegram bot token (add `BotFather` on Telegram, type in `/newbot`, follow instruction
* Channel id (Create a new channel on Telegram, add the bot there, send a message with @ mention the bot, use https://api.telegram.org/bot{BOT_TOKEN}/getUpdates to get the channel id)

## Setup

* Create a json file named `Catalog.json` in `Sources/GiganttiBot/Resources`
* Here is the example of the file:

```
{
    "items": [
        {
            "source": "gigantti",
            "url": "https://www.gigantti.fi/catalog/outlet/outlet-kodinkoneet/kodinkoneet-outlet?SearchParameter=%26%40QueryTerm%3D*%26ContextCategoryUUID%3DczqsGQWDzWoAAAFsHBphcvNw%26discontinued%3D0%26ManufacturerName%3DBosch%26online%3D1%26ProductListPrice%3D300%2B-%2B399_or_400%2B-%2B499%26Tyyppi%3DAstianpesukone%26%40Sort.ViewCount%3D1%26%40Sort.ProductListPrice%3D0&PageSize=12&ProductElementCount=&searchResultTab=Products&CategoryName=outlet-kodinkoneet&CategoryDomainName=store-gigantti-ProductCatalog#filter-sidebar",
            "energyClass": "D",
            "requiredDiscount": 0.4,
            "botToken": "{BOT_TOKEN}",
            "channelId": "{CHANNEL_ID}"
        }
    ]
}
```

The `energyClass` is optional, `requiredDiscount` represents the discount % you desire, in the example it's set to 40% off from normal price, only supported `source` is `gigantti` for now. Feel free to add more parser to the project.

## Usage

Run `swift run` in the repo dir to start getting message on Telegram channel
