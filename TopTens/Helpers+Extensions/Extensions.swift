//
//  Extensions.swift
//  TopTensWithFriends
//
//  Created by Kyle Somers on 7/14/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    static var appRed: UIColor  { return UIColor(red: 255/255, green: 76/255, blue: 49/255, alpha: 1) }
    static var appLightRed : UIColor { return UIColor(red: 255/255, green: 154/255, blue: 134/255, alpha: 1) }
    static var appOrange: UIColor { return UIColor(red: 250/255, green: 190/255, blue: 42/255, alpha: 1) }
    static var appPurple: UIColor { return UIColor(red: 134/255, green: 84/255, blue: 255/255, alpha: 1) }
    static var appLightPurple: UIColor { return UIColor(red: 218/255, green: 195/255, blue: 255/255, alpha: 1) }

}


extension CGRect {
    
    
    
    mutating func setCenter(_ point : CGPoint){
        self.origin = CGPoint(x: point.x - self.width / 2, y: point.y - self.height / 2)
    }
}

extension UIView{
    func removeAllSubviews(){
        for aView in self.subviews{
            aView.removeFromSuperview()
        }
    }
}

extension Date{
    func toString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
}

extension String{
    func containsOnlyLettersAndNumbers() -> Bool {
        for chr in self.characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && !(chr >= "0" && chr <= "9") ) {
                return false
            }
        }
        return true
    }
    
    func containsOnlyLettersAndSpaces() -> Bool {
        for chr in self.characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && !(chr == " ") ) {
                return false
            }
        }
        return true
    }
    
    func toWordArray() -> [String]{
        return self.components(separatedBy: " ")
    }
}

extension Array{
    func toPath() -> String{
        
        return self.reduce(""){(result, currentString) in
            guard let currentString =  currentString as? String else{return ""}
            return result + currentString + "/"
        }
    }
}

extension UIStoryboard{
    static func initialViewController(for storyboardName:String) -> UIViewController{
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        if let initialViewController = storyboard.instantiateInitialViewController(){
            return initialViewController
        }
        else{
            return UIViewController()
        }
    }
}
