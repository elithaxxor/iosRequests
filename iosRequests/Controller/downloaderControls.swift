//
//  downloaderControls.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/9/22.
//

import Foundation

// MARK: To Download [single and multiple] files and storage locally
internal class singleDownloaderControl {
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

internal class multipleDownloaderControl {
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


