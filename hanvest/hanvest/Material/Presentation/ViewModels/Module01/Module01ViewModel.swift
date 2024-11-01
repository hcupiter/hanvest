//
//  Module01ViewModel.swift
//  hanvest
//
//  Created by Bryan Vernanda on 23/10/24.
//

import Foundation

class Module01ViewModel: ObservableObject {
    @Inject var validateIfUserHasCompletedTheModule: ValidateIfUserHasCompletedTheModule
    
    let progressBarMinValue: Int
    let progressBarMaxValue: Int
    let lastPage: Int
    
    @Published var currentTab: Int
    @Published var progressBarCurrValue: Int
    @Published var plantingViewVisibility: PlantingViewVisibility
    
    init() {
        self.progressBarMinValue = 0
        self.progressBarMaxValue = 100
        self.lastPage = ContentOfModule01Material.allCases.count
        self.currentTab = 0
        self.progressBarCurrValue = 4
        self.plantingViewVisibility = .isVisible
    }
    
    
    func directToCompletionPage(router: any AppRouterProtocol, specificModule: CompletionEntityType) {
        do {
            let isModuleCompleted = try validateIfUserHasCompletedTheModule.execute(specificModule: specificModule)
                
            if isModuleCompleted {
                router.popToRoot()
            } else {
                router.push(.moduleCompletion(completionItem: specificModule))
            }
        }
        catch {
            debugPrint("Failed to direct to completion page: \(error.localizedDescription)")
        }
    }
    
    func goToNextPage(router: any AppRouterProtocol, specificModule: CompletionEntityType) {
        if currentTab < (lastPage - 1) {
            currentTab += 1
            updateProgressBarValue()
        } else {
            directToCompletionPage(router: router, specificModule: specificModule)
        }
    }
    
    func updateProgressBarValue() {
        if plantingViewVisibility == .isHidden {
            progressBarCurrValue += (progressBarMaxValue / (lastPage + 1))
        }
    }
}
