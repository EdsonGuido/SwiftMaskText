//
//  SwiftMaskField.swift
//  GitHub: https://github.com/moraisandre/SwiftMaskText
//
//  Created by Andre Morais on 3/9/16.
//  Copyright © 2016 Andre Morais. All rights reserved.
//  Website: http://www.andremorais.com.br
//

import UIKit

class SwiftMaskField: UITextField {
    
    fileprivate var _textMask: String!
    
    @IBInspectable var textMask: String {
        
        get{
            return _textMask
        }
        
        set{
            _textMask = newValue
        }
        
    }
    
    func applyFilter(_ textField:UITextField){
        
        var index = _textMask.startIndex
        var textWithMask:String = ""
        var i:Int = 0
        var text:String = textField.text!
        
        if (text.isEmpty){
            return
        }
        
        text = removeMaskCharacters(text,withMask: textMask)
        
        while(index != textMask.endIndex){
            
            if(i >= text.characters.count){
                self.text = textWithMask
                break
            }
            
            if("\(textMask[index])" == "N"){ //Only number
                if (!isNumber(text[i])){
                    break
                }
                textWithMask = textWithMask + text[i]
                i += 1
            }else if("\(textMask[index])" == "C"){ //Only Characters A-Z, Upper case only
                if(hasSpecialCharacter(text[i])){
                    break
                }
                
                if (isNumber(text[i])){
                    break
                }
                textWithMask = textWithMask + text[i].uppercased()
                i += 1
            }else if("\(textMask[index])" == "c"){ //Only Characters a-z, lower case only
                if(hasSpecialCharacter(text[i])){
                    break
                }
                
                if (isNumber(text[i])){
                    break
                }
                textWithMask = textWithMask + text[i].lowercased()
                i += 1
            }else if("\(textMask[index])" == "X"){ //Only Characters a-Z
                if(hasSpecialCharacter(text[i])){
                    break
                }
                
                if (isNumber(text[i])){
                    break
                }
                textWithMask = textWithMask + text[i]
                i += 1
            }else if("\(textMask[index])" == "%"){ //Characters a-Z + Numbers
                if(hasSpecialCharacter(text[i])){
                    break
                }
                textWithMask = textWithMask + text[i]
                i += 1
            }else if("\(textMask[index])" == "U"){ //Only Characters A-Z + Numbers, Upper case only
                if(hasSpecialCharacter(text[i])){
                    break
                }
                
                textWithMask = textWithMask + text[i].uppercased()
                i += 1
            }else if("\(textMask[index])" == "u"){ //Only Characters a-z + Numbers, lower case only
                if(hasSpecialCharacter(text[i])){
                    break
                }
                
                textWithMask = textWithMask + text[i].lowercased()
                i += 1
            }else if("\(textMask[index])" == "*"){ //Any Character
                textWithMask = textWithMask + text[i]
                i += 1
            }else{
                textWithMask = textWithMask + "\(textMask[index])"
            }
            
            index = _textMask.index(after: index)
        }
        
        self.text = textWithMask
    }
    
    func isNumber(_ textToValidate:String) -> Bool{
        
        let num = Int(textToValidate)
        
        if num != nil {
            return true
        }
        
        return false
    }
    
    func hasSpecialCharacter(_ searchTerm:String) -> Bool{
        let regex = try!  NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpression.Options())
        
        if regex.firstMatch(in: searchTerm, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, searchTerm.characters.count)) != nil {
            return true
        }
        
        return false
        
    }
    
    func removeMaskCharacters(_ text:String,withMask mask:String) -> String{
        var text = text, mask = mask
        
        mask = mask.replacingOccurrences(of: "X", with: "")
        mask = mask.replacingOccurrences(of: "N", with: "")
        mask = mask.replacingOccurrences(of: "C", with: "")
        mask = mask.replacingOccurrences(of: "c", with: "")
        mask = mask.replacingOccurrences(of: "U", with: "")
        mask = mask.replacingOccurrences(of: "u", with: "")
        mask = mask.replacingOccurrences(of: "*", with: "")
        
        var index = mask.startIndex
        
        while(index != mask.endIndex){
            text = text.replacingOccurrences(of: "\(mask[index])", with: "")
            
            index = mask.index(after: index)
        }
        
        return text
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Apply the delegate // not needed
        //delegate = self
        
        addObserver(self, forKeyPath: "text", options: NSKeyValueObservingOptions(), context: nil)
        
        self.addTarget(self, action: #selector(SwiftMaskField.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
    }
    
    
    
    func textFieldDidChange(_ textField: UITextField) {
        //print("textFieldDidChange")
        applyFilter(textField)
    }
    
}

extension SwiftMaskField {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == "text" && object is SwiftMaskField) {
            
            //print(self.text)
            
        }
    }
}









