//
//  Module05Router.swift
//  hanvest
//
//  Created by Hans Arthur Cupiterson on 24/10/24.
//

import Foundation
import SwiftUI

class Module05Router: Module05RouterProtocol, ObservableObject {
    @Published var content: [Module05ContentView] = []
    
    @Published var overlay: Module05Overlay?
    
    @Published var progress: Int = 0
    
    func push(_ content: Module05ContentView) {
        self.content.append(content)
    }
    
    func pop() {
        if self.content.count <= 1 {
            return
        }
        
        self.content.removeLast()
    }
    
    func popToRoot(){
        self.content.removeLast(content.count - 1)
    }
    
    func displayOverlay(_ overlay: Module05Overlay) {
        self.overlay = overlay
    }
    
    func dismissOverlay() {
        self.overlay = nil
    }
    
    func addProgress() {
        self.progress += 1
    }
    
    @ViewBuilder
    func build(_ content: Module05ContentView) -> some View {
        switch content {
        case .buyStage(let appRouter, let profileViewModel, let simulationViewModel, let highlightViewModel):
            ZStack {
                Color.background.ignoresSafeArea()
                VStack {
                    Module05HeaderView(
                        userDataViewModel: profileViewModel,
                        bookIconTappedAction: {
                            // User can't use this button in this module, hence this will do nothing.
                        },
                        bellIconTappedAction: {
                            // User can't use this button in this module, hence this will do nothing.
                        },
                        profileIconTappedAction: {
                            // User can't use this button in this module, hence this will do nothing.
                        }
                    )
                    Module05SimulationView(
                        appRouter: appRouter,
                        moduleRouter: self,
                        profileViewModel: profileViewModel,
                        simulationViewModel: simulationViewModel,
                        highlightViewModel: highlightViewModel
                    )
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .navigationBarBackButtonHidden()
            
        case .sellStage(let appRouter, let profileViewModel, let simulationViewModel, let highlightViewModel):
            ZStack {
                Color.background.ignoresSafeArea()
                VStack {
                    Module05HeaderView(
                        userDataViewModel: profileViewModel,
                        bookIconTappedAction: {
                            // User can't use this button in this module, hence this will do nothing.
                        },
                        bellIconTappedAction: {
                            // User can't use this button in this module, hence this will do nothing.
                        },
                        profileIconTappedAction: {
                            // User can't use this button in this module, hence this will do nothing.
                        }
                    )
                    Module05SimulationView(
                        appRouter: appRouter,
                        moduleRouter: self,
                        profileViewModel: profileViewModel,
                        simulationViewModel: simulationViewModel,
                        highlightViewModel: highlightViewModel
                    )
                }
                .frame(maxHeight: .infinity, alignment: .top)

            }
            .navigationBarBackButtonHidden()
            
        case .confirmBuy(
            let profileViewModel,
            let simulationViewModel,
            let highlightViewModel
        ):
            ZStack {
                Color.background.ignoresSafeArea()
                Module05ConfirmationBuyView(
                    moduleRouter: self,
                    profileViewModel: profileViewModel,
                    simulationViewModel: simulationViewModel,
                    highlightViewModel: highlightViewModel
                )
            }
            .navigationBarBackButtonHidden()
            
        case .confirmSell(
            let profileViewModel,
            let simulationViewModel,
            let highlightViewModel
        ):
            ZStack {
                Color.background.ignoresSafeArea()
                Module05ConfirmationSellView(
                    moduleRouter: self,
                    profileViewModel: profileViewModel,
                    simulationViewModel: simulationViewModel,
                    highlightViewModel: highlightViewModel
                )
            }
            .navigationBarBackButtonHidden()
            
        case .transactionComplete(
            let profileViewModel,
            let simulationViewModel,
            let highlightViewModel,
            let transactionViewModel
        ):
            ZStack {
                Color.background.ignoresSafeArea()
                VStack {
                    Module05TransactionStatusView(
                        moduleRouter: self,
                        profileViewModel: profileViewModel,
                        simulationViewModel: simulationViewModel,
                        highlightViewModel: highlightViewModel,
                        transaction: transactionViewModel
                    )
                }
            }
            .navigationBarBackButtonHidden()
            
        }
    }
    
    @ViewBuilder
    func build(_ overlay: Module05Overlay) -> some View {
        switch overlay {
        case .withBuyConfirmationPopup(
            let buyingStockViewModel,
            let confirmAction,
            let cancelAction
        ):
            ZStack {
                Color.black.opacity(0.7).ignoresSafeArea()
                
                SimulationBuyingConfirmationCard(
                    viewModel: buyingStockViewModel,
                    cancelAction: {
                        cancelAction()
                        self.dismissOverlay()
                    },
                    confirmAction: {
                        confirmAction()
                        self.dismissOverlay()
                    }
                )
                .padding(.horizontal, HanvestConstant.overlayHorizontalPaddingSimulation)
            }
            
        case .withSellConfirmationPopup(
            let sellingStockViewModel,
            let confirmAction,
            let cancelAction
        ):
            ZStack {
                Color.black.opacity(0.7).ignoresSafeArea()
                
                SimulationSellingConfirmationCard(
                    viewModel: sellingStockViewModel,
                    cancelAction: {
                        cancelAction()
                        self.dismissOverlay()
                    },
                    confirmAction: {
                        confirmAction()
                        self.dismissOverlay()
                    }
                )
                .padding(.horizontal, HanvestConstant.overlayHorizontalPaddingSimulation)
            }
        }
    }
    
    
}
