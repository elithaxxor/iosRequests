//
//  downloaderLogic.swift
//  DownloadManagerIII
//
//  Created by Adel Al-Aali on 6/19/22.
//

import Foundation
import UIKit
import SwiftSoup
import SafariServices



// MARK: To Download [single and multiple] files and storage locally
internal class singleDownloaderController {
	public var activeDownloads :  [URL: singleDownload] = [ : ]
	var downloadsSession: URLSession!
	
	internal func cancelDownload(_ downloadInfo: downloadInfo) {
		print("[!] User Initiated Download Cancel [!] ")

		guard let download = activeDownloads[downloadInfo.previewURL] else { return }
		download.task?.cancel()
		activeDownloads[downloadInfo.previewURL] = nil
		
		DispatchQueue.main.async {
			[weak self] in
			urlParser.shared.updateHomeVC(text:"[+] Is Downloading? \( download.hrefLink.lowercased())")
			urlParser.shared.updateHomeVC(text: "[?] Is Downloading? \(download.isDownloading)")
			DownloaderVC.shared.IP = download.hrefLink.lowercased()
			DownloaderVC.shared.TEXT = String(download.isDownloading)
			DownloaderVC.shared.IP = String(downloadInfo.previewURL.description)
			DownloaderVC.shared.TEXT = String(download.isDownloading)
			DownloaderVC.shared.TEXT = String(download.hrefLink.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.name.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.index.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.downloaded.description)
			
		}
		print("[+] Download Cancelled [+] ")
	}
	
	internal func pauseDownload(_ downloadInfo: downloadInfo) {
		print("[!] User Initiated Download Pause [!] ")
		guard let download = activeDownloads[downloadInfo.previewURL], download.isDownloading  else { return }
		download.task?.cancel(byProducingResumeData: {
			[weak self] data in
			download.resumeData = data
		})
		download.isDownloading = false
		DispatchQueue.main.async {
			[weak self] in
			urlParser.shared.updateHomeVC(text:"[+] Is Downloading? \( download.hrefLink.lowercased())")
			urlParser.shared.updateHomeVC(text: "[?] Is Downloading? \(download.isDownloading)")
			DownloaderVC.shared.IP = download.hrefLink.lowercased()
			DownloaderVC.shared.TEXT = String(download.isDownloading)
			DownloaderVC.shared.IP = String(downloadInfo.previewURL.description)
			DownloaderVC.shared.TEXT = String(download.isDownloading)
			DownloaderVC.shared.TEXT = String(download.hrefLink.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.name.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.index.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.downloaded.description)
			
		}
		print("[+] Download Paused [+] ")
	}
	internal func resumeDownload(_ downloadInfo: downloadInfo) {
		print("[!] User Initiated Resume Download [!]")
		guard let download = activeDownloads[downloadInfo.previewURL] else { return }
		if let resumeData = download.resumeData { download.task = downloadsSession.downloadTask(withResumeData: resumeData)
		} else { download.task = downloadsSession.downloadTask(with: downloadInfo.previewURL) }
		download.task?.resume()
		download.isDownloading = true
		
		DispatchQueue.main.async {
			[weak self] in
			urlParser.shared.updateHomeVC(text:"[+] Is Downloading? \( download.hrefLink.lowercased())")
			urlParser.shared.updateHomeVC(text: "[?] Is Downloading? \(download.isDownloading)")
			DownloaderVC.shared.IP = download.hrefLink.lowercased()
			DownloaderVC.shared.TEXT = String(download.isDownloading)
			DownloaderVC.shared.IP = String(downloadInfo.previewURL.description)
			DownloaderVC.shared.TEXT = String(download.isDownloading)
			DownloaderVC.shared.TEXT = String(download.hrefLink.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.name.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.index.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.downloaded.description)
			
		}
		
		print("[+] Download Resumed [+]")
	}
	
	internal func startDownload(_ downloadInfo: downloadInfo) {
		print("[!] User Initiated Download [!] ")
		let download = singleDownload(hrefLink: urlParser.shared.getUrl())
		download.task = downloadsSession.downloadTask(with: downloadInfo.previewURL)
		download.task?.resume()
		download.isDownloading = true
		activeDownloads[downloadInfo.previewURL] = download
		
		DispatchQueue.main.async {
			[weak self] in
			urlParser.shared.updateHomeVC(text:"[+] Is Downloading? \( download.hrefLink.lowercased())")
			urlParser.shared.updateHomeVC(text: "[?] Is Downloading? \(download.isDownloading)")
			DownloaderVC.shared.IP = download.hrefLink.lowercased()
			DownloaderVC.shared.TEXT = String(download.isDownloading)
			DownloaderVC.shared.IP = String(downloadInfo.previewURL.description)
			DownloaderVC.shared.TEXT = String(download.isDownloading)
			DownloaderVC.shared.TEXT = String(download.hrefLink.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.name.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.index.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.downloaded.description)
			
		}
		print("[+] Download Complete [+] ")
	}
}

internal class multipleDownloaderController {
	public var activeDownloads :  [URL: multipleDownloads] = [ : ]
	var downloadsSession: URLSession!
	
	internal func cancelDownload(_ downloadInfo: downloadInfo) {
		print("[!] User Initiated Download Cancel [!] ")
		guard let download = activeDownloads[downloadInfo.previewURL] else { return }
		download.task?.cancel()
		activeDownloads[downloadInfo.previewURL] = nil
		DispatchQueue.main.async {
			[weak self] in
			urlParser.shared.updateHomeVC(text:"[+] HREF LINK? \(downloadInfo.previewURL)")
			urlParser.shared.updateHomeVC(text: "[?] Is Downloading? \(downloadInfo.name)")
			DownloaderVC.shared.IP = String(downloadInfo.previewURL.description)
			DownloaderVC.shared.TEXT = String(download.isDownloading.description)
			DownloaderVC.shared.TEXT = String(download.soupLinks.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.name.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.index.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.downloaded.description)
		}
		print("[+] Download Canceled [+] ")
	}
	
	internal func pauseDownload(_ downloadInfo: downloadInfo) {
		print("[!] User Initiated Pause [!]")
		guard let download = activeDownloads[downloadInfo.previewURL], download.isDownloading  else { return }
		download.task?.cancel(byProducingResumeData: {
			[weak self] data in
			download.resumeData = data
		})
		download.isDownloading = false
		DispatchQueue.main.async {
			[weak self] in
			urlParser.shared.updateHomeVC(text:"[+] HREF LINK? \(downloadInfo.previewURL)")
			urlParser.shared.updateHomeVC(text: "[?] Is Downloading? \(downloadInfo.name)")
			DownloaderVC.shared.IP = String(downloadInfo.previewURL.description)
			DownloaderVC.shared.TEXT = String(download.isDownloading.description)
			DownloaderVC.shared.TEXT = String(download.soupLinks.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.name.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.index.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.downloaded.description)
		}
		print("[+] Download Pause [+]  ")
		
	}
	internal func resumeDownload(_ downloadInfo: downloadInfo) {
		print("[!] User Initiated Resume Download [!]")
		
		guard let download = activeDownloads[downloadInfo.previewURL] else { return }
		
		if let resumeData = download.resumeData { download.task = downloadsSession.downloadTask(withResumeData: resumeData)
		} else { download.task = downloadsSession.downloadTask(with: downloadInfo.previewURL) }
		download.task?.resume()
		download.isDownloading = true
		
		DispatchQueue.main.async {
			[weak self] in
			urlParser.shared.updateHomeVC(text:"[+] HREF LINK? \(downloadInfo.previewURL)")
			urlParser.shared.updateHomeVC(text: "[?] Is Downloading? \(downloadInfo.name)")
			DownloaderVC.shared.IP = String(downloadInfo.previewURL.description)
			DownloaderVC.shared.TEXT = String(download.isDownloading.description)
			DownloaderVC.shared.TEXT = String(download.soupLinks.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.name.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.index.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.downloaded.description)
		}
		
		print("[+] Download Resumed [+]")
	}
	internal func startDownload(_ downloadInfo: downloadInfo) {
		print("[!] User Initiated Download [!] ")

		let download = multipleDownloads(soupLinks: HrefSoup.shared.soupLinks)
		download.task = downloadsSession.downloadTask(with: downloadInfo.previewURL)
		download.task?.resume()
		download.isDownloading = true
		activeDownloads[downloadInfo.previewURL] = download
		DispatchQueue.main.async {
			[weak self] in
			urlParser.shared.updateHomeVC(text:"[+] HREF LINK? \(downloadInfo.previewURL)")
			urlParser.shared.updateHomeVC(text: "[?] Is Downloading? \(downloadInfo.name)")
			DownloaderVC.shared.IP = String(downloadInfo.previewURL.description)
			DownloaderVC.shared.TEXT = String(download.isDownloading.description)
			DownloaderVC.shared.TEXT = String(download.soupLinks.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.name.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.index.description)
			DownloaderVC.shared.TEXT = String(downloadInfo.downloaded.description)
		}
		print("[+] Download Complete [+] ")
	}
}


internal class queryService {
	fileprivate let defaultSession = URLSession(configuration: .default)
	fileprivate let dataTask = URLSession(configuration: .default)
	fileprivate var errorMessage = ""
	fileprivate var hrefLink = String()
	fileprivate var soupLinks = [Element]()
}


internal class downloaderLogic: NSObject, URLSessionDelegate {
	
	// MARK: Type alias for download closures
	typealias soupLinks = ([Elements]?, String) -> Void
	typealias hrefLink =  (String?, String) -> Void
	typealias JSONDictionary = [String: Any]
	
	public let data = Data()
	static let shared = downloaderLogic()
	
	internal var dataTask: URLSessionDataTask?
	internal var sessionTask: URLSessionDownloadTask?
	internal var taskMetrics: URLSessionTaskMetrics?
	internal var defaultSession = URLSession(configuration: .default)
	internal var streamDelegate:  URLSessionStreamDelegate?
	internal var streamTask: URLSessionStreamTask?
	
	internal var webSocketDelegate: URLSessionWebSocketDelegate?
	internal var webSocketTask: URLSessionWebSocketTask?
	
	
	fileprivate var errorMessage = ""
	fileprivate var hrefLinks: [Elements] = []
	fileprivate var singleHref: String? {
		didSet {
			print("[!] Single Href Set For Download! ")
			// setDLSession.(completion: ?, String) -> Void)
		}
	}
	// weak var access = downloaderLogic()
	public var dlURL: String = "" {
		didSet {
			print("[!] Downloader Logic URL set to \(dlURL.description)")
			//try?setDLSession()
		}
	}
	public var completedText: String = "" {
		didSet {
			print("completed text")
			DownloaderVC.shared.TEXT = completedText.lowercased()
			DownloaderVC.shared.viewWillLayoutSubviews()
		}
	}
	
	public func updateHomeVCText(text: String) {
		DispatchQueue.main.async {
			[weak self] in
			print("[!] Updating HomeVC [DOWNLOAD TEXT VIEW] --> \(text)")
			DownloaderVC.shared.textView?.text = text
			DownloaderVC.shared.viewWillAppear(true)
			
		}
	}

	internal func setFTPSession() throws {
		let config = URLSessionConfiguration.ephemeral
		config.urlCredentialStorage = nil
		config.httpAdditionalHeaders = ["User-Agent":"Legit Safari", "Authorization" : "Bearer key1234567"]
		config.timeoutIntervalForRequest = 30
		config.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
		guard let sessionURL = URL(string: dlURL) ?? URL(string: "https://httpbin.org/anything") else { return  }
		var session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
		URLSession.shared.downloadTask(with: sessionURL).resume()
		print("Performed URL Grab on \(sessionURL.absoluteURL)")
	}
	
	internal func setDLSession(completion: @escaping hrefLink) throws {
		let dlUrl = urlParser.shared.getUrl()
		let group = DispatchGroup()
		dataTask?.cancel()
		
		print("[!] Starting Fetch on \(dlUrl)")
		group.enter()
		if var urlComponents = URLComponents(string: dlUrl) {
			guard let url = urlComponents.url else { return }
			let config = URLSessionConfiguration.ephemeral
			config.urlCredentialStorage = nil
			config.httpAdditionalHeaders = ["User-Agent":"Legit Safari", "Authorization" : "Bearer key1234567"]
			config.timeoutIntervalForRequest = 30
			config.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
			// guard let sessionURL = URL(string: dlUrl)  else { return  } //?? URL(string: "https://httpbin.org/anything")
			var session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
			
			
			
			self.updateHomeVCText(text: session.description)
			dataTask = session.dataTask(with: url) {  [weak self] data, response, error in
				defer { self?.dataTask = nil }
				let progress = self?.dataTask?.priority
				let taskResponse = self?.dataTask?.response
				let taskDescription = self?.dataTask?.taskDescription
				let sentBytes = self?.dataTask?.countOfBytesSent
				let recvBytes = self?.dataTask?.countOfBytesReceived
				let expectedRecvBytes = self?.dataTask?.countOfBytesExpectedToReceive
				let expectedSendBytes = self?.dataTask?.countOfBytesExpectedToSend
				
				
				if let error = error {
					self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
				} else if
					let data = data,
					let response = response as? HTTPURLResponse,
					response.statusCode == 200 {
					self?.updateSingleSearchResults(data)
					
					var status: String = "[!] Starting Fetch on [dlURL] \(String(describing: self?.dlURL)) \n \t [!] [SESSION] \(session) \n \t [!] [SESSION-URL] \(urlComponents) \n [!] performing URL Grab on \(session.description) "
					print(status)
					
					group.wait()
					DispatchQueue.main.async {
						[weak self] in
						group.enter()
						DownloaderVC.shared.textView?.text = status.description
						self?.updateHomeVCText(text: status)
						completion(self?.hrefLinks, self?.errorMessage ?? "")
						group.leave()
					}
				}
				group.enter()
				guard let fileURL = data else { return }
				do {
					let documentsURL = try
					FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
					let savedURL = documentsURL.appendingPathComponent(fileURL.description)
					try FileManager.default.moveItem(at: savedURL, to: savedURL)
					
					
					//try? self?.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: fileURL)
				} catch {
					print ("file error: \(error)")
				}
			}
			let progress = dataTask?.priority
			let taskResponse = dataTask?.response
			let taskDescription = dataTask?.taskDescription
			let sentBytes = dataTask?.countOfBytesSent
			let recvBytes = dataTask?.countOfBytesReceived
			let expectedRecvBytes = dataTask?.countOfBytesExpectedToReceive
			let expectedSendBytes = dataTask?.countOfBytesExpectedToSend
			
			let complete: String = " \n\n ******************* \n [+] Performed URL Grab on \n " // \(String(describing: dataTask.absoluteURL)) \n \n "
			self.completedText = complete.description
			print("[+] complete \n \(complete.description)")
			// print("[+] download task bytes recvd \(dataTask?.countOfBytesReceived)")
			self.updateHomeVCText(text: complete.description)
			DownloaderVC.shared.TEXT = complete.description
			dataTask?.resume()
			group.leave()
		}
		dataTask?.resume()
	}
	
	
	
	internal func setMultipleDLSession(completion: @escaping soupLinks) throws {
		let dlUrl = urlParser.shared.getUrl()
		let group = DispatchGroup()
		dataTask?.cancel()
		
		group.enter()
		print("[!] Starting Fetch on \(dlUrl)")
		if var urlComponents = URLComponents(string: dlUrl) {
			guard let url = urlComponents.url else { return }
			let config = URLSessionConfiguration.ephemeral
			config.urlCredentialStorage = nil
			config.httpAdditionalHeaders = ["User-Agent":"Legit Safari", "Authorization" : "Bearer key1234567"]
			config.timeoutIntervalForRequest = 30
			config.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
			
			var session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
			self.updateHomeVCText(text: session.description)

			dataTask = session.dataTask (with: url) { [weak self] data, response, error in
				defer { // allows scope of work when call exits
					self?.dataTask = nil
				}
				let progress = self?.dataTask?.priority
				let taskResponse = self?.dataTask?.response
				let taskDescription = self?.dataTask?.taskDescription
				let sentBytes = self?.dataTask?.countOfBytesSent
				let recvBytes = self?.dataTask?.countOfBytesReceived
				let expectedRecvBytes = self?.dataTask?.countOfBytesExpectedToReceive
				let expectedSendBytes = self?.dataTask?.countOfBytesExpectedToSend
				
				
				if let error = error {
					self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
				} else if
					let data = data,
					let response = response as? HTTPURLResponse,
					response.statusCode == 200 {
					self?.updateMultipleSearchResults(data)
					let status: String = "[!] Starting Fetch on [dlURL] \(String(describing: self?.dlURL)) \n \t [!] [SESSION] \(session) \n \t [!] [SESSION-URL] \(urlComponents) \n [!] performing URL Grab on \(session.description) "
					print(status)
					
					group.wait()
					DispatchQueue.main.async {
						[weak self] in
						group.enter()
						DownloaderVC.shared.textView?.text = status.description
						self?.updateHomeVCText(text: status)
						completion(self?.hrefLinks, self?.errorMessage ?? "")
						group.leave()
					}
				}
				group.enter()
				guard let fileURL = data else { return }
				do {
					let documentsURL = try
					FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
					let savedURL = documentsURL.appendingPathComponent(fileURL.description)
					try FileManager.default.moveItem(at: savedURL, to: savedURL)
					
					
					//try? self?.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: fileURL)
				} catch {
					print ("file error: \(error)")
				}
			}
			dataTask?.resume()
			let complete: String = " \n\n ******************* \n [+] Performed URL Grab on \n " // \(String(describing: dataTask.absoluteURL)) \n \n "
			self.completedText = complete.description
			print("[+] complete \n \(complete.description)")
			print("[+] download task bytes recvd \(dataTask?.countOfBytesReceived)")
			self.updateHomeVCText(text: complete.description)
			DownloaderVC.shared.TEXT = complete.description
			
			urlSession(session, downloadTask: sessionTask!, didFinishDownloadingTo: url)

			let progress = dataTask?.priority
			let taskResponse = dataTask?.response
			let taskDescription = dataTask?.taskDescription
			let sentBytes = dataTask?.countOfBytesSent
			let recvBytes = dataTask?.countOfBytesReceived
			let expectedRecvBytes = dataTask?.countOfBytesExpectedToReceive
			let expectedSendBytes = dataTask?.countOfBytesExpectedToSend
			group.leave()
		}
		dataTask?.resume()
		dataTask?.delegate = self

	}
	private func updateSingleSearchResults(_ data: Data) {
		var response: JSONDictionary?
		
		
	}
	private func updateMultipleSearchResults(_ data: Data) {
		var response: JSONDictionary?
	}
	
}

extension downloaderLogic: URLSessionDownloadDelegate {
	
	internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
		print("[!] URL DownloadTask DidResume at Offset ")
	}
	// TODO: Save data to local storage.
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


