//
//  Module05Stage.swift
//  hanvest
//
//  Created by Hans Arthur Cupiterson on 25/10/24.
//

import Foundation

enum Module05Stage: Equatable {
    case buyStage(appRouter: any AppRouterProtocol)
    case sellStage (appRouter: any AppRouterProtocol)
    
    func onComplete(
        moduleRouter: any Module05RouterProtocol,
        profileViewModel: Module05ProfileViewModel,
        simulationViewModel: Module05SimulationViewModel,
        highlightViewModel: HighlightViewModel,
        transaction: TransactionStatusViewModel
    ) {
        switch self {
        case .buyStage(let appRouter):
            moduleRouter.popToRoot()
            moduleRouter.addProgress()
            moduleRouter.push(
                .sellStage(
                    appRouter: appRouter,
                    profileViewModel: profileViewModel,
                    simulationViewModel: simulationViewModel,
                    highlightViewModel: highlightViewModel
                )
            )
            simulationViewModel.currentStage = .sellStage(appRouter: appRouter)
            profileViewModel.addUserInvestmentTransaction(
                transaction:
                    StockInvestmentEntity(
                        investmentID: UUID().uuidString,
                        stockIDName: transaction.selectedStockIDName,
                        totalInvested: transaction.stockPrice * transaction.lotAmount * 100,
                        lotPurchased: transaction.lotAmount
                    )
            )
            
            simulationViewModel.appendNewStockPrice()

        case .sellStage(let appRouter):
            @Inject var validateModule: ValidateIfUserHasCompletedTheModule
            
            do {
                let hasCompletedModule = try validateModule.execute(specificModule: .module05)
                
                if hasCompletedModule {
                    appRouter.popToRoot()
                }
                else {
                    appRouter.push(
                        .moduleCompletion(completionItem: .module05)
                    )
                }
            }
            catch {
                debugPrint("[ERROR]: \(error)")
            }

        }
    }
}

extension Module05Stage {
    // Conform to Equatable
    static func == (lhs: Module05Stage, rhs: Module05Stage) -> Bool {
        switch (lhs, rhs) {
        case (.buyStage, .buyStage),
            (.sellStage, .sellStage):
            return true
            
        default:
            return false
        }
    }
}
