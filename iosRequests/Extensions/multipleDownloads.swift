//
//  Downloader.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/8/22.
//

import Foundation
import Foundation
import SwiftSoup

// TODO: Add Downloader Struct to souphref 

class multipleDownloads {
    
    static var shared = multipleDownloads.self
    var isDownloading = false
    var progress: Float = 0
    var resumeData: Data?
    var task: URLSessionDownloadTask?
    var soupLinks: [Element]
    
    init(soupLinks: [Element]) {
        self.soupLinks = soupLinks
    }
}



class singleDownload {
    
    static var shared = multipleDownloads.self
    var isDownloading = false
    var progress: Float = 0
    var resumeData: Data?
    var task: URLSessionDownloadTask?
    
    var hrefLink: String
    
    init(hrefLink: String) {
        self.hrefLink = hrefLink
    }
}


