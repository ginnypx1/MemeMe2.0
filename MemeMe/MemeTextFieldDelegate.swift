//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Ginny Pennekamp on 3/2/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // array of TextField properties
    var memeTextAttributes: [String: Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName: -3.0]
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // clears the textField of default text
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // allows use of the return key
        textField.resignFirstResponder()
        return true
    }
    
    func setUpTextField(_ textField: UITextField, label: String) {
        // sets the properties of a textField
        textField.delegate = self
        textField.text = label
        textField.returnKeyType = UIReturnKeyType.done
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
    }
}
