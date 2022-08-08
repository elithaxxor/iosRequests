//
//  localFileExtensions.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/7/22.
//

import Foundation
import UIKit


enum LocalFileErr : Error {
    case MainDirirectoryerr
    case tempDirErr
    case cachedDirErr
    case pathError
    case getImgErr
    case deleteImgErr
}

extension LocalFileErr {
    public var LocalFileDescr : String {
        switch self {
            case .MainDirirectoryerr : return "[!] Theres an issue in the [MAIN] directory path. "
            case .tempDirErr : return "[!] Theres an issue in the [TEMP] directory path. "
            case .cachedDirErr : return "[!] Theres an issue in the [CACHE] directory path. "
            case .pathError : return "[!] Theres an issue in the [PATH]. Cannot fetch data . "
            case .getImgErr : return "[!] Theres an issue in the [getImgDir]. Cannot fetch data . "
            case .deleteImgErr : return "[!] Theres an issue in the [deleting image]. Cannot delete data ."
        }
    }
}
