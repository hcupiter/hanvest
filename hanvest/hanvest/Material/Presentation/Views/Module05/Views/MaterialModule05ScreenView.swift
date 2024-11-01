//
//  MaterialModule05ScreenView.swift
//  hanvest
//
//  Created by Hans Arthur Cupiterson on 24/10/24.
//

import SwiftUI

struct MaterialModule05ScreenView: View {
    // CONSTANT
    let MIN_PROGRESS = 0
    let MAX_PROGRESS = 2
    
    let appRouter: any AppRouterProtocol
    
    @StateObject private var contentRouter = Module05Router()
    @StateObject private var simulationViewModel = Module05SimulationViewModel()
    @StateObject private var profileViewModel = Module05ProfileViewModel()
    @StateObject private var highlightViewModel = HighlightViewModel()
    
    var body: some View {
        VStack {
            ProgressBarWithXMarkView(
                progressBarMinValue: MIN_PROGRESS,
                progressBarMaxValue: MAX_PROGRESS,
                action: {
                    appRouter.popToRoot()
                },
                progressBarCurrValue: $contentRouter.progress
            )
            .padding(.horizontal, 20)
            
            VStack {
                if let content = contentRouter.content.last {
                    contentRouter.build(content)
                }
            }
            .onAppear {
                if contentRouter.content.count <= 0 {
                    contentRouter.content.append(
                        .buyStage(
                            appRouter: appRouter,
                            profileViewModel: profileViewModel,
                            simulationViewModel: simulationViewModel,
                            highlightViewModel: highlightViewModel
                        )
                    )
                }
                
                if simulationViewModel.stockList.count <= 0 {
                    simulationViewModel.setup()
                }
                
                if profileViewModel.userData == nil {
                    profileViewModel.setup()
                }
            }
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            highlightViewModel.stage = Module05HighlightStage.mainStage.stringValue
            
            if simulationViewModel.currentStage == nil {
                simulationViewModel.currentStage = .buyStage(appRouter: appRouter)
            }
        }
        .overlay {
            if let popup = contentRouter.overlay {
                ZStack {
                    contentRouter.build(popup)
                }
                // Apply transition and animation
                .transition(.opacity) // You can use other transitions like .scale, .move, etc.
                .animation(.easeInOut(duration: 0.3), value: contentRouter.overlay)
            }
        }
        .modifier(HighlightHelperView(viewModel: highlightViewModel))
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
