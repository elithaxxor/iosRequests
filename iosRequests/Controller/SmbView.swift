//
//  SmbView.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/3/22.
//

import UIKit
import WebKit

class SmbView: ViewControllerLogger {
    let backupURL = URL(string: "smb://arobotsandbox.asuscomm.com:445")!
    
    
    @IBOutlet weak var smbTextField: UITextView!
    

 
    @IBOutlet weak var smbWeb : WKWebView? {
        didSet {
            let preferences = WKPreferences()
            preferences.javaScriptEnabled = true
            let configuration = WKWebViewConfiguration()
            configuration.preferences = preferences
            let webView = WKWebView(frame: .zero, configuration: configuration)
            parseUIView(webView)
        }
    }
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var smbURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backupURL = URL(string: "smb://arobotsandbox.asuscomm.com:445")!
        let backupURLString = "smb://arobotsandbox.asuscomm.com:445"
        let url = URL(string: searchBar.text ?? backupURLString)
        
        smbTextField.text = url?.description
        smbWeb?.load(URLRequest(url: url ?? backupURL))
        print("[!] View Did Load- Passed \(smbURL)")
        
        
        
    }
    
    
    private func parseUIView(_ uiView: WKWebView) {
        let url = smbURL.description
        let backupURL = URL(string: "smb://arobotsandbox.asuscomm.com:445")!

        let requestURL = URLRequest(url: URL(string: url ) ?? backupURL)
        print("[!] Starting Request on \(requestURL)")
        smbWeb?.load(requestURL)
    }
    

}
