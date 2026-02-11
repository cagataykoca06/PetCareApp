//
//  AppTheme.swift
//  Meadow
//
//  Created on [Date]
//

import SwiftUI

struct AppColors {
    static let background = Color(red: 0.95, green: 0.65, blue: 0.68) // Pastel red: #F3A7AD
    static let text = Color.white
}

struct AppFonts {
    static func monospaced(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }
    
    static let largeTitle = monospaced(size: 34, weight: .bold)
    static let title = monospaced(size: 28, weight: .bold)
    static let title2 = monospaced(size: 22, weight: .bold)
    static let title3 = monospaced(size: 20, weight: .bold)
    static let headline = monospaced(size: 17, weight: .semibold)
    static let body = monospaced(size: 17, weight: .regular)
    static let callout = monospaced(size: 16, weight: .regular)
    static let subheadline = monospaced(size: 15, weight: .regular)
    static let footnote = monospaced(size: 13, weight: .regular)
    static let caption = monospaced(size: 12, weight: .regular)
    static let caption2 = monospaced(size: 11, weight: .regular)
}

extension View {
    func appBackground() -> some View {
        self.background(AppColors.background.ignoresSafeArea())
    }
    
    func appTextColor() -> some View {
        self.foregroundColor(AppColors.text)
    }
}

