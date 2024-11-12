//
//  Module04ViewModel.swift
//  hanvest
//
//  Created by Bryan Vernanda on 19/10/24.
//

import Foundation

class StockRegulatorModuleViewModel: ObservableObject {
    @Inject var validateIfUserHasCompletedTheModule: ValidateIfUserHasCompletedTheModule
    
    let progressBarMinValue: Int
    let progressBarMaxValue: Int
    let lastPage: Int
    
    @Published var currentTab: Int
    @Published var progressBarCurrValue: Int
    @Published var pageState: StockRegulatorModulePageState
    @Published var showingAnswer: StockRegulatorModuleCorrectOrWrongAnswerState
    @Published var userSelectedAnswer: String
    
    init() {
        self.progressBarMinValue = 0
        self.progressBarMaxValue = 100
        self.lastPage = StockRegulatorModuleNumberedListPageContent.page11.rawValue
        self.currentTab = 0
        self.progressBarCurrValue = 4
        self.pageState = .pageStartQuiz
        self.showingAnswer = .isNotShowing
        self.userSelectedAnswer = ""
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
            if !checkIsDisabled(isButtonStyle: true) {
                currentTab += 1
                updateProgressBarValue()
                changePageState()
                resetUserSelectedAnswer()
            }
        } else {
            directToCompletionPage(router: router, specificModule: specificModule)
        }
    }
    
    func changePageState() {
        switch currentTab {
            default:
                pageState = .pageContinue
        }
    }
    
    func updateProgressBarValue() {
        progressBarCurrValue += (progressBarMaxValue / lastPage)
    }
    
    func checkIsDisabled(isButtonStyle: Bool) -> Bool {
        return (isButtonStyle ? userSelectedAnswer.isEmpty : !userSelectedAnswer.isEmpty) && checkIsCurrentPageAQuestion()
    }
    
    func checkIsCurrentPageAQuestion() -> Bool {
        return (StockRegulatorModuleMultipleChoicePageContent.allCases.contains { $0.rawValue == currentTab })
    }
    
    func parseUserAnswerIfIsWrong(page: StockRegulatorModuleMultipleChoicePageContent) -> String? {
        if userSelectedAnswer != page.answers {
            return userSelectedAnswer
        } else {
            return nil
        }
    }
    
    func checkUserAnswerTrueOrFalse() -> Bool {
        if let currentPage = StockRegulatorModuleMultipleChoicePageContent(rawValue: currentTab) {
            return userSelectedAnswer == currentPage.answers
        } else {
            return false
        }
    }
    
    func resetUserSelectedAnswer() {
        userSelectedAnswer = ""
    }
}