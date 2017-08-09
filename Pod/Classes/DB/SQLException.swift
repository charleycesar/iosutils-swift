//
//  NotImplementedException.swift
//  SugarIOS
//
//  Created by Livetouch on 09/06/16.
//  Copyright © 2016 Livetouch. All rights reserved.
//

import Foundation

public enum SQLException: Error {
    case notImplemented(message: String)
    case databaseHelperNotFound
}
