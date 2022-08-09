//
//  Downloader.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/8/22.
//
import Foundation.NSURL
import Foundation
import Foundation
import SwiftSoup

// TODO: Add Downloader Struct to souphref 

class multipleDownloads {
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
	var isDownloading = false
	var progress: Float = 0
	var resumeData: Data?
	var task: URLSessionDownloadTask?
	var hrefLink: String
	
	init(hrefLink: String) {
		self.hrefLink = hrefLink
	}
}

class downloadInfo {
	let index: Int
	let name: String
	let previewURL: URL
	var downloaded = false
	init(name: String, previewURL: URL, index: Int) {
		self.name = name
		self.previewURL = previewURL
		self.index = index
	}
}
