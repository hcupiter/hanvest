//
//  Module06TipData.swift
//  hanvest
//
//  Created by Bryan Vernanda on 01/11/24.
//

enum Module06TipData: CaseIterable {
    case notification
    
    var index: Int {
        return Module06TipData.allCases.firstIndex(of: self) ?? 0
    }
    
    var title: String {
        switch self {
            case .notification:
                return "This is Notification"
        }
    }
    
    var detail: String {
        switch self {
            case .notification:
                return "You can see new news here."
        }
    }
}
