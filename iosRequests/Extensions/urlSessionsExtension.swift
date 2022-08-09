//
//  urlSessionsExtension.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/7/22.
//

import Foundation
import UIKit


enum sessionsError : Error {
    case urlErr
    case noDataInResponse
    case noJsonResponse
}
extension sessionsError  {
    private var downloaderLoginErr : String {
        switch self {
        case .urlErr : return "[-] Error URL Session Closure"
        case .noDataInResponse : return "[-] No Data in Sessions Response"
        case .noJsonResponse : return "[-] No Json in Sessions Response"
        }
    }
}



// extension downloaderLogic: NSObject, URLSessionDelegate  {
extension downloaderLogic: NSObject, URLSessionDownloadDelegate {
	internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
		print("[!] URL DownloadTask DidResume at Offset ")
	}
	internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		print("[!] Starting URL Delegate Session")
		guard let data = try? Data(contentsOf: location) else {
			print("[-] Data Could Not Be Parsed. ")
			return
		}
		print("******************************************** \n [DATA] \n \n \(data) \n\n ******************************************** \n [DATA] \n \n ")
		DispatchQueue.main.async { [weak self] in
			FileLogic.work.createFolder()
			FileLogic.work.saveData(data: data, name: location.description)
			DownloaderVC.shared.progressLbl.isHidden = true
		}
	}
	internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
		let progress = bytesWritten / totalBytesExpectedToWrite
		DownloaderVC.shared.progressBar?.progress = Float(progress)
		DownloaderVC.shared.progressLbl.text = "\(progress * 100)%"
		print("[!] Download Progress \(progress * 100)%")
	}
}




