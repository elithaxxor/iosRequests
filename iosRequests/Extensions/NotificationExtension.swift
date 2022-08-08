//
//  NotificationExtension.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/7/22.
//

import Foundation

extension Notification.Name {
    internal static let downloadURL = Notification.Name("downloadURL")
    internal static let soupHref = Notification.Name("soupHref")
    internal static let soupPtags = Notification.Name("soupPtags")
    internal static let ftpHref = Notification.Name("ftpHref")
    internal static let smbHref = Notification.Name("smbHref")
}


extension notificationError {
    public var notificationErrDescriotion : String {
        switch self {
        case .passNotificationErr : return "[-] caught error in notification, please edit"
        case .fetchSoupErr : return "[-] caught error in populating soup Array "
        }
    }
}


enum notificationError: Error {
    case passNotificationErr
    case fetchSoupErr
}


