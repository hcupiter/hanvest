//
//  MaterialSimulationConfirmationSellView.swift
//  hanvest
//
//  Created by Hans Arthur Cupiterson on 26/10/24.
//

import SwiftUI

struct Module05ConfirmationSellView: View {
    let moduleRouter: any Module05RouterProtocol
    
    @ObservedObject var profileViewModel: Module05ProfileViewModel
    @ObservedObject var simulationViewModel: Module05SimulationViewModel
    @ObservedObject var highlightViewModel: HighlightViewModel
    
    @StateObject var viewmodel = SellingStockDataViewModel()
    
    var body: some View {
        if let stock = simulationViewModel.selectedStock {
            VStack {
                HanvestNavigationBar(
                    label: "Sell \(stock.stockIDName)",
                    leadingIcon: Image(systemName: "chevron.left"),
                    leadingAction: {
                        moduleRouter.pop()
                    }
                )
                
                VStack(spacing: 24) {
                    StockHeaderInformationView(
                        stockCodeName: stock.stockIDName,
                        stockName: stock.stockName,
                        initialPrice: $simulationViewModel.displayActiveStockInitialPrice,
                        currentPrice:
                            $simulationViewModel.displayActiveStockCurrentPrice
                    )
                    
                    SimulationSellingCard(
                        viewModel: viewmodel,
                        currentPrice: $simulationViewModel.displayActiveStockCurrentPrice
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                
                Spacer()
                
                HanvestButtonDefault(
                    style: .filledCorrect(
                        isDisabled: viewmodel.determineIsDisabledButtonState()
                    ),
                    title: "Sell",
                    action: {
                        moduleRouter.displayOverlay(
                            .withSellConfirmationPopup(
                                sellingStockDataViewModel: viewmodel,
                                confirmAction: {
                                    moduleRouter.push(
                                        .transactionComplete(
                                            profileViewModel: profileViewModel,
                                            simulationViewModel: simulationViewModel,
                                            highlightViewModel: highlightViewModel,
                                            transactionViewModel:
                                                TransactionStatusViewModel(
                                                    lotAmount: viewmodel.stockSellLot,
                                                    stockPrice: viewmodel.toSellStockPrice,
                                                    selectedStockIDName: viewmodel.selectedStockIDName,
                                                    transactionType: .sell
                                                )
                                        )
                                    )
                                },
                                cancelAction: {
                                    moduleRouter.dismissOverlay()
                                }
                            )
                        )
                        print("[!] User Sell Button Event Pressed!")
                    }
                )
                .padding(.bottom, 48)
            }
            .onAppear(){
                viewmodel.setup(
                    userData: profileViewModel.userData,
                    selectedStockIDName: stock.stockIDName,
                    initialStockPrice: stock.stockPrice.first?.price ?? 0,
                    currentStockPrice: stock.stockPrice.last?.price ?? 0
                )
            }
        }
        else {
            Text("Error! No Stock Selected!")
        }

    }
}

#Preview {
    @Previewable @StateObject var appRouter = AppRouter()
    @Previewable @State var startScreen: Screen? = .materialModule05
    
    NavigationStack(path: $appRouter.path) {
        if let startScreen = startScreen {
            appRouter.build(startScreen)
                .navigationDestination(for: Screen.self) { screen in
                    appRouter.build(screen)
                }
        }
    }
}
