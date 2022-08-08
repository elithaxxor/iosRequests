//
//  ViewController.swift
//  DownloadManagerIII
//
//  Created by Adel Al-Aali on 6/19/22.
// ftp://arobotsandbox.asuscomm.com


import UIKit
import Foundation
import SwiftSoup

@IBDesignable class DownloaderVC: ViewControllerLogger, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    public var soupLinks : [Element] = [Element]()
    static let down = DownloaderVC()
    private var dl = downloaderLogic()
    private let cellid = "cellid"
    
    internal var IP: String = ""
    internal var USER: String = ""
    internal var PORT: String = ""
    fileprivate var imagePicker = UIImagePickerController()

    // TODO: Add to storyboard
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressBar: UIProgressView?
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var urlLbl: UILabel!
    
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
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            imagePicker.cameraDevice = .front
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBOutlet weak var uiSearchBar: UISearchBar! {
        didSet {
            let text = uiSearchBar?.text?.lowercased()
            let newUrl = urlParser.fetch.changeUrl(newLink: uiSearchBar?.text).lowercased().description
            if newUrl.isEmpty || newUrl.hasPrefix("http://") {
                var dialogMessage = UIAlertController(title: "Attention", message: "tls required, add https", preferredStyle: .alert)
            }
            print("[!] UI SearchBar Text \(newUrl))")
            print(text)
            urlParser.fetch.changeUrl(newLink: text)
            print(urlParser.fetch.getUrl())
            print("[+] New Url After Searchbar Change,\n \(newUrl)")
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
        let fetchURL = urlParser.fetch.changeUrl(newLink: uiSearchBar?.text).lowercased()
        if fetchURL.hasPrefix("http://") {
            print("download url requires TLS \(fetchURL)")
            var downloadAlert = UIAlertController(title: "add https://", message: "tls required, add https://", preferredStyle: .alert)
            self.present(downloadAlert, animated: true, completion: nil)
        }
        else if fetchURL.isEmpty {
            print("no url entered \n \(fetchURL)")
            var downloadAlert = UIAlertController(title: "empty link", message: "tls required, add https://www.website.com", preferredStyle: .alert)
            self.present(downloadAlert, animated: true, completion: nil)
        }
        
        print("[HTTP-Soup] Btn Pressed \n \(fetchURL) ")
        performDisplayHrefTableView()
    }
    @IBAction func httpDwnBtn(_ sender: UIButton) {
        print("[HTTP-DWNLD] Btn Pressed ")
        let backupDownURL = "https://www.google.com"
        var downlUrl = urlParser.fetch.changeUrl(newLink: uiSearchBar?.text).lowercased().description
        
        if downlUrl.hasPrefix("http://") {
            print("download url requires TLS \(downlUrl)")
            var downloadAlert = UIAlertController(title: "add https://", message: "tls required, add https://", preferredStyle: .alert)
            self.present(downloadAlert, animated: true, completion: nil)
        }
        else if downlUrl.isEmpty {
            print("no url entered \n \(downlUrl)")
            var downloadAlert = UIAlertController(title: "empty link", message: "tls required, add https://www.website.com", preferredStyle: .alert)
            self.present(downloadAlert, animated: true, completion: nil)
        }
        
        print("[Download Url Being Parsed \(downlUrl)")
        handleHttpDwn(textViewData: downlUrl)
    }
    
    internal func handleHttpDwn(textViewData: String) {
        print("[!] [textview URL] \(dl.url)")
        print("[!] [download URL] \(textViewData)")
        dl.url = textViewData
        try? dl.setSession()
    }
    
    
    private func performDisplayHrefTableView() {
        print("[!] Performing segue")
        performSegue(withIdentifier: "HrefSoup", sender: self)
        
    }
    
    // TODO: Check on setSession, see if it needs a var to be passed.
    @objc func didUpdateNotification(_ notification: Notification) throws {
        print("[!].. Editing notification center.. ")
        guard let fetchURL = notification.object as? String else { throw notificationError.passNotificationErr }
        try?dl.setSession()
        
    }
    private func printHrefSoupList(ahref: [Element] , count: Int, ptag: [Element]) {
        print("[+] Parsing users Soup Reqeust --> Displaying available downloads")
        print(".. \(count) \(ahref) \(ptag)")
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar?.progress = 0
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateNotification), name: .downloadURL , object: nil)
        // try?dl.setSession()
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
        self.performSegue(withIdentifier: "FtpSeg", sender: self)
        
        
    }
    func handleSMB(textViewData: String?) {
        print("[!] Handling SMB Data")
        let smbURL = "smb://\(urlParser.url.description):445"
        guard dl.url == smbURL else { return }
        print("[!] HANDLE SMB URL \(smbURL)")
        print("[!] dl.url FTP - \(smbURL)")
        
        self.performSegue(withIdentifier: "SmbView", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FtpSeg"  {
            let seg = segue.destination as? FtpView
            let url = self.uiSearchBar.text
            print("[!] URL for FTP being passed: \(String(describing: url))")
            seg?.FtpTextField?.text = url
            seg?.ftpURL = url ?? "ftp://arobotsandbox.asuscomm.com:21"
    
        }
        
        if segue.identifier == "SmbView"  {
            let seg = segue.destination as? SmbView
            let url = "smb://\(String(describing: self.uiSearchBar.text)):139"
            seg?.smbURL = url ?? "smb://arobotsandbox.asuscomm.com:139"
            
        }
    
        if segue.identifier == "HrefSoup"  {
            let seg = segue.destination as? HrefSoup
            let url = "https://\(String(describing: self.uiSearchBar.text))"
            seg?.soupURL = url 
           // seg?.performSegue(withIdentifier: url!, sender: self)
            
        }
        
        
    }
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

