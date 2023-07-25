//
//  NavigationBarAppearance.swift
//  Santander
//
//  Created by Robson Moreira on 21/07/23.
//

import SwiftUI

struct NavigationBarAppearance: ViewModifier {
    
    init(backgroundColor: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = backgroundColor
        appearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    func body(content: Content) -> some View {
        content
    }
}
