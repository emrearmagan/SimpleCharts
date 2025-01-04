//
//  UIFont.swift
//  SimpleChartsDemo
//
//  Created by Emre Armagan on 05.04.22.
//

import UIKit

extension UIFont {
    enum HelveticaNeue {
        static func regular(size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue", size: size)!
        }

        static func medium(size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-Medium", size: size)!
        }

        static func bold(size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-Bold", size: size)!
        }
    }

    enum AvenirNext {
        static func regular(size: CGFloat) -> UIFont {
            return UIFont(name: "AvenirNext-Regular", size: size)!
        }

        static func medium(size: CGFloat) -> UIFont {
            return UIFont(name: "AvenirNext-Medium", size: size)!
        }

        static func demiBold(size: CGFloat) -> UIFont {
            return UIFont(name: "AvenirNext-DemiBold", size: size)!
        }

        static func bold(size: CGFloat) -> UIFont {
            return UIFont(name: "AvenirNext-Bold", size: size)!
        }
    }
}
