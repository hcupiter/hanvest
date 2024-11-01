//
//  Module02ViewModel.swift
//  hanvest
//
//  Created by Bryan Vernanda on 16/10/24.
//

import Foundation

class Module02ViewModel: ObservableObject {
    @Inject var validateIfUserHasCompletedTheModule: ValidateIfUserHasCompletedTheModule
    
    let progressBarMinValue: Int
    let progressBarMaxValue: Int
    let lastPage: Int
    
    @Published var currentTab: Int
    @Published var progressBarCurrValue: Int
    @Published var pageState: Module02PageState
    @Published var userSelectedAnswers: Array<String>
    
    init() {
        self.progressBarMinValue = 0
        self.progressBarMaxValue = 100
        self.lastPage = Module02HeaderWithDetailText.page10.rawValue
        self.currentTab = 0
        self.progressBarCurrValue = 4
        self.pageState = .pageContinue
        self.userSelectedAnswers = Array(repeating: "", count: Module02HeaderWithDetailText.page10.rawValue)
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
        if currentTab < lastPage {
            if !checkIsDisabled() {
                currentTab += 1
                updateProgressBarValue()
                changePageState()
            }
        } else {
            directToCompletionPage(router: router, specificModule: specificModule)
        }
    }
    
    func changePageState() {
        switch currentTab {
            case Module02TextImage.page06.rawValue:
                pageState = .pageCheckout
            case Module02MultipleChoice.page07.rawValue:
                pageState = .pagePay
            default:
                pageState = .pageContinue
        }
    }
    
    func updateProgressBarValue() {
        progressBarCurrValue += (progressBarMaxValue / (lastPage + 1))
    }
    
    func checkIsDisabled() -> Bool {
        guard currentTab < userSelectedAnswers.count else {
            return false
        }
        
        let isPage04 = (currentTab == Module02TextImageColorPicker.page04.rawValue)
        let isChoicePage = Module02MultipleChoice.allCases.contains(where: { $0.rawValue == currentTab })
        let isAnswerEmpty = userSelectedAnswers[currentTab].isEmpty
        
        return (isPage04 || isChoicePage) && isAnswerEmpty
    }
    
}
