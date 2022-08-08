//
//  FtpView.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/4/22.
//

import WebKit
import UIKit
import SafariServices


internal class FtpView: ViewControllerLogger, WKNavigationDelegate, WKUIDelegate
{
    private static var check = FtpView()
    private var dl = downloaderLogic()
   // private let ss = SafariServices

    private let backupURL = URL(string: "ftp://arobotsandbox.asuscomm.com:21")!
    private let backupURLString: String  = "ftp://arobotsandbox.asuscomm.com:21"
    
    @IBOutlet weak var FtpTextField: UITextView!
    @IBOutlet weak var FtpSearchField: UISearchBar!
    @IBAction func FtpSearchField(sender: UISearchBar) {
        print("[!] Ftp Search Bar Touched. ")
    }
    
    @IBOutlet weak var ftpWeb : WKWebView! {
        didSet {
            let preferences = WKPreferences()
            preferences.javaScriptEnabled = true
            let configuration = WKWebViewConfiguration()
            configuration.preferences = preferences
            let webView = WKWebView(frame: .zero, configuration: configuration)
            parseUIView(ftpWeb!)
        }
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!

    private func parseUIView(_ uiView: WKWebView) {
        var url = ftpURL.description
        url = "ftp://\(url):21"
        var requestURL = URLRequest(url: URL(string: url )!)
        print("[!] Starting Request on \(requestURL)")
        uiView.load(requestURL)
    }
    
    private func delayRun(after seconds: Int, completion: @escaping() -> Void) {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) { completion() }
    }
    
    
    
    var ftpURL: String = "" {
        didSet {
            print("[!] ftp url set \(ftpURL.description)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("[!] View Did Load- Passed \(ftpURL)")
        
        let url = URL(string: ftpURL)
        let backupUrl = URL(string: "ftp://192.168.50.111:21")!
        let backupRequest = URLRequest(url: backupUrl)
        let request =  URLRequest(url: url ?? backupUrl)
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)

        parseNotification()
        FtpTextField?.text = url?.absoluteString
        //FtpTextField?.text = request.description
        // ftpWeb!.load(request)
        parseUIView(webView)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //parseUIView(ftpWeb?)
        //parseUIView(ftpWeb)
        ftpWeb?.reload()
        view.addSubview(ftpWeb)
    }
    
    
    private func parseNotification() {
        let addSymbol2Url = NSNotification.Name.ftpHref
        let url = URL(string: ftpURL )
        let request =  URLRequest(url: url!)
        ftpWeb!.load(request)
    }
    
    // TODO: On User Press -- Initiate download session:
    private func startSession() {
        try? dl.setFTPSession()
    }
}
