//
//  Extensions.swift
//  RememberYourTrip
//
//  Created by Alexey Onoprienko on 24.03.2021.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let tealColor = UIColor.rgb(red: 48, green: 164, blue: 182)
   
    static let lightRed = UIColor.rgb(red: 247, green: 66, blue: 82)
    
    static let darkBlue = UIColor.rgb(red: 9, green: 45, blue: 64)
    
    static let lightBlue = UIColor.rgb(red: 218, green: 235, blue: 243)
}



