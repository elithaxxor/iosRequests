//
//  SmbView.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/3/22.
//

import UIKit
import WebKit

@IBDesignable
class SmbView: ViewControllerLogger {
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
        let url = smbURL.lowercased()
        let backupURL = URL(string: "smb://arobotsandbox.asuscomm.com:445")!
        
        
        let requestURL = URLRequest(url: URL(string: url)!)
        print("[!] Starting Request on \(requestURL)")
        smbWeb?.load(requestURL)
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
    


}
