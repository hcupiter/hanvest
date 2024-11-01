//
//  MaterialTransactionStatusView.swift
//  hanvest
//
//  Created by Hans Arthur Cupiterson on 25/10/24.
//

import SwiftUI

struct Module05TransactionStatusView: View {
    var moduleRouter: any Module05RouterProtocol
    
    @ObservedObject var profileViewModel: Module05ProfileViewModel
    @ObservedObject var simulationViewModel: Module05SimulationViewModel
    @ObservedObject var highlightViewModel: HighlightViewModel
    
    let transaction: TransactionStatusViewModel
    
    var body: some View {
        ZStack {
            VStack {
                TransactionStatusLogo()
                VStack {
                    Text("Order Placed!")
                        .font(.nunito(.title1, .bold))
                    Text("\(transaction.lotAmount) lot of \(transaction.selectedStockIDName) at price \(transaction.stockPrice) \(transaction.transactionType.description)")
                }
                .padding(.top, 50)
            }
            .padding(.bottom, 50)
            
            HanvestButtonDefault(
                title: "Back To Market",
                action: {
                    if let stage = simulationViewModel.currentStage {
                        stage.onComplete(
                            moduleRouter: moduleRouter,
                            profileViewModel: profileViewModel,
                            simulationViewModel: simulationViewModel,
                            highlightViewModel: highlightViewModel,
                            transaction: transaction
                        )
                    }
                }
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 48)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

private struct TransactionStatusLogo: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack(alignment: .center) {
            // Outer Circle with scaling animation
            Circle()
                .fill(Color.blizzardBlue200)
                .frame(width: 250, height: 250)
                .scaleEffect(isAnimating ? 1.5 : 1.0) // Scale the circle
                .opacity(isAnimating ? 0.0 : 1.0) // Fade out during scaling
                .animation(
                    Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false),
                    value: isAnimating
                )
            
            // Inner circle with checkmark
            ZStack(alignment: .center) {
                Circle()
                    .fill(Color.blizzardBlue400)
                    .frame(width: 250, height: 250)
                Image(systemName: "checkmark")
                    .resizable()
                    .foregroundStyle(Color.mineShaft50)
                    .frame(width: 100, height: 100)
            }
        }
        .onAppear {
            isAnimating = true // Start the animation when the view appears
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
