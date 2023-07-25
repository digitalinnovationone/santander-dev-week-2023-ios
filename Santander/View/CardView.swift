//
//  CardView.swift
//  Santander
//
//  Created by Robson Moreira on 21/07/23.
//

import SwiftUI

struct CardView: View {
    
    @StateObject var viewModel = CardViewModel()
    
    @State private var cardClosed = true
    @State private var isRotating = 360.0
    
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 333, height: cardClosed ? 66 : 206)
            .background(Color.santanderRed)
            .cornerRadius(6)
            .shadow(color: .black.opacity(0.15), radius: 4.5, x: 0, y: 4)
            .overlay {
                VStack {
                    HStack {
                        Text(viewModel.number)
                            .font(.openSansSemiBold(size: 18))
                            .kerning(0.18)
                            .foregroundColor(.white)
                        Spacer()
                        Image("card_card_icon")
                            .rotationEffect(.degrees(isRotating))
                            .frame(width: 23.2374, height: 11.65924)
                            .onTapGesture {
                                withAnimation {
                                    isRotating = cardClosed ? 180.0 : 360.0
                                    cardClosed.toggle()
                                }
                            }
                    }
                    if !cardClosed {
                        VStack(alignment: .center) {
                            Text("Santander SX")
                                .font(.openSansSemiBold(size: 18))
                                .kerning(0.18)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 8.0)
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Limite disponível")
                                    .font(.openSansSemiBold(size: 18))
                                    .kerning(0.18)
                                    .foregroundColor(.white)
                                Spacer()
                                Text(viewModel.limit)
                                    .font(.openSansSemiBold(size: 18))
                                    .kerning(0.18)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.top, 18.0)
                        VStack(alignment: .center) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 283, height: 2)
                                .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                                .cornerRadius(75)
                            Text("Ver fatura")
                                .font(.openSansSemiBold(size: 18))
                                .kerning(0.18)
                                .foregroundColor(.white)
                                .padding(.top, 6.0)
                        }
                        .padding(.top, 8.0)
                    }
                }
                .padding([.leading, .trailing], 26.0)
            }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
