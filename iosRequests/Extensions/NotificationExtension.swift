//
//  NotificationExtension.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/7/22.
//

import Foundation



enum hrefNotificationError: Error {
    case hrefNotifErr
}

enum notificationError: Error {
    case passNotificationErr
    case fetchSoupErr
}


extension Notification.Name {
    internal static let downloadURL = Notification.Name("downloadURL")
    internal static let soupHref = NSNotification.Name("soupHref")
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

extension hrefNotificationError {
    public var hrefNotifications : String {
        switch self {
        case .hrefNotifErr : return "[-] Error in Href Notifications... \(localizedDescription)"
        }
    }
}



