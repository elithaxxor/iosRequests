//
//  SearchBarExtension.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/7/22.
//

import Foundation
import UIKit


extension HrefSoup: UISearchBarDelegate {
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
            }
        }
    }
}

