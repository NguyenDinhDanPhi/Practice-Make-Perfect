//
//  InboxNoticesMock.swift
//  DemoNotification
//
//  Created by dan phi on 13/4/25.
//


struct InboxNotices: Codable {
    let id: String
    let category: String
    let typeRender: RenderType
    let message: NoticeMessage
    let redirectURL: String
    let redirectContent: String?
    let status: String
    let createdAt: CreatedAt
    let attribute: Attribute

    enum CodingKeys: String, CodingKey {
        case id
        case category
        case typeRender = "type_render"
        case message
        case redirectURL = "redirect_url"
        case redirectContent = "redirect_content"
        case status
        case createdAt = "created_at"
        case attribute
    }
}

// MARK: - RenderType
enum RenderType: String, Codable {
    case userAction = "user_action"
    case common = "common"
}

// MARK: - NoticeMessage
struct NoticeMessage: Codable {
    let title: String?
    let body: String?
    let image: String?
}

// MARK: - CreatedAt
struct CreatedAt: Codable {
    let timestamp: Int
    let iso8601: String

    enum CodingKeys: String, CodingKey {
        case timestamp
        case iso8601 = "iso_8601"
    }
}

// MARK: - Attribute
struct Attribute: Codable {
    let from: [UserProfile]
    let extra: ExtraInfo?
}

// MARK: - UserProfile
struct UserProfile: Codable {
    let id: String?
    let name: String?
    let redirectURL: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case redirectURL = "redirect_url"
        case image
    }
}

// MARK: - ExtraInfo
struct ExtraInfo: Codable {
    let more: String?
    let redirectURL: String?

    enum CodingKeys: String, CodingKey {
        case more
        case redirectURL = "redirect_url"
    }
}

struct InboxNoticesResponse: Codable {
    let code: String
    let data: [InboxNotices]
}
