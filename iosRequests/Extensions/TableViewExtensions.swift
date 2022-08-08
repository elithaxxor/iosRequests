//
//  TableViewExtensions.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/7/22.
//

import Foundation
import UIKit


extension HrefSoup: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        let idx = soupLinks[indexPath.row]
        print(idx.data())
        cell.backgroundColor = .gray
        cell.textLabel?.text = idx.description
        
        return cell
    }
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("[!] Table View is returning \(soupLinks.count)")
        let numberOfRowsInSection = soupLinks.count
        print("numberOfRowsInSection \(String(describing: numberOfRowsInSection))")
        return numberOfRowsInSection
    }
    
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        let numbersInSection = buildCells.cellCountHREF
        print("[!] Table View For # of sections! [\(String(describing: numbersInSection))]")
        return numbersInSection ?? 2
    }
    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        print("[!] Table View For Editing! ")
        return true
    }
    internal func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> [UITableViewRowAction] {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete") { [weak self] action, indexpPath in
            self?.soupLinks.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }
}



extension DownloaderVC: UITableViewDelegate, UITableViewDataSource {
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        let idx = soupLinks[indexPath.row]
        print("[!] Tableview processing cell[IDX] \(idx)")
        cell.backgroundColor = .gray
        cell.textLabel?.text = idx.description
        return cell
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("[!] Table View is returning \(soupLinks.count)")
        return soupLinks.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        soupLinks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        guard editingStyle == .insert else { return }
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }
}


