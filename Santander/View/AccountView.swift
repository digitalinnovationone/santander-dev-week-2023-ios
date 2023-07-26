//
//  AccountView.swift
//  Santander
//
//  Created by Robson Moreira on 21/07/23.
//

import SwiftUI

struct AccountView: View {
    
    @StateObject var viewModel = AccountViewModel()
    
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(height: 118)
            .background(Color(red: 0.89, green: 0.1, blue: 0.09))
            .overlay(alignment: .topLeading, content: {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Olá,")
                            .font(.openSansSemiBold(size: 18))
                            .kerning(0.18)
                            .foregroundColor(Color.santanderGrayishWhite)
                        Text(viewModel.clientName)
                            .font(.openSansSemiBold(size: 18))
                            .kerning(0.18)
                            .foregroundColor(Color.santanderGrayishWhite)
                    }
                    HStack {
                        Text("Ag")
                            .font(.openSansBold(size: 18))
                            .kerning(0.18)
                            .foregroundColor(Color.santanderGrayishWhite)
                        Text(viewModel.agencyNumber)
                            .font(.openSansBold(size: 18))
                            .kerning(0.18)
                            .foregroundColor(Color.santanderGrayishWhite)
                        Text("Cc")
                            .font(.openSansBold(size: 18))
                            .kerning(0.18)
                            .foregroundColor(Color.santanderGrayishWhite)
                        Text(viewModel.accountNumber)
                            .font(.openSansBold(size: 18))
                            .kerning(0.18)
                            .foregroundColor(Color.santanderGrayishWhite)
                    }
                }
                .padding(.leading, 32.0)
            })
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
