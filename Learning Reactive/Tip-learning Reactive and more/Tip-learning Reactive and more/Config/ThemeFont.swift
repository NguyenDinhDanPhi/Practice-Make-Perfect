//
//  ThemeFont.swift
//  Tip-learning Reactive and more
//
//  Created by dan phi on 13/02/2025.
//

import UIKit

struct ThemeFont {
    static func regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir Next Condensed Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir Next Condensed Demi Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func demiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir Next Condensed Demi Bold", size: size) ?? .systemFont(ofSize: size)
    }
}
