//
//  SmbView.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/3/22.
//

import UIKit
import WebKit

@IBDesignable internal class SmbView: ViewControllerLogger, URLSessionDelegate
{
	
    fileprivate let parseUrl = urlParser.url.lowercased()
	lazy var downloadsSession: URLSession = {
		let configuration = URLSessionConfiguration.background(withIdentifier:urlParser.shared.getUrl().description)
		
		return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
	}()
	
	
	@objc func dismissKeyboard() {
		searchBar.resignFirstResponder()
	}
	
	lazy var tapRecognizer: UITapGestureRecognizer = {
		var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
		return recognizer
	}()
	
	
    @IBInspectable private let backupURL = URL(string: "smb://arobotsandbox.asuscomm.com:445")!
    @IBInspectable var smbURL: String = ""
    @IBOutlet weak var smbTextField: UITextView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var smbWeb : WKWebView? {
        didSet {
            print("loading webview for \(self.smbURL.lowercased())")
            let preferences = WKPreferences()
            let configuration = WKWebViewConfiguration()
            preferences.javaScriptEnabled = true
            configuration.preferences = preferences
            let webView = WKWebView(frame: .zero, configuration: configuration)
            parseUIView(webView)
        }
    }
    fileprivate func parseUIView(_ uiView: WKWebView) {
        let group = DispatchGroup()

        group.wait()
        group.enter()
        let backupURL = "smb://arobotsandbox.asuscomm.com:445"
        let backupURLformatted = URL(string: "smb://arobotsandbox.asuscomm.com:139")!

        var url = self.smbURL.lowercased()
        url = "smb://\(url):445"
        let requestURL = URLRequest(url: URL(string: url ) ?? backupURLformatted)
        print("[!] Starting Request on \(requestURL)")
        uiView.load(requestURL)
        group.leave()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backupURL = URL(string: "smb://arobotsandbox.asuscomm.com:445")!
        let backupURLString = "smb://arobotsandbox.asuscomm.com:445"
        
        if let url = URL(string: smbURL.lowercased() ) {
            print("[+] URL Value for WebView \(url)")
            searchBar.text = smbURL.lowercased().description
            smbTextField.text = url.description
            smbWeb?.load(URLRequest(url: url ?? backupURL))
        }
        print("[!] View Did Load- Passed \(smbURL)")
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.addSubview(smbWeb!)
    }
}
