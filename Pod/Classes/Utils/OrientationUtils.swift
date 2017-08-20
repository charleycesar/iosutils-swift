//
//  OrientationUtils.swift
//  Pods
//
//  Created by Livetouch BR on 6/23/16.
//
//

import UIKit

open class OrientationUtils: NSObject {

    static open func getOrientation() -> UIInterfaceOrientation{
        return UIApplication.shared.statusBarOrientation
    }
    
    static open func isPortrait() -> Bool{
        let orientation = self.getOrientation()
        return orientation == UIInterfaceOrientation.portrait
    }
    
    static open func isUpsideDown() -> Bool{
        let orientation = self.getOrientation()
        return orientation == UIInterfaceOrientation.portraitUpsideDown
    }
    
    static open func isLandscape() -> Bool{
        let orientation = self.getOrientation()
        return orientation == UIInterfaceOrientation.landscapeLeft || orientation == UIInterfaceOrientation.landscapeRight
    }
}
