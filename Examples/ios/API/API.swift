//
//  API.swift
//  ios
//
//  Created by Alexei on 04/07/2019.
//  Copyright © 2019 Alexei. All rights reserved.
//

import UIKit
import Alamofire

struct Message : APIModel {
    /// Время отправки сообщения (Timestamp, миллисекунды)
    let created_at: String?
    /// Идентификатор пользоваля, автор сообщения
    let user_id: String?
    /// Статус сообщения(new|delivered|read)
    let status: String?
    /// Идентификатор сообщений
    let message_id: String?
    /// Время изменения сообщения (Timestamp, миллисекунды). Например, отметить как прочитанное, меняет modified.
    let modified_at: String?
    /// Идентификатор комнаты
    let room_id: String?
    /// image
    let image: String?
    /// Текст сообщения
    let message: String?
    /// thumbnail
    let thumbnail: String?
}

struct Favorite : APIModel {
    let id: String?
    let tourId: String?
}

struct Tour : APIModel {
    ///
    let language: String?
    ///
    let city: String?
    ///
    let id: String?
    ///
    let ownerUserId: Int?
    ///
    let specialization: String?
    ///
    let description: String?
    ///
    let createdTs: Float?
    ///
    let name: String?
    ///
    let country: String?
    ///
    let images: String?
    ///
    let transfer: String?
    ///
    let tags: String?
    ///
    let updatedTs: Float?
    ///
    let published: Bool?
}

struct On_typing : APIModel {
    /// Идентификатор комнаты
    let room_id: String?
    /// Идентификатор пользоваля
    let user_id: String?
}

struct Schedule : APIModel {
    let id: String?
    let tourId: String?
    /// Время события
    let ts: Int?
    /// Клиент, сделавший бронь
    let ownerUserId: Int?
}

struct Guide : APIModel {
    ///
    let ownerUserId: Int?
    ///
    let name: String?
    ///
    let id: String?
    ///
    let category: String?
    ///
    let country: String?
    ///
    let tags: String?
    ///
    let city: String?
    ///
    let description: String?
    ///
    let updatedTs: Float?
    ///
    let createdTs: Float?
    ///
    let published: Bool?
}

struct Room_rename : APIModel {
    /// Идентификатор комнаты
    let room_id: String?
    /// Новое название комнаты
    let room_name: String?
    /// Идентификатор пользоваля
    let user_id: String?
    /// Предыдущее название комнаты
    let room_name_old: String?
}

struct Room_create : APIModel {
    /// Линк на аватарку
    let image: String?
    /// Идентификатор пользоваля владельца
    let owner: String?
    /// Идентификатор комнаты
    let room_id: String?
    /// Массив участников
    let users: String?
    /// Идентификатор запроса
    let request_id: String?
    /// Новое название комнаты
    let room_name: String?
}

struct MessageHistoryList : APIModel {
    /// Есть ли ещё сообщения в этой комнате
    let hasMore: Bool?
}

struct On_joined : APIModel {
    /// Идентификатор пользоваля
    let username: String?
    /// Количество сейчас онлайн
    let numUsers: Int?
}

struct RecentStatus : APIModel {
    /// Строка статус
    let last_time_string: String?
    /// Timestamp последнего подключения
    let last_join_timestamp: Int?
    /// Прошло секунд с последнего подключния
    let seconds: Int?
    /// В сети или нет
    let is_online: Bool?
}

struct Room_preview_full : APIModel {
    /// последнее сообщение в группе
    let last_message: String?
    /// Идентификатор комнаты
    let room_id: String?
    /// имя комнаты
    let name: String?
    /// 5 последних сообщений в группе
    let last_messages: String?
    /// аватарка комнаты
    let image: String?
    /// количество непрочитнных сообщений
    let unread: Int?
    /// Тип комнаты
    let type: String?
}

struct Attach_room : APIModel {
    /// Идентификатор комнаты
    let room_id: String?
    /// Идентификатор пользоваля
    let user_id: String?
    /// Идентификатор пользоваля - владельца(создателя)
    let owner: String?
}

struct UserAuth : APIModel {
    /// Путь до аватарки
    let logoPath: String?
    let gender: String?
    /// E-Mail
    let email: String?
    /// Токен для доступа
    let token: String?
    /// Имя собственное
    let firstName: String?
    let birthdate: String?
    let specialization: String?
    /// Фамилиля
    let lastName: String?
    let description: String?
    /// Идентификатор пользователя
    let id: Int?
    let city: String?
    /// Телефон
    let phone: String?
}

struct User : APIModel {
    /// Имя собственное
    let firstName: String?
    /// Телефон
    let phone: String?
    let specialization: String?
    let birthdate: String?
    /// Путь до аватарки
    let logoPath: String?
    let description: String?
    /// Идентификатор пользователя
    let id: Int?
    /// E-Mail
    let email: String?
    /// Фамилиля
    let lastName: String?
    let city: String?
    let gender: String?
}

struct Delete_message : APIModel {
    /// Идентификатор сообщений
    let message_id: String?
    /// Идентификатор пользоваля, автор сообщения
    let user_id: String?
    /// Идентификатор комнаты
    let room_id: String?
}

struct Image : APIModel {
    let name: String?
    let path: String?
    let description: String?
}

struct Guide_places : APIModel {
    ///
    let description: String?
    ///
    let geoPosition: String?
    ///
    let name: String?
    ///
    let address: String?
}

struct UserOnline : APIModel {
    /// Путь до аватарки
    let logoPath: String?
    let specialization: String?
    /// Фамилиля
    let lastName: String?
    ///
    let status: String?
    /// Имя собственное
    let firstName: String?
    /// Идентификатор пользователя
    let id: String?
    let description: String?
    let birthdate: String?
    let gender: String?
    let city: String?
    /// Телефон
    let phone: String?
    /// E-Mail
    let email: String?
}

struct TourFull : APIModel {
    ///
    let transfer: String?
    ///
    let id: String?
    ///
    let language: String?
    ///
    let country: String?
    ///
    let city: String?
    ///
    let updatedTs: Float?
    ///
    let name: String?
    ///
    let tags: String?
    ///
    let description: String?
    ///
    let ownerUserId: Int?
    ///
    let specialization: String?
    ///
    let createdTs: Float?
    ///
    let published: Bool?
}

struct Room_preview : APIModel {
    /// 5 последних сообщение в группе
    let last_messages: String?
    /// Масссив участников
    let users: [String]?
    /// Идентификатор комнаты
    let room_id: String?
    /// Тип комнаты
    let type: String?
    /// последнее сообщение в группе
    let last_message: String?
    /// количество непрочитнных сообщений
    let unread: Int?
    /// имя комнаты
    let room_name: String?
}

struct Booking : APIModel {
    /// Клиент, сделавший бронь
    let ownerUserId: Int?
    let tourId: String?
    let status: String?
    let id: String?
    let scheduleId: String?
    let createdTs: Int?
    /// Время события(продублировано из объекта Schedule)
    let ts: Int?
    /// Экскурсовод
    let GuideUserId: Int?
}

struct Comment : APIModel {
    let timestamp: String?
    let rating: Float?
    let tourId: String?
    let id: String?
    let message: String?
    let guideId: String?
}

struct Attachment : APIModel {
    /// Ссылка на объект 'message'
    let message: String?
    ///
    let thumbnail: String?
    ///
    let uuid: String?
    ///
    let type: String?
    ///
    let url: String?
}

/// Загрузить все недоставленные мне сообщения из комнаты. (Фильтр по статусу)
struct ApiV1RoomRoom_idUndeliveredGetRequest : APIRequest {
    typealias ResponseType = [Message]
    typealias ErrorType = EmptyResponse
    var urlPath: String { return "/api/v1/room/\(room_id)/undelivered" }
    var method: HTTPMethod { return .get }
    /// Идентификатор комнаты
    let room_id: String
    /// Auth token
    let token: String
    /// Идентификатор пользователя. Используется, если token пустой
    let userId: Int?
}
