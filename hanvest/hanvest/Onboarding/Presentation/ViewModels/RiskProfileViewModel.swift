//
//  RiskProfileViewModel.swift
//  hanvest
//
//  Created by Bryan Vernanda on 11/10/24.
//

import Foundation

class RiskProfileViewModel: ObservableObject {
    @Inject var calculateUserRiskProfile: CalculateUserRiskProfile
    
    let progressBarMinValue: Int
    let progressBarMaxValue: Int
    
    @Published var currentTab: Int
    @Published var progressBarCurrValue: Int
    @Published var resultState: RiskProfileType ///will be used for segmenting user based on risk profile
    @Published var pageState: RiskProfilePageState
    @Published var userSelectedAnswers: Array<String>
    
    init() {
        self.progressBarMinValue = 0
        self.progressBarMaxValue = 100
        self.currentTab = 0
        self.progressBarCurrValue = 4
        self.resultState = .conservative
        self.pageState = .pageOpening
        self.userSelectedAnswers = Array(repeating: "", count: RiskProfileQuestionsAndOptions.allCases.count)
    }
    
    
    func getUserRiskProfile() {
        do {
            let userRiskProfile = try calculateUserRiskProfile.execute(userSelectedAnswers)
            
            resultState = userRiskProfile
        } catch {
            debugPrint("Failed to get user risk profile: \(error.localizedDescription)")
        }
    }
    
    func goToNextPage(router: any AppRouterProtocol) {
        if currentTab < RiskProfilePageState.pageRiskResult.rawValue {
            if !checkIsDisabled() {
                currentTab += 1
                updateProgressBarValue()
                changePageState()
            }
        } else {
            router.startScreen = .main
            router.popToRoot()
        }
    }
    
    func changePageState() {
        if currentTab < RiskProfilePageState.pageRiskResult.rawValue {
            pageState = .pageQuestion
        } else {
            pageState = .pageRiskResult
        }
    }
    
    func updateProgressBarValue() {
        if pageState == .pageQuestion {
            progressBarCurrValue += (progressBarMaxValue / RiskProfileQuestionsAndOptions.allCases.count)
        }
    }
    
    func checkIsDisabled() -> Bool {
        return pageState == .pageQuestion && userSelectedAnswers[currentTab - 1].isEmpty
    }
}
