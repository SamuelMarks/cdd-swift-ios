//
//  API.swift
//  ios
//
//  Created by Alexei on 04/07/2019.
//  Copyright © 2019 Alexei. All rights reserved.
//

import UIKit
import Alamofire


struct Room_rename : Decodable {
    let room_id: String?
    let user_id: String?
    let room_name_old: String?
    let room_name: String?
}

struct Message : Decodable {
    let image: String?
    let modified_at: String?
    let message: String?
    let status: String?
    let user_id: String?
    let message_id: String?
    let room_id: String?
    let created_at: String?
    let thumbnail: String?
}

struct Favorite : Decodable {
    let id: String?
    let tourId: String?
}

struct Comment : Decodable {
    let tourId: String?
    let guideId: String?
    let id: String?
    let timestamp: String?
    let rating: Float?
    let message: String?
}

struct Attach_room : Decodable {
    let owner: String?
    let user_id: String?
    let room_id: String?
}

struct On_typing : Decodable {
    let user_id: String?
    let room_id: String?
}

struct Tour : Decodable {
    let tags: String?
    let language: String?
    let specialization: String?
    let id: String?
    let country: String?
    let name: String?
    let description: String?
    let images: String?
    let transfer: String?
    let published: Bool?
    let city: String?
    let createdTs: Float?
    let ownerUserId: Int?
    let updatedTs: Float?
}

struct UserAuth : Decodable {
    let specialization: String?
    let id: Int?
    let city: String?
    let gender: String?
    let token: String?
    let lastName: String?
    let description: String?
    let phone: String?
    let firstName: String?
    let logoPath: String?
    let email: String?
    let birthdate: String?
}

struct Guide_places : Decodable {
    let description: String?
    let name: String?
    let geoPosition: String?
    let address: String?
}

struct UserOnline : Decodable {
    let birthdate: String?
    let description: String?
    let gender: String?
    let firstName: String?
    let lastName: String?
    let specialization: String?
    let email: String?
    let status: String?
    let logoPath: String?
    let id: String?
    let city: String?
    let phone: String?
}

struct MessageHistoryList : Decodable {
    let hasMore: Bool?
}

struct Schedule : Decodable {
    let id: String?
    let tourId: String?
    let ts: Int?
    let ownerUserId: Int?
}

struct Room_create : Decodable {
    let room_name: String?
    let room_id: String?
    let users: String?
    let owner: String?
    let request_id: String?
    let image: String?
}

struct Room_preview_full : Decodable {
    let last_message: String?
    let last_messages: String?
    let unread: Int?
    let image: String?
    let type: String?
    let room_id: String?
    let name: String?
}

struct Image : Decodable {
    let path: String?
    let name: String?
    let description: String?
}

struct Room_preview : Decodable {
    let type: String?
    let unread: Int?
    let last_message: String?
    let last_messages: String?
    let room_name: String?
    let users: [String]?
    let room_id: String?
}

struct Guide : Decodable {
    let country: String?
    let category: String?
    let name: String?
    let ownerUserId: Int?
    let createdTs: Float?
    let published: Bool?
    let updatedTs: Float?
    let id: String?
    let description: String?
    let city: String?
    let tags: String?
}

struct Delete_message : Decodable {
    let message_id: String?
    let room_id: String?
    let user_id: String?
}

struct On_joined : Decodable {
    let username: String?
    let numUsers: Int?
}

struct Booking : Decodable {
    let scheduleId: String?
    let id: String?
    let createdTs: Int?
    let ownerUserId: Int?
    let status: String?
    let ts: Int?
    let GuideUserId: Int?
    let tourId: String?
}

struct TourFull : Decodable {
    let transfer: String?
    let createdTs: Float?
    let published: Bool?
    let language: String?
    let tags: String?
    let description: String?
    let specialization: String?
    let name: String?
    let ownerUserId: Int?
    let country: String?
    let city: String?
    let id: String?
    let updatedTs: Float?
}

struct User : APIModel {
    let city: String?
    let firstName: String?
    let phone: String?
    let lastName: String?
    let specialization: String?
    let logoPath: String?
    let id: Int?
    let email: String?
    let gender: String?
    let description: String?
    let birthdate: String?
}

struct RecentStatus : Decodable {
    let is_online: Bool?
    let last_join_timestamp: Int?
    let seconds: Int?
    let last_time_string: String?
}

struct Attachment : Decodable {
    let type: String?
    let url: String?
    let thumbnail: String?
    let uuid: String?
    let message: String?
}

struct ApiV2FavoritetourDeletePostRequest : APIRequest {
    typealias ResponseType = EmptyResponse
    typealias ErrorType = EmptyResponse
    func method() -> HTTPMethod { return .post }
    let tourId: String?
    var urlPath: String {
        return "/api/v2/favoritetour/delete"
    }
}
