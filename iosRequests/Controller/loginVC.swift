//
//  loginVC.swift
//  DownloadManagerIII
//
//  Created by Adel Al-Aali on 7/6/22.
//

import Foundation
import UIKit

class loginVC: ViewControllerLogger, UITextFieldDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var progressLabel: UIProgressView!
    
    @IBAction func searchQuery(_ sender: Any) {
        if validateText(text: urlTextField.text!) && validateText(text: userTextField.text!) { validateText(text: portTextField.text!)
            let combinedAddr = "\(urlTextField.text):\(portTextField.text)"
            let user = userTextField.text
            print("\(combinedAddr) + \(user)")
            userLabel.text = "\(combinedAddr) + \(user)"
        }
        }
    
    
    
    @IBAction func enterBtn() {
        print("[!] User initiated enter btn! ")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "downloaderVC") as? DownloaderVC
        vc?.IP = urlTextField.text ?? "localhost"
        vc?.USER = userTextField.text ?? "default user val"
        vc?.PORT = portTextField.text ?? "21"
        
    }
    
    private func validateText(text: String) -> Bool {
        print("[!] Validating Text ")
        if (text != nil) { return true }
        return false
    }
    override func viewDidLoad() {
        urlTextField.delegate = self
        userTextField.delegate = self
        portTextField.delegate = self
        
        if let ip = UDW.shared.defaults!.value(forKey: "ip") {
            if let port = UDW.shared.defaults!.value(forKey: "port") {
                if let user = UDW.shared.defaults!.value(forKey: "user") {
                    print("\(ip):\(port) \(user)")
                    userTextField.text = "\(ip):\(port) \(user)"
                }
            }
            
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UDW.shared.defaults?.setValue(userTextField.text, forKey: "user")
        UDW.shared.defaults?.setValue(urlTextField.text, forKey: "ip")
        UDW.shared.defaults?.setValue(portTextField.text, forKey: "port")
        
        urlTextField.resignFirstResponder()
        userTextField.resignFirstResponder()
        portTextField.resignFirstResponder()
        return true
        
    }
    
}

class UDW {
    static let shared = UDW()
    let defaults = UserDefaults(suiteName: "io.nobodylikesme.downloader")
}
