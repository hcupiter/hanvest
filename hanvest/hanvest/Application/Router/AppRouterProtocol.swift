//
//  AppRouterProtocol.swift
//  hanvest
//
//  Created by Hans Arthur Cupiterson on 15/10/24.
//

import Foundation
import SwiftUI

protocol AppRouterProtocol: ObservableObject {
    var path: NavigationPath { get set }
    var popup: Popup? { get set }

    func push(_ screen:  Screen)
    func pop()
    func popToRoot()
    
    func presentPopup(_ popup: Popup)
    func dismissPopup()
}