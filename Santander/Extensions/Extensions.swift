//
//  Extensions.swift
//  Santander
//
//  Created by Robson Moreira on 16/07/23.
//

import SwiftUI
import Combine
import Kingfisher

extension Publisher {
    func tryDecodeResponse<Item, Coder>(type: Item.Type, decoder: Coder) -> Publishers.Decode<Publishers.TryMap<Self, Data>, Item, Coder> where Item: Decodable, Coder: TopLevelDecoder, Self.Output == (data: Data, response: URLResponse) {
        return self
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: type, decoder: decoder)
    }
}

extension Color {
    static var santanderRed: Color {
        return Color(red: 0.89, green: 0.1, blue: 0.09)
    }
    
    static var santanderGrayishWhite: Color {
        return Color(red: 0.94, green: 0.94, blue: 0.94)
    }
    
    static var santanderLightGray: Color {
        return Color(red: 0.76, green: 0.76, blue: 0.76)
    }
    
    static var santanderDarkGray: Color {
        return Color(red: 0.20, green: 0.20, blue: 0.20)
    }
}

extension View {
    func navigationBarAppearance(backgroundColor: Color) -> some View {
        self.modifier(NavigationBarAppearance(backgroundColor: UIColor(backgroundColor)))
    }
    
    func pageControlAppearance(backgroundColor: Color) -> some View {
        self.modifier(PageControlAppearance(backgroundColor: UIColor(backgroundColor)))
    }
    
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

extension Font {
    static func openSansRegular(size: CGFloat = 11) -> Font {
        return Font.custom("OpenSansCondensed-Regular", size: size)
    }
    
    static func openSansSemiBold(size: CGFloat = 11) -> Font {
        return Font.custom("OpenSansCondensed-SemiBold", size: size)
    }
    
    static func openSansBold(size: CGFloat = 11) -> Font {
        return Font.custom("OpenSansCondensed-Bold", size: size)
    }
}

extension Double {
    func toCurrency() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.roundingMode = .halfUp
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.locale = Locale(identifier: "pt_BR")
        
        guard let value = numberFormatter.string(from: NSNumber(value: self)) else { return String(self) }
        return value
    }
}

extension AsyncImage {
    init<I, P>(
        from url: URL?,
        frame: CGSize = .zero,
        @ViewBuilder content: @escaping (Image) -> I,
        @ViewBuilder placeholder: @escaping () -> P) where
        Content == _ConditionalContent<I, P>,
        I : View,
        P : View {
            self.init(from: url, frame: frame) { phase in
            switch phase {
            case .success(let image):
                content(image)
            case .empty, .failure:
                placeholder()
            }
        }
    }
}
