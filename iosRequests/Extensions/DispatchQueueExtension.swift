//
//  DispatchQueueExtension.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/7/22.
//

import Foundation
import UIKit


extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}
