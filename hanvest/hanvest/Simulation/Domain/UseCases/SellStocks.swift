//
//  SellStocks.swift
//  hanvest
//
//  Created by Hans Arthur Cupiterson on 29/10/24.
//

import Foundation

protocol SellStocks {
    func execute(
        userId: String,
        stockIDName: String,
        transaction: StockTransactionEntity
    ) -> Result<Bool, Error>
}

struct SellStocksImpl: SellStocks {
    let userRepo: UserRepository
    let investmentRepo: StockInvestmentRepository
    let transactionRepo: StockTransactionRepository
    
    func execute(
        userId: String,
        stockIDName: String,
        transaction: StockTransactionEntity
    ) -> Result<Bool, any Error> {
        do {            
            // Fetch Investment
            if let investment = investmentRepo.fetchBy(
                userID: userId,
                stockIDName: stockIDName
            ) {
                let fetchedTransactionList = transactionRepo.fetchWith(
                    investmentID: investment.investmentID
                )
                
                guard fetchedTransactionList.isEmpty == false else {
                    return .failure(SwiftDataError.noData(object: "no transaction found"))
                }
                
                let averageTransactionPrice = getAverage(transactionList: fetchedTransactionList)
                try investmentRepo.substract(
                    investmentID: investment.investmentID,
                    totalInvested: averageTransactionPrice,
                    lotPurchased: transaction.stockLotQuantity
                )
            }
            
            return .success(true)
        }
        catch {
            return .failure(error)
        }
    }
    
    func getAverage(transactionList: [StockTransactionSchema]) -> Int {
        let (totalTransactionAmount, totalInvestedLotAmount) = transactionList.reduce((0, 0)) { result, data in
            let amount = data.priceAtPurchase * data.stockLotQuantity * 100
            return (result.0 + amount, result.1 + data.stockLotQuantity)
        }
        
        guard totalInvestedLotAmount != 0 else { return 0 }
        
        return totalTransactionAmount / totalInvestedLotAmount
    }
}
