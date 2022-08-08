//
//  urlSessionsExtension.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/7/22.
//

import Foundation
import UIKit


enum sessionsError : Error {
    case urlErr
    case noDataInResponse
    case noJsonResponse
}
extension sessionsError  {
    private var downloaderLogiErr : String {
        switch self {
        case .urlErr : return "[-] Error URL Session Closure"
        case .noDataInResponse : return "[-] No Data in Sessions Response"
        case .noJsonResponse : return "[-] No Json in Sessions Response"
        }
    }
}


