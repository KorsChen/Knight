//
//  String+util.swift
//  leihou
//
//  Created by 陈志鹏 on 2018/4/22.
//  Copyright © 2018 huajiao. All rights reserved.
//

import Foundation
import UIKit

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: range.lowerBound)
        let idx2 = index(startIndex, offsetBy: range.upperBound)
        return String(self[idx1..<idx2])
    }
    
    subscript(range: CountableClosedRange<Int>) -> Substring {//闭区间
        let sIndex = range.lowerBound
        var eIndex = range.upperBound
        if sIndex > (count - 1) {
            return ""
        }else if eIndex > (count - 1) {
            eIndex = count - 1
        }
        let start = index(startIndex, offsetBy: sIndex)
        let end   = index(startIndex, offsetBy: eIndex)
        return self[start...end]
    }
    
    func textSizeWithFont(font: UIFont, constrainedToSize size:CGSize) -> CGSize {
        var textSize:CGSize!
        if size.equalTo(CGSize.zero) {
            let attributes = [NSAttributedString.Key.font : font]
            textSize = self.size(withAttributes: attributes)
        } else {
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let attributes = [NSAttributedString.Key.font : font]
            let stringRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
            textSize = stringRect.size
        }
        return textSize
    }
    
//    var md5 : String{
//        let str = self.cString(using: String.Encoding.utf8)
//        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//        
//        CC_MD5(str!, strLen, result)
//        
//        let hash = NSMutableString()
//        for i in 0 ..< digestLen {
//            hash.appendFormat("%02x", result[i])
//        }
//        result.deinitialize(count: digestLen)
//        
//        return String(format: hash as String)
//    }
}       
