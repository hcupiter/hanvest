//
//  UserData.swift
//  hanvest
//
//  Created by Hans Arthur Cupiterson on 17/10/24.
//

import Foundation

struct UserDataEntity {
    var userId: String
    var userName: String
    var userBalance: Int
    var userRiskProfile: RiskProfileType
    var userInvestmentTransaction: [StockTransactionEntity]
    var transactionQueue: [StockTransactionEntity]
    var moduleCompletionList: [CompletionEntityType]
}

extension UserDataEntity {
    func mapToSchema() -> UserSchema {
        return UserSchema(
            id: self.userId,
            userName: self.userName,
            userBalance: self.userBalance,
            userRiskProfile: self.userRiskProfile,
            userInvestmentTransactionID: self.userInvestmentTransaction.map { $0.transactionID },
            transactionQueueID: self.transactionQueue.map { $0.transactionID },
            moduleCompletionList: self.moduleCompletionList
        )
    }
}


extension UserDataEntity {
    static func mock() -> UserDataEntity {
        return UserDataEntity(
            userId: UUID().uuidString,
            userName: "Bryon",
            userBalance: 2000000,
            userRiskProfile: .aggresive,
            userInvestmentTransaction: StockTransactionEntity.mock(),
            transactionQueue: [
                StockTransactionEntity(
                    transactionID: UUID().uuidString,
                    stockIDName: "BBRI",
                    priceAtPurchase: 1000,
                    stockLotQuantity: 2,
                    time: Date.now
                )
            ],
            moduleCompletionList: [.module01, .module02]
        )
    }
}