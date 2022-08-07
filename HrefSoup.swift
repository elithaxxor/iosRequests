//
//  HrefSoup.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/4/22.
//

import Foundation
import UIKit
import SwiftSoup



@IBDesignable
class HrefSoup: ViewControllerLogger
{
    public var soupLinks : [Element] = [Element]()
    fileprivate let urlTableViewCell = UrlTableViewCell()
    fileprivate var searchBarResults: [Element]?
    
    
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
        searchBar?.delegate = self
        let group = DispatchGroup()
        searchBarResults = soupLinks
        // DispatchQueue.main.async { [weak self ] in
        group.enter()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didUpdateSoupNoticationHREF), name: .soupHref, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didUpdateSoupNoticationPTAG), name: .soupPtags, object: nil)
        
        self.parseInfo()
        //  group.leave()
        // }
        //  group.wait()
        // DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        //  group.enter()
        var hmtlString = self.getHTML(textViewData: self.soupURL)
        hmtlString = "\(String(describing: hmtlString))"
        print("HTML String [background thread] \(String(describing: hmtlString))")
        self.handleHTTPSoup(textViewData: hmtlString)
        //  group.leave()
        //  }
        // group.wait()
        DispatchQueue.main.async {
            [weak self] in
            group.enter()
            self?.tableView.reloadData()
            group.leave()
        }
    }
    
    private func parseInfo () {
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            print("[!] View Did Load- Passed \(String(describing: self?.soupURL))")
            let url = urlParser.url
            self?.textView?.text = url
            print(self?.soupURL)
            //self?.setupView()
            self?.setupViews()
            
            self?.textView?.text = self?.soupURL.description
            self?.searchBar?.text = self?.soupURL
            let hmtlString = self?.getHTML(textViewData: self?.soupURL)
            self?.handleHTTPSoup(textViewData: hmtlString)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setupViews()
    }
    
    
    func setupView() {
        textView?.addSubview(view)
    }
    
    fileprivate func setupViews() {
        DispatchQueue.main.async {
            [weak self] in
            print("[!] Laying out [TABLE CELL VIEWS] ")
            
            
            //  let idx = 0
            // let idxPath = IndexPath(row: idx, section: 0)
            // self?.tableView?.insertRows(at: [idxPath], with: .left)
            self?.tableView?.isHidden = false
            //            self?.tableView?.addSubview(UITableView())
            //            self?.tableView?.addSubview((self?.tableView)!)
            self?.tableView?.layoutSubviews()
            self?.tableView?.isSpringLoaded = true
            self?.tableView?.reloadData()
        }
        
        
    }
    
    @objc func didUpdateSoupNoticationHREF(_ notification: Notification) throws {
        guard let soupArray: Array = notification.object as? [Element] else { throw notificationError.fetchSoupErr}
        print("[+] Soup Array \(soupArray)")
        // soupLinks = soupArray.self
        // performDisplayHrefSegue() --> ** May run twice, as href and ptags are sent over.
        
    }
    @objc func didUpdateSoupNoticationPTAG(_ notification: Notification) throws {
        guard let soupArray: Array = notification.object as? [Element] else { throw notificationError.fetchSoupErr}
        print("[+] Soup Array \(soupArray)")
        //  soupLinks = soupArray.self
        // performDisplayHrefSegue() --> ** May run twice, as href and ptags are sent over.
        
    }
    
    
    fileprivate func getHTML(textViewData: String?) -> String {
        print("[!] Prasing HTML to String.. \(String(describing: textViewData))")
        
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
    
    fileprivate func handleHTTPSoup(textViewData: String?){
        let group = DispatchGroup()
        do {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                group.enter()
                
                print("[!][!] BACKGROUND THREAD INITIATED [!][!] ")
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
                
                //self?.soupLinks = ahref
                self?.soupLinks.append(contentsOf: ahref)
                
                let hrefCount = buildCells.build.setCountHREF(newCount: ahrefCount)
                let ptagCount = buildCells.build.setCountPTAG(newCount: ptagCount)
                
                print("[!] Set HREF tags to : \(hrefCount)")
                print("[!] Set PTAG tags to : \(ptagCount)")
                print("*****************")
                print("SOUPLINKS")
                
                print(self?.soupLinks)
                
                self?.tableView?.reloadData()
                print("[!][!] BACKGROUND THREAD ENDED [!][!] ")
                group.leave()
            }
            group.wait()
            DispatchQueue.main.async { [weak self] in
                group.enter()
                print("[!][!] MAIN THREAD STARTED [!][!] ")
                self?.tableView.reloadData()
                self?.setupViews()
                print("[!][!] MAIN THREAD THREAD ENDED [!][!] ")
                group.leave()
            }
            
            
        } catch Exception.Error(type: let type, Message: let msg) {
            print("[!] Error \(msg)")
            print("[!] type \(type)")
            print(LocalizedError.self)
        }
    }
    
    
}
extension notificationError {
    public var notificationErrDescriotion : String {
        switch self {
        case .passNotificationErr : return "[-] caught error in notification, please edit"
        case .fetchSoupErr : return "[-] caught error in populating soup Array "
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        
        let idx = soupLinks[indexPath.row]
        print(idx.data())
        cell.backgroundColor = .gray
        cell.textLabel?.text = idx.description
        
        return cell
    }
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("[!] Table View is returning \(soupLinks.count)")
        // TODO: GET Count
        
        //  let numberOfRowsInSection = buildCells.cellCountHREF
        let numberOfRowsInSection = soupLinks.count
        print("numberOfRowsInSection \(String(describing: numberOfRowsInSection))")
        return numberOfRowsInSection ?? 2
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

extension HrefSoup: UISearchBarDelegate {
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarResults = []
        for result in searchBarResults ?? []  {
            if result != nil {
                searchBarResults?.append(result)
            }
        }
    }
}

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


//class tableCell: UITableViewCell {
//    override init(style: UITableViewCell, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
