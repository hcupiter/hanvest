//
//  ShowCaseRootViewModel.swift
//  hanvest
//
//  Created by Bryan Vernanda on 31/10/24.
//

import SwiftUI

class HanvestHighlightViewModel: ObservableObject {
    /// View properties
    @Published var stage: String
    @Published var highlightOrder: [Int]
    @Published var showView: Bool
    @Published var currentHighlight: Int
    /// popover
    @Published var showTitle: Bool
    @Published var isItemInUpperScreenPart: Bool
    @Published var isItemCoverThreeQuarterScreen: Bool
    
    init() {
        self.stage = ""
        self.highlightOrder = []
        self.showView = true
        self.currentHighlight = 0
        self.showTitle = true
        self.isItemInUpperScreenPart = true
        self.isItemCoverThreeQuarterScreen = true
    }
    
    func resetCurrectHighlightValue() {
        currentHighlight = 0
    }
    
    func resetHighlightViewState() {
        resetCurrectHighlightValue()
        showView = true
        showTitle = true
    }
    
    func setNewPopUpPosition(highlightRect: CGRect, screenHeight: CGFloat) {
        isItemInUpperScreenPart = highlightRect.midY < screenHeight / 2
        isItemCoverThreeQuarterScreen = highlightRect.height > (screenHeight * 7 / 10)
//        debugPrint("\(highlightRect.height), \(screenHeight)")
    }
    
    func updateHighlightOrderIfNeeded(from preferences: [Int: HanvestHighlightModel]) {
        // Filter and sort highlights based on the current stage
        let newHighlightOrder = preferences
            .filter { $0.value.stage == stage }
            .map { $0.key }
            .sorted()
        
        // Update only if there's a difference
        if newHighlightOrder != highlightOrder {
            highlightOrder = newHighlightOrder
        }
    }
    
    func currentHighlightToShow(from preferences: [Int: HanvestHighlightModel]) -> HanvestHighlightModel? {
        guard highlightOrder.indices.contains(currentHighlight), showView else {
            return nil
        }
        return preferences[highlightOrder[currentHighlight]]
    }
    
    func updateCurrentHighlight() {
        if currentHighlight >= highlightOrder.count - 1 {
            withAnimation(.easeInOut(duration: 0.25)) {
                showView = false
            }
            resetCurrectHighlightValue()
        } else {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.7)) {
                currentHighlight += 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.showTitle = true
            }
        }
    }
    
    func getPopoverAttachmentAnchorPosition() -> PopoverAttachmentAnchor {
        if isItemCoverThreeQuarterScreen || isItemInUpperScreenPart {
            return .point(.bottom)
        } else {
            return .point(.top)
        }
    }

    func getPopoverArrowEdge() -> Edge {
        if isItemCoverThreeQuarterScreen || !isItemInUpperScreenPart {
            return .bottom
        } else {
            return .top
        }
    }
    
}
