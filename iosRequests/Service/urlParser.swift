//
//  urlHelper.swift
//  DownloadManagerIII
//
//  Created by Adel Al-Aali on 6/28/22.
//

import Foundation

class urlParser {
    
    static var fetch = urlParser()
    static var url = "https://kimcartoon.li/Cartoon/The-Simpsons-Season-33"
    private func getUrl() -> String {
        print("[!] Passing Url.. \(urlParser.url)")
        return urlParser.url
    }
    func changeUrl(newLink: String?) -> String {
            urlParser.self.url = newLink ?? urlParser.url
            print("[!] Changing URL00 \(String(describing: changeUrl))")
            print("[!] Changing URL01 \(urlParser.url.description)")
            
            
            var returnText = urlParser.url.description
            print(returnText)
            //  return urlParser.url.description
            return returnText
        
    }
}
                           