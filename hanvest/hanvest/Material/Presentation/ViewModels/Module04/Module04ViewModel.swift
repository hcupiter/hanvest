//
//  Module04ViewModel.swift
//  hanvest
//
//  Created by Bryan Vernanda on 19/10/24.
//

import Foundation

class Module04ViewModel: ObservableObject {
    @Inject var validateIfUserHasCompletedTheModule: ValidateIfUserHasCompletedTheModule
    
    let progressBarMinValue: Int
    let progressBarMaxValue: Int
    let lastPage: Int
    
    @Published var currentTab: Int
    @Published var progressBarCurrValue: Int
    @Published var pageState: Module04PageState
    @Published var showingAnswer: Module04ShowingCorrectOrWrongAnswer
    @Published var userSelectedAnswer: String
    
    init() {
        self.progressBarMinValue = 0
        self.progressBarMaxValue = 100
        self.lastPage = Module04NumberedListContent.page11.rawValue
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
            if !checkIsDisabled() {
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
        progressBarCurrValue += (progressBarMaxValue / (lastPage + 1))
    }
    
    func checkIsDisabled() -> Bool {
        return (userSelectedAnswer.isEmpty && checkIsCurrentPageAQuestion())
    }
    
    func checkIsCurrentPageAQuestion() -> Bool {
        return (Module04MultipleChoice.allCases.contains { $0.rawValue == currentTab })
    }
    
    func toggleShowingAnswer() {
        showingAnswer.toggle()
    }
    
    func parseUserAnswerIfIsWrong(page: Module04MultipleChoice) -> String? {
        if userSelectedAnswer != page.answers {
            return userSelectedAnswer
        } else {
            return nil
        }
    }
    
    func checkUserAnswerTrueOrFalse(currentTab: Int) -> Bool {
        if let currentPage = Module04MultipleChoice(rawValue: currentTab) {
            return userSelectedAnswer == currentPage.answers
        } else {
            return false
        }
    }
    
    func resetUserSelectedAnswer() {
        userSelectedAnswer = ""
    }
}
