//
//  HanvestProfileHeaderViewModel.swift
//  hanvest
//
//  Created by Hans Arthur Cupiterson on 12/10/24.
//

import Foundation

class HanvestProfileHeaderViewModel: ObservableObject {
    @Inject var getUserData: GetUserData
    
    var userBalance: Int
    
    init(){
        self.userBalance = 0
    }
    
    func setup(){
        userBalance = getUserData.execute().userBalance
    }
    
    func displayBalancePrefixAndSuffix() -> String {
        return HanvestPriceFormatter.formatIntToIDR(userBalance)
    }
    
}
