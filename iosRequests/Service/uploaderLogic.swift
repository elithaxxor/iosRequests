////
////  uploaderLogic.swift
////  DownloadManagerIII
////
////  Created by Adel Al-Aali on 6/19/22.
////
//
//import Foundation
//
//
///// Allow Arbitrary Load"" key to the Info.plist '''
//
//struct uploaderLogic{
//    
//    func setSessions() {
//        
//        let uploadTask = URLSession.shared.dataTask(with: uploadURL) {data, response, error }
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//        guard let uploadURL = URL(string: homeTextView.text ?? "https://httpbin.org/anything")!
//                if let uploadRequest == URLRequest(url: uploadURL) {
//                    print("[+]  Post Requests Made! ")
//                    urlRequest.httpMethod = "POST"
//                    let postDict : [String: Any] = ["name" : "axel", "favorite_animal" : ""]
//                    
//                }
//        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
//            return
//        }
//        
//        uploadRequest.httpBody = postData
//        let uploadRequest = session.dataTask(with: )
//
//    }
//    print("[!] ")
//}
//
