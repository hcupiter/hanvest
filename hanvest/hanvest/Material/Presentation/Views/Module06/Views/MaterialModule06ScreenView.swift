//
//  MaterialModule06ScreenView.swift
//  hanvest
//
//  Created by Hans Arthur Cupiterson on 26/10/24.
//

import SwiftUI

struct MaterialModule06ScreenView: View {
    // CONSTANT
    let MIN_PROGRESS = 0
    let MAX_PROGRESS = 1
    
    let appRouter: any AppRouterProtocol
    
    @StateObject private var contentRouter = Module06Router()
    @StateObject private var simulationViewModel = Module06SimulationViewModel()
    @StateObject private var profileViewModel = Module06ProfileViewModel()
    @StateObject private var newsViewModel = Module06NewsViewModel()
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
                        .simulation(
                            appRouter: appRouter,
                            profileViewModel: profileViewModel,
                            simulationViewModel: simulationViewModel,
                            newsViewModel: newsViewModel
                        )
                    )
                }
                
                if simulationViewModel.stockList.count <= 0 {
                    simulationViewModel.setup()
                }
                
                if profileViewModel.userData == nil {
                    profileViewModel.setup()
                }
                
                if newsViewModel.newsList.count <= 0 {
                    newsViewModel.setup()
                }
            }
            
        }
        .onAppear {
            highlightViewModel.stage = Module06HighlightStage.mainStage.stringValue
        }
        .frame(maxHeight: .infinity, alignment: .top)
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
    @Previewable @State var startScreen: Screen? = .materialModule06
    
    NavigationStack(path: $appRouter.path) {
        if let startScreen = startScreen {
            appRouter.build(startScreen)
                .navigationDestination(for: Screen.self) { screen in
                    appRouter.build(screen)
                }
        }
    }
}
