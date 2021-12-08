//
//  TelegramService.swift
//  
//
//  Created by Thang Ngo Quoc on 8.12.2021.
//

import Foundation
import TelegramBotSDK

class TelegramService {
    
    init(botToken: String) {
        bot = TelegramBot(token: botToken)
    }

    func send(message: String, to channelId: String) {
        bot.sendMessageSync(chatId: .channel(channelId), text: message)
    }

    private let bot: TelegramBot
}
