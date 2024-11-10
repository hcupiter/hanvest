//
//  UserNotificationEntity.swift
//  hanvest
//
//  Created by Hans Arthur Cupiterson on 08/11/24.
//

import Foundation

struct UserNotificationEntity {
    var notificationID: String
    var releasedTime: Date
    var hasTriggered: Bool
    var stockNews: StockNewsEntity
}