//
//  ViewController.swift
//  DownloadManagerIII
//
//  Created by Adel Al-Aali on 6/19/22.
//

import UIKit
import Foundation
import SwiftSoup

// TODO --> Create Local Notiifcatino Center for login detols


// ftp://arobotsandbox.asuscomm.com


@IBDesignable
class DownloaderVC: ViewControllerLogger, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    var dl = downloaderLogic()
    static let down = DownloaderVC()
    let cellid = "cellid"
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var IP: String = ""
    var USER: String = ""
    var PORT: String = ""
    
    // TODO: Add to storyboard
    @IBOutlet weak var progressBar: UIProgressView?
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var urlLbl: UILabel!
    
    var imagePicker = UIImagePickerController()
    
    @IBAction func openLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
            // self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    
    
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            imagePicker.cameraDevice = .front
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBOutlet weak var uiSearchBar: UISearchBar! {
        
        didSet {
            let text = uiSearchBar?.text
            print("[!] UI SearchBar Text \(text)")
            urlParser.fetch.changeUrl(newLink: text)
            NotificationCenter.default.post(name: NSNotification.Name.soupHref, object: nil)
        }
    }
    
    
    
    
    
    @IBAction func uploadBtn(_ sender: UIButton) {
        print("[!] User has initiated uploading button")
        performSegue(withIdentifier: "uploadSegue", sender: self)
    }
    
    
    @IBAction func ftpBtn (_ sender: UIButton) {
        print("[FTP] Pressed")
        let fetchURL = urlParser.fetch.changeUrl(newLink: uiSearchBar?.text)
        handleFTP(textViewData: fetchURL)
        performSegue(withIdentifier: "FtpSeg", sender: self)
        
        
    }
    @IBAction func smbBtn(_ sender: UIButton) {
        print("[SMB] Btn Pressed ")
        let fetchURL = urlParser.fetch.changeUrl(newLink: uiSearchBar?.text)
        print("[SMB] URL \(fetchURL)")

        handleSMB(textViewData: fetchURL)
        performSegue(withIdentifier: "SmbView", sender: self)

        
    }
    @IBAction func httpSoupBtn(_ sender: UIButton) {
        print("[HTTP-Soup] Btn Pressed ")
        let fetchURL = urlParser.fetch.changeUrl(newLink: uiSearchBar?.text)
        handleHTTPSoup(textViewData: fetchURL)
        performDisplayHrefTableView()
        
    }
    @IBAction func httpDwnBtn(_ sender: UIButton) {
        print("[HTTP-DWNLD] Btn Pressed ")
        handleHttpDwn(textViewData: uiSearchBar?.text)
    }
    
    func handleHttpDwn(textViewData: String?) {
        
        guard dl.url == textViewData else { return }
        try? dl.setSession()
    }
    
    
    public var soupLinks : [Element] = [Element]()
    func handleHTTPSoup(textViewData: String?){
        //https://www.youtube.com/watch?v=z2Z90aJUXhg
        do {
            let html = textViewData!
            let doc: Document = try! SwiftSoup.parse(html)
            let ptag: [Element] = try! doc.select("p").array()
            let ahref: [Element] = try! doc.select("a").array()
            let count: Int = ahref.count
            
            // TODO: Add Custom Error Handling
            print("[+] \(ptag) [\(count)]")
            print("[+] \(ahref)")
            print("[+] [\(count)] available downloads")
            
            let ahrefArr = ["userInfo": [ahref]]
            let ptagArr = ["userInfo": [ptag]]
            //
            //            NotificationCenter.default
            //                .post(name: NSNotification.Name.soupHref,
            //                      object: nil,
            //                      userInfo: ahrefArr)
            //
            //            NotificationCenter.default
            //                .post(name: NSNotification.Name.soupPtags,
            //                      object: nil,
            //                      userInfo: ptagArr)
            
            performDisplayHrefTableView()
            
        } catch Exception.Error(type: let type, Message: let msg) {
            print("[!] Error \(msg)")
            print("[!] type \(type)")
        }
    }
    
    // TODO: Setup perform segue for after the sou list populates
    private func performDisplayHrefTableView() {
        print("[!] Performing segue")
        performSegue(withIdentifier: "HrefView", sender: self)
        
        
        
    }
    
    
    
    
    // TODO: Check on setSession, see if it needs a var to be passed.
    @objc func didUpdateNotification(_ notification: Notification) throws {
        print("[!].. Editing notification center.. ")
        guard let fetchURL = notification.object as? String else { throw notificationError.passNotificationErr }
        try?dl.setSession()
        
    }
    
    
    // TODO: Add method to populate soupNotification views.
    // TODO: ADD UICellViewTble to populate soup notifications
    // use souplinks to poulate cells
    
    // TODO: Add beaituflsoup list to subscriber (use async background)
    private func printHrefSoupList(ahref: [Element] , count: Int, ptag: [Element]) {
        print("[+] Parsing users Soup Reqeust --> Displaying available downloads")
        print(".. \(count) \(ahref) \(ptag)")
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar?.progress = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateNotification), name: .downloadURL , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateSoupNotication), name: .soupHref, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateSoupNotication), name: .soupPtags, object: nil)
        
        
        // TODO: BUG AREA
        
        
        // try?dl.setSession()
    }
    
    @objc func didUpdateSoupNotication(_ notification: Notification) throws {
        guard let soupArray: Array = notification.object as? [Element] else { throw notificationError.fetchSoupErr}
        print("[+] Soup Array \(soupArray)")
        soupLinks = soupArray.self
        // performDisplayHrefSegue() --> ** May run twice, as href and ptags are sent over.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupViews() {
        print("[!] Laying out [TABLE CELL VIEWS] ")
        self.tableView.reloadData()
        self.tableView.isHidden = false
        self.tableView.addSubview(UITableView())
        self.tableView.layoutSubviews()
    }
    
    
    func handleFTP(textViewData: String?) {
        print("[!] Handling FTP Data")
        let ftpURL = "ftp://\(urlParser.url.description):21"
        print("url textview set \(ftpURL)")
        guard dl.url == ftpURL else { return }
        print("[!] dl.url FTP - \(ftpURL)")
        performSegue(withIdentifier: "FtpSeg", sender: self)
        
        
        try? dl.setSession()
    }
    func handleSMB(textViewData: String?) {
        print("[!] Handling SMB Data")
        let smbURL = "smb://\(urlParser.url.description):445"
        guard dl.url == smbURL else { return }
        print("[!] HANDLE SMB URL \(smbURL)")
        print("[!] dl.url FTP - \(smbURL)")
        
        performSegue(withIdentifier: "SmbView", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FtpSeg"  {
            let seg = segue.destination as? FtpView
            let url = self.uiSearchBar.text
            seg?.ftpURL = url ?? "ftp://arobotsandbox.asuscomm.com:21"
    
        }
        
        if segue.identifier == "SmbView"  {
            let seg = segue.destination as? SmbView
            let url = self.uiSearchBar.text
            seg?.smbURL = url ?? "arobotsandbox.asuscomm.com"
            
        }
        
        if segue.identifier == "HrefSoup"  {
            let seg = segue.destination as? HrefSoup
            let url = self.uiSearchBar.text
            seg?.soupURL = url ?? "arobotsandbox.asuscomm.com"
            
        }
        
        
    }
}

enum notificationError: Error {
    case passNotificationErr
    case fetchSoupErr
    
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
    public static let downloadURL = Notification.Name("downloadURL")
    public static let soupHref = Notification.Name("soupHref")
    public static let soupPtags = Notification.Name("soupPtags")
}



extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}


/*
 
 DispatchQueue.background(delay: 3.0, background: {
 // do something in background
 }, completion: {
 // when background job finishes, wait 3 seconds and do something in main thread
 })
 
 DispatchQueue.background(background: {
 // do something in background
 }, completion:{
 // when background job finished, do something in main thread
 })
 
 DispatchQueue.background(delay: 3.0, completion:{
 // do something in main thread after 3 seconds
 })
 
 */


/*
 
 // TO PASS DATA TO NOTIFICATION CENTER
 NotificationCenter.default
 .post(name: NSNotification.Name("com.user.login.success"),
 object: nil)
 
 let loginResponse = ["userInfo": ["userID": 6, "userName": "John"]]
 NotificationCenter.default
 .post(name: NSNotification.Name("com.user.login.success"),
 object: nil,
 userInfo: loginResponse)
 
 
 
 */


/*
 
 // TO PASS DATA TO NOTIFICATION CENTER
 NotificationCenter.default
 .post(name: NSNotification.Name("com.user.login.success"),
 object: nil)
 
 let loginResponse = ["userInfo": ["userID": 6, "userName": "John"]]
 NotificationCenter.default
 .post(name: NSNotification.Name("com.user.login.success"),
 object: nil,
 userInfo: loginResponse)
 
 
 
 */
