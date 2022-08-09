//
//  ViewControllerExtension.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/9/22.
//

import Foundation
import UIKit


// MARK: Debugger #2 -> (NSLog("print error logging"))
extension UIViewController {
    func createLogFile() {
	  if let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
		let fileName = "\(Date()).log"
		let logFilePath = (documentsDirectory as NSString).appendingPathComponent(fileName)

		freopen(logFilePath.cString(using: String.Encoding.ascii)!, "a+", stderr)
	  }
    }
}

