//
//  SocialPlatform.swift
//  DemoDragtoDeleteCell
//
//  Created by dan phi on 2/4/25.
//

import UIKit

struct SocialNetworkSharingModel {
    let icon: UIImage?
    let title: String
    let action: () -> Void
}

enum SocialPlatform: CaseIterable {
    case copy
    case facebook
    case messenger
    case telegram
    case sms
    case x
    case whatsapp
    case more

    var title: String {
        switch self {
        case .copy: return "Copy"
        case .facebook: return "Facebook"
        case .messenger: return "Messenger"
        case .telegram: return "Telegram"
        case .sms: return "SMS"
        case .x: return "X"
        case .whatsapp: return "WhatsApp"
        case .more: return "More"
        }
    }

    var iconName: String {
        switch self {
        case .copy: return "ic_copyLink"
        case .facebook: return "ic_fb"
        case .messenger: return "ic_messenger"
        case .telegram: return "ic_telegram"
        case .sms: return "ic_sms"
        case .x: return "ic_twitter"
        case .whatsapp: return "ic_whatapp"
        case .more: return "ic_more"
        }
    }

    var urlScheme: String? {
        switch self {
        case .facebook: return "fb://composer?text="
        case .messenger: return "fb-messenger://share?link="
        case .telegram: return "tg://msg?text="
        case .sms: return "sms:?&body="
        case .x: return "twitter://post?message="
        case .whatsapp: return "whatsapp://send?text="
        default: return nil
        }
    }

    var webURL: String? {
        switch self {
        case .facebook: return "https://www.facebook.com/sharer/sharer.php?u="
        case .messenger: return "https://www.messenger.com/t/"
        case .telegram: return "https://t.me/share/url?url="
        case .x: return "https://twitter.com/intent/tweet?text="
        case .whatsapp: return "https://api.whatsapp.com/send?text="
        default: return nil
        }
    }

    var requiresAppInstalled: Bool {
        switch self {
        case .copy, .sms, .more: return false
        default: return true
        }
    }
}
