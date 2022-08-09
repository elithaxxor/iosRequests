//
//  downloaderController.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/9/22.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import SwiftSoup

class DownloaderViewController: ViewControllerLogger, URLSessionDelegate
{
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	internal let query = downloaderLogic()
	internal let singleDownloadService = singleDownloaderControl()
	internal let multipleDownloadService = multipleDownloaderControl()
	
	fileprivate var searchResults: [Element] = []
	
	
	
	internal let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
	internal lazy var downloadsSession: URLSession = {
	  let configuration = URLSessionConfiguration.background(withIdentifier:
											urlParser.shared.getUrl().description)
	  return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
	}()
	
	internal func localFilePath(for url: URL) -> URL {
		print("[!] Returning Local File Path \n \(url)")
		return documentsPath.appendingPathComponent(url.lastPathComponent)
	}
	
	internal func playDownload(_ track: downloadInfo) {
		let playerViewController = AVPlayerViewController()
		print("[!] Play Button Pressed, presenting play controller [!] \n \(track)")

		present(playerViewController, animated: true, completion: nil)
		let url = localFilePath(for: track.previewURL)
		let player = AVPlayer(url: url)
		playerViewController.player = player
		player.play()
	}
	
	internal func position(for bar: UIBarPositioning) -> UIBarPosition {
		return .topAttached
	}
	
	internal func reload(_ row: Int) {
		tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
	}
}

