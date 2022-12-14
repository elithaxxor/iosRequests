//
//  SearchBarExtension.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/7/22.
//

import Foundation
import UIKit


extension HrefSoup: UISearchBarDelegate {
	
	
	internal func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		view.addGestureRecognizer(tapRecognizer)
	}
	
	internal func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		view.removeGestureRecognizer(tapRecognizer)
	}
	
	internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		dismissKeyboard()
		guard let searchText = HrefSoup.shared.searchBar.text, !searchText.isEmpty else {
			return
		}
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		downloaderLogic.shared.setDLSession(searchTerm: searchText)
		
		{ [weak self] results, errorMessage in
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			
			if let results = results {
				self?.soupLinks.description = results
				self?.tableView.reloadData()
				self?.tableView.setContentOffset(CGPoint.zero, animated: false)
			}
		}
	}
	
	
	internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		print("[!] Search Bar (soup view) text did change. ")
		DispatchQueue.global(qos: .userInitiated).async {
			[weak self] in
			var searchBarResultsArr = [String]()
			self?.searchBarResults = []
			
			if searchText == "" {
				self?.searchBarResults = self?.soupLinks
			}
			for result in self?.soupLinks ?? []  {
				if result != nil {
					let filteredResults = try? result.getElementsContainingText("<a href=")
					self?.searchBarResults?.insert(contentsOf: filteredResults!, at: 0)
					print("[!] SearchBar Non Filtered Results \n \(result)")
					print("[+] SearchBar Filtered Results \n \(String(describing: filteredResults))")
				}
			}
			DispatchQueue.main.async {
				[weak self] in
				print("[!] Reloading TableView after SearchResults")
				self?.tableView.reloadData()
				self?.viewWillAppear(true)
			}
		}
	}
}

