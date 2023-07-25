//
//  BalanceViewModel.swift
//  Santander
//
//  Created by Robson Moreira on 24/07/23.
//

import Then
import Combine

final class BalanceViewModel: ObservableObject {
    
    @Published var balance: Double = 0.0
    @Published var limit: Double = 0.0
    
    var accountBalance: String {
        balance.toCurrency()
    }
    
    var balanceAndLimit: String {
        "Saldo + Limite: \((balance + limit).toCurrency())"
    }
    
}

// MARK: - Then

extension BalanceViewModel: Then { }
