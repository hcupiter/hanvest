//
//  Module05SimulationViewModel.swift
//  hanvest
//
//  Created by Hans Arthur Cupiterson on 23/10/24.
//

import Foundation

class Module05SimulationViewModel: HanvestSimulationViewModel {
    @Published var currentStage: Module05Stage?
 
    override func setup(){
        self.stockList = self.prepareStockData()
        self.selectedStockID = stockList.first?.stockIDName ?? ""
    }
    
    func appendNewStockPrice(){
        let index = getSelectedStockIdx(selectedStockID: selectedStockID)
        stockList[index].stockPrice.append(
            .init(id: "BBCA-price-4", name: "BBCA", price: 1020, time: HanvestDateFormatter.stringToDate("2024-10-11 23:00:00"))
        )
    }
    
    func checkForCurrentHighlightedValue(_ value: Int) -> Bool {
        let relevantIndices: Set<Int> = [
            Module05TipData.stocks.index,
            Module05TipData.yourInvestment.index,
            Module05TipData.companyProfile.index
        ]
        
        return relevantIndices.contains(value)
    }
    
}

private extension Module05SimulationViewModel {
    func prepareStockData() -> [StockEntity] {
        return [
            .init(
                stockIDName: "BBCA",
                stockName: "PT Bank Central Asia Tbk",
                stockImageName: "BBCA-logo",
                stockDescription:
                """
                PT Bank Central Asia Tbk, commonly known as Bank Central Asia (BCA) is an Indonesian bank founded on 21 February 1957. It is the largest private bank in Indonesia with assets amounting to Rp 5.529,83 trillion (USD 308,5 billion) as of 2022. It is headquarters at BCA Tower in Jakarta.

                Bank Central Asia (BCA) was founded by Salim Group as “NV Perseroan Dagang Dan Industrie Semarang Knitting Factory". Originally the bank started small however it was expanded by banker and conglomerate Mochtar Riady who took control of the bank. Bank Central Asia expanded rapidly during the 1980s and 90s, BCA works with well-known institutions, such as PT Telkom, Citibank, and American Express. The bank was hit hard during the 1997 financial crisis and the subsequent 1998 May Riot. It was in massive debt and as a result it was taken over by the Indonesian Bank Restructuring Agency and sold to another conglomerate group Djarum.

                Since then BCA has thrived and subsequently, BCA took a major step by going public in the 2000. In 2022, Bank Central Asia was awarded to be the "Best Bank in Indonesia" by Forbes.
                """,
                stockPrice: [
                    .init(id: "BBCA-price-1", name: "BBCA", price: 1000, time: HanvestDateFormatter.stringToDate("2024-10-11 19:20:00")),
                    .init(id: "BBCA-price-2", name: "BBCA", price: 1020, time: HanvestDateFormatter.stringToDate("2024-10-11 20:30:00")),
                    .init(id: "BBCA-price-3", name: "BBCA", price: 1015, time: HanvestDateFormatter.stringToDate("2024-10-11 21:40:00")),
                    .init(id: "BBCA-price-4", name: "BBCA", price: 1010, time: HanvestDateFormatter.stringToDate("2024-10-11 22:50:00")),
                ]
            )
        ]
    }
}
