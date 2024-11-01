//
//  MaterialSimulationView.swift
//  hanvest
//
//  Created by Hans Arthur Cupiterson on 25/10/24.
//

import SwiftUI

struct Module05SimulationView: View {
    let appRouter: any AppRouterProtocol
    let moduleRouter: any Module05RouterProtocol
    
    @ObservedObject var profileViewModel: Module05ProfileViewModel
    @ObservedObject var simulationViewModel: Module05SimulationViewModel
    @ObservedObject var highlightViewModel: HighlightViewModel
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    HanvestStockOptionList(
                        selectedStockID: $simulationViewModel.selectedStockID,
                        simulationStockList: simulationViewModel.stockList,
                        onPressed: { data in
                            
                        }
                    )
                    .showCase(
                        order: Module05TipData.stocks.index,
                        title: Module05TipData.stocks.title,
                        detail: Module05TipData.stocks.detail,
                        stage: Module05HighlightStage.mainStage.stringValue
                    )
                    
                    Divider()
                    
                    // Stock Detail
                    ScrollViewReader { scrollView in
                        ScrollView {
                            VStack(spacing: 24) {
                                if let selectedStock = simulationViewModel.selectedStock {
                                    VStack(spacing: 16) {
                                        StockHeaderInformationView(
                                            stockCodeName: selectedStock.stockIDName,
                                            stockName: selectedStock.stockName,
                                            initialPrice: $simulationViewModel.displayActiveStockInitialPrice,
                                            currentPrice: $simulationViewModel.displayActiveStockCurrentPrice
                                        )
                                        .id(Module05TipData.stocks.index)
                                        
                                        HanvestStockPriceChart(
                                            viewmodel: HanvestProductPriceChartViewModel(
                                                prices: selectedStock.stockPrice),
                                            symbolCategoryKeyPath: \.name,
                                            displayBy: .hour
                                        )
                                        
                                        if let userData = profileViewModel.userData {
                                            StockInvestmentDataView(
                                                userData: userData,
                                                selectedStock: selectedStock
                                            )
                                            .id(Module05TipData.yourInvestment.index)
                                        }
                                        
                                        StockCompanyProfileInformation(desc: selectedStock.stockDescription)
                                            .showCase(
                                                order: Module05TipData.companyProfile.index,
                                                title: Module05TipData.companyProfile.title,
                                                detail: Module05TipData.companyProfile.detail,
                                                stage: Module05HighlightStage.mainStage.stringValue
                                            )
                                            .id(Module05TipData.companyProfile.index)
                                        
                                    }
                                }
                                else {
                                    Text("No Stock selected")
                                        .font(.nunito(.title2, .bold))
                                }
                                
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 12)
                        .onChange(of: highlightViewModel.currentHighlight) { _, newValue in
                            if simulationViewModel.checkForCurrentHighlightedValue(newValue) {
                                withAnimation {
                                    scrollView.scrollTo(newValue, anchor: .top)
                                }
                            }
                        }
                    }
                    
                    Divider()
                        .padding(.top, -6)
                    
                    // Button
                    VStack {
                        HStack(spacing: 12) {
                            HanvestButtonDefault(
                                size: .medium,
                                style: .filledIncorrect(
                                    isDisabled:
                                        simulationViewModel.currentStage == .sellStage(appRouter: appRouter) ? false : true
                                ),
                                title: "Sell") {
                                    moduleRouter.push(
                                        .confirmSell(
                                            profileViewModel: profileViewModel,
                                            simulationViewModel: simulationViewModel,
                                            highlightViewModel: highlightViewModel
                                        )
                                    )
                                    
                                    highlightViewModel.stage = Module05HighlightStage.sellStage.stringValue
                                }
                                .showCase(
                                    order: Module05TipData.sellButton.index,
                                    title: Module05TipData.sellButton.title,
                                    detail: Module05TipData.sellButton.detail,
                                    stage: Module05HighlightStage.mainStage.stringValue
                                )
                            HanvestButtonDefault(
                                size: .medium,
                                style: .filledCorrect(
                                    isDisabled: simulationViewModel.currentStage == .buyStage(appRouter: appRouter) ? false : true
                                ),
                                title: "Buy") {
                                    moduleRouter.push(
                                        .confirmBuy(
                                            profileViewModel: profileViewModel,
                                            simulationViewModel: simulationViewModel,
                                            highlightViewModel: highlightViewModel
                                        )
                                    )
                                    
                                    highlightViewModel.stage = Module05HighlightStage.buyStage.stringValue
                                }
                                .showCase(
                                    order: Module05TipData.buyButton.index,
                                    title: Module05TipData.buyButton.title,
                                    detail: Module05TipData.buyButton.detail,
                                    stage: Module05HighlightStage.mainStage.stringValue
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 13)
                    
                    Divider()
                }
            }
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
