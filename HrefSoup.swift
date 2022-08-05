//
//  HrefSoup.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/4/22.
//

import Foundation
import UIKit
import SwiftSoup



class buildCells {
    static var build = buildCells()
    static var cellCountHREF: Int?
    static var cellCountPTAG: Int?
    
    
    fileprivate func getCountHREF() -> Int {
        let currentCount = buildCells.cellCountHREF
        print("[[HREF] -> Cell Count] --> \(String(describing: currentCount))")
        return currentCount ?? 2
    }
    // TODO: pass download amount from soupmodule here
    fileprivate func setCountHREF(newCount: Int) -> Int {
        print("[HREF] -> Setting Count for Amt of Cells] --> \(newCount)")
        buildCells.cellCountHREF = newCount
        return buildCells.cellCountHREF ?? 2
    }
    
    fileprivate func getCountPTAG() -> Int {
        let currentCount = buildCells.cellCountPTAG ?? 2
        print("[PTAG] -> Getting Count for Amt of Cells] --> \(currentCount)")
        return currentCount
    }
    fileprivate func setCountPTAG(newCount: Int) -> Int {
        buildCells.cellCountPTAG = newCount
        print("[PTAG] -> Setting Count for Amt of Cells] -->")
        return buildCells.cellCountPTAG ?? 2
        
    }
}


@IBDesignable
class HrefSoup: ViewControllerLogger
{
    public var soupLinks : [Element] = [Element]()
    @IBInspectable var soupURL: String = ""
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func textView(sender: UITextView!) {
        print("textview pressed")
    }
    @IBAction func searchBar(sender: UISearchBar!) {
        print("Search Bar Initiated. ")
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.delegate = self
        tableView?.dataSource = self
        
        
        DispatchQueue.main.async { [weak self ] in
            NotificationCenter.default.addObserver(self, selector: #selector(self?.didUpdateSoupNoticationHREF), name: .soupHref, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self?.didUpdateSoupNoticationPTAG), name: .soupPtags, object: nil)
            
            print("[!] View Did Load- Passed \(self?.soupURL)")
            let url = urlParser.url
            self?.textView?.text = url
            print(self?.soupURL)
            self?.setupView()
            
            self?.textView?.text = self?.soupURL.description
            self?.searchBar?.text = self?.soupURL
            
            // let hmtlString = self?.getHTML(textViewData: self?.soupURL)
            // self?.handleHTTPSoup(textViewData: hmtlString)
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            var hmtlString = self?.getHTML(textViewData: self?.soupURL)
            hmtlString = "\(String(describing: hmtlString))"
            print("HTML String [background thread] \(hmtlString)")
            self?.handleHTTPSoup(textViewData: hmtlString)
        }
        
    }
    
    
    func setupView() {
        textView?.addSubview(view)
    }
    
    private func setupViews() {
        print("[!] Laying out [TABLE CELL VIEWS] ")
        tableView?.reloadData()
        tableView?.isHidden = false
        tableView?.addSubview(UITableView())
        tableView?.layoutSubviews()
    }
    
    @objc func didUpdateSoupNoticationHREF(_ notification: Notification) throws {
        guard let soupArray: Array = notification.object as? [Element] else { throw notificationError.fetchSoupErr}
        print("[+] Soup Array \(soupArray)")
        soupLinks = soupArray.self
        // performDisplayHrefSegue() --> ** May run twice, as href and ptags are sent over.
        
    }
    @objc func didUpdateSoupNoticationPTAG(_ notification: Notification) throws {
        guard let soupArray: Array = notification.object as? [Element] else { throw notificationError.fetchSoupErr}
        print("[+] Soup Array \(soupArray)")
        soupLinks = soupArray.self
        // performDisplayHrefSegue() --> ** May run twice, as href and ptags are sent over.
        
    }
    
    
    
    private func getHTML(textViewData: String?) -> String {
        print("[!] Prasing HTML to String.. \(textViewData)")
        
        let myURLString = urlParser.url
        // if let myURLString =  textViewData?.description { // ?? "https://www.tvseries.watch/series/the-simpsons"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return myURLString
        }
        //  handleHTTPSoup(textViewData: myURLString)
        
        print("[!][!] \(myURL)")
        
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            print("HTML : \(myHTMLString)")
            return myHTMLString
            
        } catch let error {
            print("Error: \(error)")
            
        }
        return "https://www.tvseries.watch/series/the-simpsons"
        
    }
    
    
    
    func handleHTTPSoup(textViewData: String?){
        //https://www.youtube.com/watch?v=z2Z90aJUXhg
        do {
            let html = textViewData!
            
            let doc: Document = try! SwiftSoup.parse(html)
            let ptag: [Element] = try! doc.select("p").array()
            let ahref: [Element] = try! doc.select("a").array()
            let ahrefCount: Int = ahref.count
            let ptagCount: Int = ptag.count
            
            // TODO: Add Custom Error Handling
            print("[+] crawinng .. \(html)")
            print("[+] \(ptag)")
            print("[+] \(ahref)")
            print("[+] [\(ahrefCount)] [AHREF] available downloads")
            print("[+] [\(ptagCount)] [PTAGS] ")
            
            let ahrefArr = ["userInfo": [ahref]]
            let ptagArr = ["userInfo": [ptag]]
            
            buildCells.build.setCountHREF(newCount: ahrefCount)
            buildCells.build.setCountPTAG(newCount: ptagCount)
            
            DispatchQueue.main.async { [weak self] in
                self?.setupViews()
            }
            
            
        } catch Exception.Error(type: let type, Message: let msg) {
            print("[!] Error \(msg)")
            print("[!] type \(type)")
        }
    }
    
    
}
extension notificationError {
    public var notificationErrDescriotion : String {
        switch self {
        case .passNotificationErr : return "[-] caught error in notification, please edit"
        case . fetchSoupErr : return "[-] caught error in populating soup Array "
        }
    }
}
extension Notification.Name {
    internal static let downloadURL = Notification.Name("downloadURL")
    internal static let soupHref = Notification.Name("soupHref")
    internal static let soupPtags = Notification.Name("soupPtags")
}




extension HrefSoup: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        let idx = soupLinks[indexPath.row]
        print("[!] Tableview processing cell[IDX] \(idx)")
        print(idx.data())
        
        cell.backgroundColor = .gray
        cell.textLabel?.text = idx.description
        
        return cell
    }
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("[!] Table View is returning \(soupLinks.count)")
        // TODO: GET Count
        return soupLinks.count
    }
    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        print("[!] Table View For Editing! ")
        return true
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        let numbersInSection = buildCells.cellCountHREF
        print("[!] Table View For # of sections! [\(numbersInSection)]")
        return numbersInSection!
        
    }
    
}
