//
//  MemeTextDelegate.swift
//  MemeMe
//
//  Created by Peter Burgner on 5/4/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import Foundation
import UIKit

class MemeTextDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text {
            if isDefaultText(text: text) {
                textField.text = ""
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func isDefaultText(text: String) -> Bool {
        if text == "TOP" || text == "BOTTOM" {
            return true
        } else {
            return false
        }
    }
    
}
