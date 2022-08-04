//
//  FtpView.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/4/22.
//

import WebKit
import UIKit

class  FtpView: ViewControllerLogger
{

    static var check = FtpView()
    
    let backupURL = URL(string: "ftp://arobotsandbox.asuscomm.com:21")!
    let backupURLString: String  = "ftp://arobotsandbox.asuscomm.com:21"

    
    @IBOutlet weak var ftpWeb : WKWebView? {
        didSet {
            let preferences = WKPreferences()
            preferences.javaScriptEnabled = true
            let configuration = WKWebViewConfiguration()
            configuration.preferences = preferences
            let webView = WKWebView(frame: .zero, configuration: configuration)
            parseUIView(webView)
        }
    }
    
    
    private func parseUIView(_ uiView: WKWebView) {
        let url = ftpURL.description
        let requestURL = URLRequest(url: URL(string: url ?? self.backupURLString)!)
        print("[!] Starting Request on \(requestURL)")
        uiView.load(requestURL)
    }
    
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var ftpURL: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("[!] View Did Load- Passed \(ftpURL)")
        var url = URL(string: ftpURL ?? self.backupURLString)!
        let request =  URLRequest(url: url)
        ftpWeb!.load(request)
    }
    
    
}
