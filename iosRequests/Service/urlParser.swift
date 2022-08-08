//
//  urlHelper.swift
//  DownloadManagerIII
//
//  Created by Adel Al-Aali on 6/28/22.
//

import Foundation

internal class urlParser {
    
    private let dlVC = DownloaderVC()
    static var fetch = urlParser()
    static var url = "https://kimcartoon.li/Cartoon/The-Simpsons-Season-33"
    public func getUrl() -> String {
        
        DispatchQueue.main.async {
            [weak self] in
            var gotUrl = urlParser.url.description.lowercased()
            DownloaderVC.shared.urlTextView?.text = gotUrl.lowercased()
            DownloaderVC.shared.IP = gotUrl.lowercased()
           // self?.dlVC.urlTextView?.text = gotUrl.lowercased()
            self?.updateHomeVC(text:gotUrl)
            print("[!] Passing Url.. \(urlParser.url.description)")
        }
            return urlParser.url
        }
    
    public func changeUrl(newLink: String?) -> String {
        urlParser.self.url = newLink ?? urlParser.url
        let returnText = urlParser.url.description.lowercased()
        var changeUrl = urlParser.url.lowercased()
        print("[!] Changing URL00 \(String(describing: changeUrl))")
        print("[!] Changing URL01 \(changeUrl)")
        print(returnText)
        updateHomeVC(text:changeUrl)
        return returnText.lowercased()
    }
    
    public func updateHomeVC(text: String) {
        DispatchQueue.main.async {
            [weak self] in
            print("[!] Updating HomeVC [URL TEXT VIEW] --> \(text)")
            //self?.dlVC.urlTextView?.text = text
            DownloaderVC.shared.urlTextView?.text = text
            DownloaderVC.shared.viewWillAppear(true)
            DownloaderVC.shared.viewDidAppear(true)
        }
   
    }
}

