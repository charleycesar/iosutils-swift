//
//  NSData+Livetouch.swift
//  AprovadorCorporativo
//
//  Created by livetouch PR on 10/6/15.
//  Copyright © 2015 Livetouch Brasil. All rights reserved.
//

import Foundation
import UIKit

public extension Data {
    
    func toString(_ encoding: String.Encoding = String.Encoding.utf8) -> String {
        let string = String(data: self, encoding: encoding)
        return string ?? ""
    }
    
    func toBase64() -> String{
        return self.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
}
