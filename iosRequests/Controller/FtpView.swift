//
//  FtpView.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/4/22.
//

import WebKit
import UIKit

internal class FtpView: ViewControllerLogger, WKNavigationDelegate, WKUIDelegate
{
    
    private static var check = FtpView()
    private var dl = downloaderLogic()
    
    private let backupURL = URL(string: "ftp://arobotsandbox.asuscomm.com:21")!
    private let backupURLString: String  = "ftp://arobotsandbox.asuscomm.com:21"
    
    @IBOutlet weak var FtpTextField: UITextView!
    @IBOutlet weak var FtpSearchField: UISearchBar!
    @IBAction func FtpSearchField(sender: UISearchBar) {
        print("[!] Ftp Search Bar Touched. ")
    }
    
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
    
    
    @IBOutlet weak var searchBar: UISearchBar!

    private func parseUIView(_ uiView: WKWebView) {
        let url = ftpURL.description
        let requestURL = URLRequest(url: URL(string: url )!)
        print("[!] Starting Request on \(requestURL)")
        ftpWeb?.load(requestURL)
    }
    
    
    var ftpURL: String = "" {
        didSet {
            print("ftp url set")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("[!] View Did Load- Passed \(ftpURL)")
        
        let url = URL(string: self.ftpURL )
        let request =  URLRequest(url: url!)
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)

        FtpTextField?.text = url?.absoluteString
        //FtpTextField?.text = request.description
        ftpWeb!.load(request)
        parseUIView(webView)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        ftpWeb?.reload()
    }
    
    // TODO: On User Press -- Initiate download session:
    private func startSession() {
        try? dl.setSession()
    }
}
