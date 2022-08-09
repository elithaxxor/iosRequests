//
//  HrefSoup.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/4/22.
//

import Foundation
import UIKit
import SwiftSoup
import Combine


// TODO: Add beaituflsoup list to subscriber (use async background)
// MARK: Test String https://www.tvseries.watch/series/the-simpsons

@IBDesignable class HrefSoup: ViewControllerLogger
{
    public var soupLinks : [Element] = [Element]()
    public let name = Notification.Name("")
    public var subscriptions = Set<AnyCancellable>()
    private let homeVC = DownloaderVC()
    
    
 
    fileprivate let urlTableViewCell = UrlTableViewCell()
    internal var searchBarResults: [Element]?
    
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
    
    public func printPublisher(of description: String,
                               action: () -> Void) {
        print("\n——— Example of:", description, "———")
        action()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let cancellable = NotificationCenter.default
            .publisher(for: name)
            .sink { note in
                print(note.userInfo!["SearchString"] as! String)
            }
        
        let group = DispatchGroup()
        tableView?.delegate = self
        tableView?.dataSource = self
        searchBar?.delegate = self
        searchBarResults = soupLinks
        group.enter()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didUpdateSoupNoticationHREF), name: .soupHref, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didUpdateSoupNoticationPTAG), name: .soupPtags, object: nil)
        
        self.parseInfo()
        var hmtlString = self.getHTML(textViewData: self.soupURL)
        hmtlString = "\(String(describing: hmtlString))"
        print("HTML String [background thread] \(String(describing: hmtlString))")
        self.handleHTTPSoup(textViewData: hmtlString)
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
            print(self?.soupURL ?? "DEFAULT VALUE FOR PARSE INFO")
            //self?.setupView()
            self?.setupViews()
            
            self?.textView?.text = self?.soupURL.description
            self?.searchBar?.text = self?.soupURL
            let hmtlString = self?.getHTML(textViewData: self?.soupURL)
            self?.handleHTTPSoup(textViewData: hmtlString)
        }
    }
    
    fileprivate func parseBackHome() {
        DispatchQueue.main.async {
            [weak self] in
            print("[!] [!] Main thread initiated, sending hrefLinks back to home page [!] ")
            DownloaderVC.shared.urlTextView?.text = urlParser.fetch.getUrl().description
            DownloaderVC.shared.soupLinks = self!.soupLinks
            DownloaderVC.shared.textView?.text =  self?.soupLinks.description
            
        }
    }
  
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupViews()
    }
    
    
    func setupView() {
        textView?.addSubview(view)
    }
    
    fileprivate func setupViews() {
        DispatchQueue.main.async {
            [weak self] in
            print("[!] Laying out [TABLE CELL VIEWS] ")
            self?.tableView?.isHidden = false
            self?.tableView?.layoutSubviews()
            self?.tableView?.isSpringLoaded = true
            self?.tableView?.reloadData()
        }
        print("[+] Table View Cells Are Set. ")
    }
    
    @objc func didUpdateSoupNoticationHREF(_ notification: Notification) throws {
        guard let soupArray: Array = notification.object as? [Element] else { throw notificationError.fetchSoupErr}
        print("[+] Soup Array \(soupArray)")
        
    }
    @objc func didUpdateSoupNoticationPTAG(_ notification: Notification) throws {
        guard let soupArray: Array = notification.object as? [Element] else { throw notificationError.fetchSoupErr}
        print("[+] Soup Array \(soupArray)")
    }
    
    
    fileprivate func getHTML(textViewData: String?) -> String {
        print("[!] Prasing HTML to String.. \(String(describing: textViewData))")
        
        
        let myURLString = urlParser.url
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return myURLString
        }
        
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
                
                for value in ahref {
                    print(value)
                    let parsedVal = try? value.removeClass("<a class")
                        print("contains href \n \(parsedVal)")

                }
                
                //self?.soupLinks = ahref
                self?.soupLinks.append(contentsOf: ahref)
            
                
                let hrefCount = buildCells.build.setCountHREF(newCount: ahrefCount)
                let ptagCount = buildCells.build.setCountPTAG(newCount: ptagCount)
                
                print("[!] Set HREF tags to : \(hrefCount)"); print("[!] Set PTAG tags to : \(ptagCount)")
                print("*****************"); print("SOUPLINKS"); print(self?.soupLinks)
                self?.tableView?.reloadData()
                
                let subscribedSoup = Just(self!.soupLinks)
                    .map { (value) -> [Element] in
                        return value
                    }
                    .sink { (receivedValue) in
                        print(" ************************ \n [+] Notification Center Values \n \n  \(receivedValue) \n ******************* \n \n")
                        
                    } .store(in: &self!.subscriptions)
                
//                NotificationCenter.default.post(name: .soupHref(rawValue: "soupHref"), object: nil, userInfo: ahref)
  
                
                group.wait()
                DispatchQueue.main.async {
                    [weak self] in
                    print("[!] Pushing to main thread, to update homeVC with HREF SOUP LINKS \n [!][!] Saving data to notification center")
                    NotificationCenter.default
                        .post(name: NSNotification.Name(
                            "soupHref"),
                    object: nil)
                    
                    if self?.soupLinks != nil {
                        print("[!]")
                        DownloaderVC.shared.soupLinks = self!.soupLinks
                        DownloaderVC.shared.textView?.text = self!.soupLinks.description
                        self?.homeVC.setupViews()
                        DownloaderVC.shared.reloadInputViews()
                    }
                }
    
                print("[SUBSCRIPTIONS STORE] :: \(String(describing: self?.subscriptions.description))")
                print("[SUBSCRIPTIONS COUNT] :: \(String(describing: self?.subscriptions.count))")
                print("\n \n [!][!] BACKGROUND THREAD ENDED [!][!] ")
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
            print("[!] Error \(msg)"); print("[!] type \(type)"); print(LocalizedError.self)
        }
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
