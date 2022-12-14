//
//  ViewController.swift
//  DownloadManagerIII
//
//  Created by Adel Al-Aali on 6/19/22.
// ftp://arobotsandbox.asuscomm.com


import UIKit
import Foundation
import SwiftSoup
@IBDesignable class DownloaderVC: ViewControllerLogger, UIImagePickerControllerDelegate,  UINavigationControllerDelegate, URLSessionDelegate
{
	public var downloadsSession: URLSession!
	public var soupLinks : [Element] = [Element]()
	static let shared = DownloaderVC()
	private var dl = downloaderLogic()
	private let cellid = "cellid"
	var filteredData: [String]!
	
	
	internal var IP: String = "" {
		didSet {
			print("[+] IP Value Set by [URL PARSER] \n \(IP)")
			urlTextView?.text = IP.lowercased()
			viewDidLoad()
		}
	}
	
	internal var TEXT: String = "" {
		didSet {
			print("[+] TEXT Value Set by [URL PARSER] \n \(IP)")
			textView?.text = TEXT.lowercased()
			viewDidLoad()
		}
	}
	
	internal var USER: String = ""
	internal var PORT: String = ""
	fileprivate var imagePicker = UIImagePickerController()
	
	

	lazy var tapRecognizer: UITapGestureRecognizer = {
		var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
		return recognizer
	}()
	@objc func dismissKeyboard() {
		searchBar.resignFirstResponder()
	}
	
	
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var progressBar: UIProgressView?
	@IBOutlet weak var progressLbl: UILabel!
	@IBOutlet weak var urlLbl: UILabel!
	
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var urlTextView: UITextView?
	@IBOutlet weak var dlView: UIView?
	
	
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
	
	
	@IBOutlet weak var searchBar: UISearchBar! {
		
		didSet {
			DispatchQueue.main.async {
				[weak self] in
				
				print("[!] UI SearchBar set")
				let text = self?.searchBar?.text?.lowercased()
				let newUrl = urlParser.fetch.changeUrl(newLink: self?.searchBar?.text)
				if newUrl.isEmpty || newUrl.hasPrefix("http://") {
					var dialogMessage = UIAlertController(title: "Attention", message: "tls required, add https", preferredStyle: .alert)
				}
				
				self?.IP = urlParser.url.description
				print("[!] UI SearchBar Text \(newUrl))")
				print(text)
				urlParser.fetch.changeUrl(newLink: text)
				print(urlParser.fetch.getUrl())
				print("[+] New Url After Searchbar Change,\n \(newUrl)")
				print("[!][!] --> URLPARSER \(urlParser.url.description) ")
				print("[!][!] --> IP \(self?.IP) ")
				
			}
		}
	}
	
	
	@IBAction func uiSearchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		print("[!] SearchBar Value Changed \n \(String(describing: searchBar.text))")
		urlTextView?.text = searchBar.text
	}
	
	
	@IBAction func uploadBtn(_ sender: UIButton) {
		print("[!] User has initiated uploading button")
		performSegue(withIdentifier: "uploadSegue", sender: self)
	}
	
	
	@IBAction func ftpBtn (_ sender: UIButton) {
		print("[FTP] Pressed")
		let fetchURL = urlParser.fetch.changeUrl(newLink: searchBar?.text)
		handleFTP(textViewData: fetchURL)
		performSegue(withIdentifier: "FtpSeg", sender: self)
	}
	@IBAction func smbBtn(_ sender: UIButton) {
		print("[SMB] Btn Pressed ")
		let fetchURL = urlParser.fetch.changeUrl(newLink: searchBar?.text)
		print("[SMB] URL \(fetchURL)")
		
		handleSMB(textViewData: fetchURL)
		performSegue(withIdentifier: "SmbView", sender: self)
	}
	@IBAction func httpSoupBtn(_ sender: UIButton) {
		let fetchURL = urlParser.fetch.changeUrl(newLink: searchBar?.text).lowercased()
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
		var downlUrl = urlParser.fetch.changeUrl(newLink: searchBar?.text).lowercased().description
		
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
		//https://archive.org/download/nes-romset-ultra-us/1942%20%28U%29%20%5B%21%5D.zip
		// let fetchURL = urlParser.fetch.changeUrl(newLink: uiSearchBar?.text)
		dl.dlURL = textViewData
		
		print("[!] [textview URL] \(dl.dlURL)")
		print("[!] [download URL] \(textViewData)")
		//        let data = try? dl.setDLSession(completion: { dl.dlURL , <#String#> in
		//            <#code#>
		//        })
		//FileLogic
	}
	
	
	private func performDisplayHrefTableView() {
		print("[!] Performing segue")
		performSegue(withIdentifier: "HrefSoup", sender: self)
		
	}
	
	// TODO: Check on setSession, see if it needs a var to be passed.
	@objc func didUpdateNotification(_ notification: Notification) throws {
		print("[!].. Editing notification center.. ")
		guard let fetchURL = notification.object as? String else { throw notificationError.passNotificationErr }
		// try?dl.setDLSession()
	}
	
	@objc func hrefSoupNotification(_ notification: Notification) throws {
		print("[!] Notification [HREF] on homeVC recieved from Soup ")
		guard let hrefURL = notification.object as? [Element] else { throw notificationError.fetchSoupErr }
		print("[+] [+] homeVC recieved [NOTIFICATION] from [HREF-Soup] \(hrefURL)")
	}
	
	
	private func printHrefSoupList(ahref: [Element] , count: Int, ptag: [Element]) {
		print("[+] Parsing users Soup Reqeust --> Displaying available downloads")
		print(".. \(count) \(ahref) \(ptag)")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//   uiSearchBar.delegate = self
		// filteredData = IP
		progressBar?.progress = 0
		
		// Notification Obserervers [soup links / href direct download]
		NotificationCenter.default.addObserver(self, selector: #selector(didUpdateNotification), name: .downloadURL , object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(hrefSoupNotification), name: .soupHref, object: nil)
		
		// try?dl.setSession()
	}
	
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		print("\n \n [!][!] [viewWillLayoutSubviews CALLED] ")
		urlTextView?.text = urlParser.url.description
		urlTextView?.text = IP
		urlTextView?.text = urlParser.fetch.getUrl()
		textView?.text = TEXT.lowercased()
		print("[!][!] --> URLPARSER \(urlParser.url.description) ")
		print("[!][!] --> IP \(IP) ")
		if dlView != nil {
			view.addSubview(dlView!)
		}
		setupViews()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("[!][!] [VIEW WILL APPEAR CALLED] ")
		urlTextView?.text = urlParser.shared.getUrl()
		
		if dlView != nil {
			view.addSubview(dlView!)
		}
		setupViews()
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(false)
		print("[!][!] [viewDidAppear CALLED] ")
		
		let soupUrl = HrefSoup.shared.soupURL
		let parserUrl =  urlParser.shared.getUrl()
		if soupUrl.isEmpty {
			urlTextView?.text = parserUrl
			
		} else { urlTextView?.text = soupUrl
		}
		
		
		//urlTextView?.text = urlParser.url.description
		/// view.reloadInputViews()
		print("[!][!] --> URLPARSER \(urlParser.url.description) ")
		print("[!][!] --> IP \(IP) ")
		print(NotificationCenter.Notifications.Element.Name("soupHref"))
		print(Notification.Name.soupHref.rawValue)
		print(Notification.Name("soupHref"))
		print(HrefSoup.shared.subscriptions)
		
		
		if dlView != nil {
			view.addSubview(dlView!)
		}
		setupViews()
	}
	override func reloadInputViews() {
		super.reloadInputViews()
		print("\n \n [!][!] [RELOAD INPUT VIEWS CALLED] ")
		urlTextView?.text = urlParser.url.description
		urlTextView?.text = IP
		view.reloadInputViews()
		setupViews()
		print("[!][!] --> URLPARSER \(urlParser.url.description) ")
		print("[!][!] --> IP \(IP) ")
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func setupViews() {
		print("[!] Laying out [TABLE CELL VIEWS] ")
		self.tableView?.reloadData()
		self.tableView?.isHidden = false
		self.tableView?.addSubview(UITableView())
		self.tableView?.layoutSubviews()
	}
	
	
	func handleFTP(textViewData: String?) {
		print("[!] Handling FTP Data")
		let ftpURL = "ftp://\(urlParser.url.description):21"
		print("url textview set \(ftpURL)")
		guard dl.dlURL == ftpURL else { return }
		print("[!] dl.url FTP - \(ftpURL)")
		self.performSegue(withIdentifier: "FtpSeg", sender: self)
		
		
	}
	func handleSMB(textViewData: String?) {
		print("[!] Handling SMB Data")
		let smbURL = "smb://\(urlParser.url.description):445"
		guard dl.dlURL == smbURL else { return }
		print("[!] HANDLE SMB URL \(smbURL)")
		print("[!] dl.url FTP - \(smbURL)")
		
		self.performSegue(withIdentifier: "SmbView", sender: self)
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "FtpSeg"  {
			let seg = segue.destination as? FtpView
			let url = self.searchBar.text
			print("[!] URL for FTP being passed: \(String(describing: url))")
			seg?.FtpTextField?.text = url
			seg?.ftpURL = url ?? "ftp://arobotsandbox.asuscomm.com:21"
			
		}
		
		if segue.identifier == "SmbView"  {
			let seg = segue.destination as? SmbView
			let url = "smb://\(String(describing: self.searchBar.text)):139"
			seg?.smbURL = url ?? "smb://arobotsandbox.asuscomm.com:139"
			
		}
		
		if segue.identifier == "HrefSoup"  {
			let seg = segue.destination as? HrefSoup
			let url = "https://\(String(describing: self.searchBar.text))"
			seg?.soupURL = url
			// seg?.performSegue(withIdentifier: url!, sender: self)
			
		}
		
		
	}
}

extension DownloaderVC: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if (filteredData != nil) == searchText.isEmpty
		{
			print("[!] Downloader SearchBar was Used! \n \(searchBar.text?.description)")
			
		}
	}
}



