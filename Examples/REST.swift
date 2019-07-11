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
	func urlPath() -> String { return "/api/v1/room/\(room_id)/undelivered" }
	func method() -> HTTPMethod { return .get }
	/// Идентификатор комнаты
	let room_id: String
	/// Auth token
	let token: String
	/// Идентификатор пользователя. Используется, если token пустой
	let userId: Int?
}

/// Показать список моих экскурсий
struct ApiV2TourListGetRequest : APIRequest {
	typealias ResponseType = [Tour]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/tour/list" }
	func method() -> HTTPMethod { return .get }
}

/// Удалить место из гайда
struct ApiV2GuidePointDeletePostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/guide/point/delete" }
	func method() -> HTTPMethod { return .post }
	let guideId: String?
	let name: String?
}

/// Загрузить все новые сообщения из комнаты. (Фильтра по времени)
struct ApiV2RoomRoom_idNew_messagesGetRequest : APIRequest {
	typealias ResponseType = [Message]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/room/\(room_id)/new_messages" }
	func method() -> HTTPMethod { return .get }
	/// Идентификатор комнаты
	let room_id: String
	/// Auth token
	let token: String
	/// Идентификатор пользователя. Используется, если token пустой
	let userId: Int?
	/// Timestamp
	let ts: Int?
	/// Лимит количества новых сообщений
	let limit: Int?
}

/// Загрузить все сообщения c картинками из комнаты
struct ApiV2RoomRoom_idImagesGetRequest : APIRequest {
	typealias ResponseType = [Message]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/room/\(room_id)/images" }
	func method() -> HTTPMethod { return .get }
	/// Идентификатор комнаты
	let room_id: String
	/// Auth token
	let token: String
	/// Идентификатор пользователя. Используется, если token пустой
	let userId: Int?
}

/// Загрузить все комнаты пользователя с preview(количество непрочитанных сообщений и последнее), со списком объектов пользователь
struct ApiV1UserUser_idRoomsFullGetRequest : APIRequest {
	typealias ResponseType = [Room_preview_full]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v1/user/\(user_id)/roomsFull" }
	func method() -> HTTPMethod { return .get }
	/// Идентификатор пользователя
	let user_id: String
}

/// Создать новую комнату
struct ApiV1RoomCreateRoom_idPutRequest : APIRequest {
	typealias ResponseType = Room_create
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v1/roomCreate/\(room_id)" }
	func method() -> HTTPMethod { return .put }
	/// Идентификатор группы
	let room_id: String
	/// Auth token
	let token: String
	/// Идентификатор пользователя. Используется, если token пустой
	let userId: Int?
	/// Имя комнаты
	let room_name: String?
	/// Линк на аватарку комнаты
	let image: String?
	/// Не используется
	let is_attach: Bool?
	/// Тип комнаты(privateRoom|group)
	let type: String?
	/// Список участников
	let userList: String?
}

/// Обновить гид
struct ApiV2GuideUpdatePostRequest : APIRequest {
	typealias ResponseType = Guide
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/guide/update" }
	func method() -> HTTPMethod { return .post }
	let id: String
	let name: String?
	let description: String?
	let tags: String?
	let price: Float?
	let city: String?
	let country: String?
	let category: String?
	/// Locations list
	let places: String?
	let published: Bool?
}

/// Удалили из группы/комнаты
struct SocketDeattach_roomGetRequest : APIRequest {
	typealias ResponseType = Attach_room
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/deattach_room" }
	func method() -> HTTPMethod { return .get }
}

/// Ответ на посылку сообзения. Приходит только автору
struct SocketMessage_sentGetRequest : APIRequest {
	typealias ResponseType = Message
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/message_sent" }
	func method() -> HTTPMethod { return .get }
}

/// Загрузить список идентификаторов забаненых комнат
struct ApiV2RoomsBanGetRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/rooms/ban" }
	func method() -> HTTPMethod { return .get }
	/// Auth token
	let token: String
	/// Идентификатор пользователя. Используется, если token пустой
	let userId: Int?
}

/// Посмотреть детали гида
struct ApiV2GuideGetGetRequest : APIRequest {
	typealias ResponseType = Guide
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/guide/get" }
	func method() -> HTTPMethod { return .get }
	let guideId: String?
}

/// Удалили сообщение
struct SocketDelete_messageGetRequest : APIRequest {
	typealias ResponseType = Delete_message
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/delete_message" }
	func method() -> HTTPMethod { return .get }
}

/// Удалить сообщение
struct SocketDelete_messagePostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/delete_message" }
	func method() -> HTTPMethod { return .post }
	/// Идентификатор сообщения
	let message_id: String
	/// Список идентификаторов сообщений
	let message_id_list: String
	/// Удалить для всех(а не только для себя)
	let all: Bool?
}

/// Отправка сообщения пользователю или в комнату
struct V2MessageSendPostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/v2/message/send" }
	func method() -> HTTPMethod { return .post }
	/// Идентификатор запроса
	let request_id: String
	/// Идентификатор сообщения
	let message_id: String?
	/// Идентификатор комнаты
	let room_id: String
	/// Массив Идентификаторов комнат
	let room_id_list: String
	/// Текст сообщения
	let message: String
	/// Идентификатор пользоваля, получатель сообщения
	let user_id: String
	/// Массив идентификаторов пользоваля, получателей сообщения
	let user_id_list: String
	/// Тип сообщения (text, audio, image, video, file, url)
	let type: String
	/// thumbnail
	let thumbnail: String?
	/// image
	let image: String?
	/// JSon объект. Массив прикрепленных объектов
	let attachments: String?
}

/// Забронировать экскурсию
struct ApiV2BookingCreatePostRequest : APIRequest {
	typealias ResponseType = Booking
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/booking/create" }
	func method() -> HTTPMethod { return .post }
	let tourId: String?
	let scheduleId: String?
}

/// Создать расписание
struct ApiV2ScheduleCreatePostRequest : APIRequest {
	typealias ResponseType = Schedule
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/schedule/create" }
	func method() -> HTTPMethod { return .post }
	let tourId: String?
	let timestamp: Float?
}

/// Показать список понравившихся туров
struct ApiV2FavoritetourListGetRequest : APIRequest {
	typealias ResponseType = [Favorite]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/favoritetour/list" }
	func method() -> HTTPMethod { return .get }
}

/// Загрузить часть сообщений из комнаты. Если date пустая(=0), считается что это первый запрос и сервер возвращает limit последних сообщений в комнате + признак есть ли ещё. Для следующего куска, клиент берет самый старый created timestamp среди полученных сообщений и шлет его в качестве date. Сервер пришлёт следующий кусок из limit сообщений, у которых created timestamp будет меньше указанного
struct ApiV2RoomRoom_idMessagesGetRequest : APIRequest {
	typealias ResponseType = MessageHistoryList
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/room/\(room_id)/messages" }
	func method() -> HTTPMethod { return .get }
	/// Идентификатор комнаты
	let room_id: String
	/// Auth token
	let token: String
	/// Идентификатор пользователя. Используется, если token пустой
	let userId: Int?
	/// Количество сообщений
	let limit: Int?
	/// Дата в миллисекундах
	let date: Int?
}

/// Удалить картинку из экскурсии
struct ApiV2TourImageDeletePostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/tour/image/delete" }
	func method() -> HTTPMethod { return .post }
	let tourId: String?
	let name: String?
}

/// Разрегистрироваться для отказа от push нотификаций
struct ApiV1AppUnregisterGetRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v1/app/unregister" }
	func method() -> HTTPMethod { return .get }
	/// Токен
	let token: String
}

/// Создать повторяющееся расписание
struct ApiV2ScheduleRangePostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/schedule/range" }
	func method() -> HTTPMethod { return .post }
	let tourId: String?
	/// начало периода, timestamp без времени, только дата
	let start: Float?
	/// конец периода, timestamp без времени, только дата
	let end: Float?
	/// время в течении дня в часах (number)
	let timeOfTheDay: Float?
	/// Номера дней недели через запятую
	let daysOfTheWeek: String?
}

/// Посмотреть мои гайды
struct ApiV2GuideListGetRequest : APIRequest {
	typealias ResponseType = [Guide]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/guide/list" }
	func method() -> HTTPMethod { return .get }
	let guideId: String?
}

/// Покинуть комнату
struct ApiV2RoomRoom_idLeavePostRequest : APIRequest {
	typealias ResponseType = Room_create
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/room/\(room_id)/leave" }
	func method() -> HTTPMethod { return .post }
	/// Идентификатор комнаты
	let room_id: String
	/// Идентификатор пользователя. Используется, если token пустой
	let userId: Int?
	/// Auth token
	let token: String
}

/// Пользователь удален из группы
struct SocketRemove_userGetRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/remove_user" }
	func method() -> HTTPMethod { return .get }
}

/// Поменять статус сообщений в комнате по таймстампу
struct ApiV2RoomRoom_idMessageStatusPostRequest : APIRequest {
	typealias ResponseType = Message
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/room/\(room_id)/messageStatus" }
	func method() -> HTTPMethod { return .post }
	/// Идентификатор комнаты
	let room_id: String
	/// Новый статус
	let status: String
	/// таймстамп
	let timestamp: Int
}

/// Найти гайд
struct ApiV2GuideSearchGetRequest : APIRequest {
	typealias ResponseType = [Guide]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/guide/search" }
	func method() -> HTTPMethod { return .get }
	let pattern: String?
	let city: String?
	let category: String?
}

/// Показать список комментариев для гайда с пагинацией, отсортированных от самых новых к старым
struct ApiV2GuideCommentListGetRequest : APIRequest {
	typealias ResponseType = [Comment]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/guide/comment/list" }
	func method() -> HTTPMethod { return .get }
	let guideId: String?
	/// С какой даты загружать(timestamp в милисекундах). По умолчанию - now
	let start: Float?
	/// Лимит сообщений. По умолчанию - 5
	let limit: Float?
}

/// Создать комментарий к гайду
struct ApiV2GuideCommentPostRequest : APIRequest {
	typealias ResponseType = Comment
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/guide/comment" }
	func method() -> HTTPMethod { return .post }
	let message: String?
	let rating: String?
	let guideId: String?
}

/// Показать список моих экскурсий(где я экскурсовод)
struct ApiV2BookingListGuideGetRequest : APIRequest {
	typealias ResponseType = [Booking]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/booking/list/guide" }
	func method() -> HTTPMethod { return .get }
}

/// Кто и когда был онлайн
struct ApiV1UserGetLastOnlineGetRequest : APIRequest {
	typealias ResponseType = RecentStatus
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v1/user/getLastOnline" }
	func method() -> HTTPMethod { return .get }
	/// ID пользователя, который нас интересует
	let userId: String
}

/// Показать детали экскурсии
struct ApiV2TourGetGetRequest : APIRequest {
	typealias ResponseType = TourFull
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/tour/get" }
	func method() -> HTTPMethod { return .get }
	let tourId: String
}

/// Популярные гайды
struct ApiV2GuidePopularGetRequest : APIRequest {
	typealias ResponseType = [Guide]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/guide/popular" }
	func method() -> HTTPMethod { return .get }
	let city: String
	let limit: Float
}

/// Проверяет у его есть токен для пушей
struct ApiV1AppCheckGetRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v1/app/check" }
	func method() -> HTTPMethod { return .get }
	/// Список id пользователей
	let users: String
}

/// Список всех комнат с количеством непрочитанных сообщений и последнимм сообщением. Приходит коиенту на логине
struct SocketRoomsGetRequest : APIRequest {
	typealias ResponseType = [Room_preview]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/rooms" }
	func method() -> HTTPMethod { return .get }
}

/// Создать экскурсию
struct ApiV2TourCreatePostRequest : APIRequest {
	typealias ResponseType = Tour
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/tour/create" }
	func method() -> HTTPMethod { return .post }
	let name: String?
	let description: String?
	let tags: String?
	let price: Float?
	let duration: Float?
	let startHour: Float?
	let maxPeople: Int?
	let specialization: String?
	let language: String?
	let transfer: String?
	let city: String?
	let country: String?
	let published: Bool?
}

/// Найти экскурсию
struct ApiV2TourSearchGetRequest : APIRequest {
	typealias ResponseType = [Tour]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/tour/search" }
	func method() -> HTTPMethod { return .get }
	let pattern: String
	let city: String
	let isGroup: Bool
	let startDate: Float
	let endDate: Float
}

/// Добавить картинку к экскурсии
struct ApiV2TourImageAddPostRequest : APIRequest {
	typealias ResponseType = Image
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/tour/image/add" }
	func method() -> HTTPMethod { return .post }
	let tourId: String?
	let name: String?
	let description: String?
	let path: String?
}

/// Событие на входящее сообщение
struct SocketOn_messageGetRequest : APIRequest {
	typealias ResponseType = Message
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/on_message" }
	func method() -> HTTPMethod { return .get }
}

/// Отправка сообщения пользователю или в комнату
struct SocketOn_messagePostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/on_message" }
	func method() -> HTTPMethod { return .post }
	/// Идентификатор запроса
	let request_id: String
	/// Идентификатор сообщения
	let message_id: String?
	/// Идентификатор комнаты
	let room_id: String
	/// Массив Идентификаторов комнат
	let room_id_list: String
	/// Текст сообщения
	let message: String
	/// Идентификатор пользоваля, получатель сообщения
	let user_id: String
	/// Массив идентификаторов пользоваля, получателей сообщения
	let user_id_list: String
	/// Тип сообщения (text, audio, image, video, file, url)
	let type: String
	/// thumbnail
	let thumbnail: String?
	/// image
	let image: String?
	/// JSon объект. Массив прикрепленных объектов
	let attachments: String?
}

/// Запросить список пользователей по id
struct ApiV2UserListGetRequest : APIRequest {
	typealias ResponseType = [UserOnline]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/userList" }
	func method() -> HTTPMethod { return .get }
	/// Список id пользователей через запятую
	let userList: String
}

/// Показать список пройденных мной экскурсий, которые надо оценить
struct ApiV2TourListRateGetRequest : APIRequest {
	typealias ResponseType = [Tour]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/tour/list/rate" }
	func method() -> HTTPMethod { return .get }
}

/// Удалить тур из понравившихся
struct ApiV2FavoritetourDeletePostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/favoritetour/delete" }
	func method() -> HTTPMethod { return .post }
	let tourId: String?
}


/// Добавить новые контакты в Addressbook
struct ApiV2UserUser_idAddressbookPostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/user/\(user_id)/addressbook" }
	func method() -> HTTPMethod { return .post }
	/// Идентификатор пользователя
	let user_id: String
}

/// Показать список комментариев для тура
struct ApiV2TourCommentListGetRequest : APIRequest {
	typealias ResponseType = [Comment]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/tour/comment/list" }
	func method() -> HTTPMethod { return .get }
	let tourId: String?
}

/// Удалить все данные о группе, включая сообщения.
struct ApiV1RoomRoom_idResetGetRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v1/room/\(room_id)/reset" }
	func method() -> HTTPMethod { return .get }
	/// Идентификатор группы
	let room_id: String
}

/// Послать push с сообщением
struct ApiInternalPushSendPostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/internal/push/send" }
	func method() -> HTTPMethod { return .post }
	/// Список телефонов получателей через запятую
	let phones: String?
	/// Список id получателей через запятую
	let users: String?
	/// Сообщение
	let message: String
}

/// Зарегистрироваться для получения push нотификаций.
struct ApiV1AppRegisterGetRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v1/app/register" }
	func method() -> HTTPMethod { return .get }
	/// Идентификатор пользователя
	let owner: String
	/// Тип мобильника
	let platform: String
	/// push token
	let token: String
	/// hwid
	let hwid: String
	/// is_dev
	let is_dev: String
}

/// Загрузить все комнаты пользователя с preview(количество непрочитанных сообщений и последнее)
struct ApiV1UserUser_idRoomsGetRequest : APIRequest {
	typealias ResponseType = [Room_preview]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v1/user/\(user_id)/rooms" }
	func method() -> HTTPMethod { return .get }
	/// Идентификатор пользователя
	let user_id: String
}

/// Создана группа/комната
struct SocketAttach_roomGetRequest : APIRequest {
	typealias ResponseType = Attach_room
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/attach_room" }
	func method() -> HTTPMethod { return .get }
}

/// Разблокировать комнату
struct ApiV2RoomsRoomIdUnbanGetRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/rooms/\(roomId)/unban" }
	func method() -> HTTPMethod { return .get }
	/// Auth token
	let token: String
	/// Идентификатор пользователя. Используется, если token пустой
	let userId: Int?
	/// Идентификатор комнаты
	let roomId: String
}

/// Добавить тур в понравившиеся
struct ApiV2FavoritetourCreatePostRequest : APIRequest {
	typealias ResponseType = Favorite
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/favoritetour/create" }
	func method() -> HTTPMethod { return .post }
	let tourId: String?
}

/// Пользователь добавлен в группу
struct SocketAdd_userGetRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/add_user" }
	func method() -> HTTPMethod { return .get }
}

/// Заблокировать комнату
struct ApiV2RoomsRoomIdBanGetRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/rooms/\(roomId)/ban" }
	func method() -> HTTPMethod { return .get }
	/// Auth token
	let token: String
	/// Идентификатор пользователя. Используется, если token пустой
	let userId: Int?
	/// Идентификатор комнаты
	let roomId: String
}

/// Загрузить все комнаты пользователя с preview(количество непрочитанных сообщений и последнее) из кэша
struct ApiV1UserUser_idRoomsCacheGetRequest : APIRequest {
	typealias ResponseType = [Room_preview]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v1/user/\(user_id)/roomsCache" }
	func method() -> HTTPMethod { return .get }
	/// Идентификатор пользователя
	let user_id: String
}

/// Поменять комнату
struct ApiV2RoomRoom_idPostRequest : APIRequest {
	typealias ResponseType = Room_create
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/room/\(room_id)" }
	func method() -> HTTPMethod { return .post }
	/// Идентификатор комнаты
	let room_id: String
	/// New name
	let name: String?
	/// Список пользователей
	let userList: String?
	/// Линк на аватарку комнаты
	let image: String?
}

/// Расписание всех моих туров(как гида)
struct ApiV2ScheduleListMyGetRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/schedule/list/my" }
	func method() -> HTTPMethod { return .get }
	/// начало периода
	let start: Float?
	/// конец периода
	let end: Float?
}

/// Пометить сообщения как прочитанные по идентификаторам
struct SocketMessage_statusPostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/message_status" }
	func method() -> HTTPMethod { return .post }
	/// Новый статус (delivered|read)
	let status: String
	/// Массив идентификаторов сообщений
	let messages: String
}

/// Удалить диалог со своей стороны
struct ApiV1RoomRoom_idDeleteRequest : APIRequest {
	typealias ResponseType = Room_rename
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v1/room/\(room_id)" }
	func method() -> HTTPMethod { return .delete }
	/// Идентификатор группы
	let room_id: String
	/// Auth token
	let token: String
	/// Идентификатор пользователя. Используется, если token пустой
	let userId: Int?
}

/// Добавить место к гайду
struct ApiV2GuidePointAddPostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/guide/point/add" }
	func method() -> HTTPMethod { return .post }
	let guideId: String?
	let name: String?
	let description: String?
	let address: String?
	let geoPosition: String?
}

/// Удалить 1 элемент расписания
struct ApiV2ScheduleDeletePostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/schedule/delete" }
	func method() -> HTTPMethod { return .post }
	let id: String?
}

/// Событие срабатывает, если один из пользователей вышел в сеть
struct SocketOn_joinedGetRequest : APIRequest {
	typealias ResponseType = On_joined
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/on_joined" }
	func method() -> HTTPMethod { return .get }
}

/// Показать список забронированных мной экскурсий
struct ApiV2BookingListMyGetRequest : APIRequest {
	typealias ResponseType = [Booking]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/booking/list/my" }
	func method() -> HTTPMethod { return .get }
}

/// Обновить информацию об экскурсии
struct ApiV2TourUpdatePostRequest : APIRequest {
	typealias ResponseType = Tour
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/tour/update" }
	func method() -> HTTPMethod { return .post }
	let id: String?
	let name: String?
	let description: String?
	let tags: String?
	let price: Float?
	let duration: Float?
	let startHour: Float?
	let maxPeople: Int?
	let specialization: String?
	let language: String?
	let transfer: String?
	let city: String?
	let country: String?
	let published: Bool?
}

/// Список online пользователей
struct ApiV1UserGetOnlineGetRequest : APIRequest {
	typealias ResponseType = [String]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v1/user/getOnline" }
	func method() -> HTTPMethod { return .get }
	/// Список пользователей, чей статус нас интересует(через запятую)
	let userList: String
}

/// Добавить картинку к гайду
struct ApiV2GuideImageAddPostRequest : APIRequest {
	typealias ResponseType = Image
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/guide/image/add" }
	func method() -> HTTPMethod { return .post }
	let guideId: String?
	let name: String?
	let description: String?
	let path: String?
}

/// Популярные экскурсии
struct ApiV2TourPopularGetRequest : APIRequest {
	typealias ResponseType = [Tour]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/tour/popular" }
	func method() -> HTTPMethod { return .get }
	let city: String
	let limit: Float
}

/// Создать гид
struct ApiV2GuideCreatePostRequest : APIRequest {
	typealias ResponseType = Guide
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/guide/create" }
	func method() -> HTTPMethod { return .post }
	let name: String?
	let description: String?
	let tags: String?
	let price: Float?
	let city: String?
	let country: String?
	let category: String?
	/// Locations list
	let places: String?
	let published: Bool?
}

/// Редактирование сообщения
struct SocketOn_message_updatePostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/on_message_update" }
	func method() -> HTTPMethod { return .post }
	/// Идентификатор запроса
	let request_id: String
	/// Текст сообщения
	let message: String
	/// thumbnail
	let thumbnail: String?
	/// image
	let image: String?
	/// JSon объект. Массив прикрепленных объектов
	let attachments: String?
}

/// Создать новую комнату
struct ApiV2RoomCreateRoom_idPostRequest : APIRequest {
	typealias ResponseType = Room_create
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/roomCreate/\(room_id)" }
	func method() -> HTTPMethod { return .post }
	/// Идентификатор группы
	let room_id: String
	/// Auth token
	let token: String
	/// Идентификатор пользователя. Используется, если token пустой
	let userId: Int?
	/// Имя комнаты
	let name: String?
	/// Линк на аватарку комнаты
	let image: String?
	/// Тип комнаты(privateRoom|group)
	let type: String?
	/// Список участников
	let userList: String?
}

/// Зарегистрировать нового пользователя
struct ApiV2RegisterPostRequest : APIRequest {
	typealias ResponseType = User
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/register" }
	func method() -> HTTPMethod { return .post }
	/// Телефон пользователя
	let phone: String
}

/// Обновить расписание
struct ApiV2ScheduleUpdatePostRequest : APIRequest {
	typealias ResponseType = Schedule
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/schedule/update" }
	func method() -> HTTPMethod { return .post }
	let id: String?
	let tourId: String?
	let timestamp: Float?
}

/// Загрузить сообщения
struct ApiV2MessageListGetRequest : APIRequest {
	typealias ResponseType = MessageHistoryList
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/message/list" }
	func method() -> HTTPMethod { return .get }
	/// Auth token
	let token: String
	/// Идентификатор пользователя. Используется, если token пустой
	let userId: Int?
	/// Количество сообщений
	let limit: Int?
	/// Дата в миллисекундах
	let date: Int?
}

/// Удалить экскурсию
struct ApiV2TourDeletePostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/tour/delete" }
	func method() -> HTTPMethod { return .post }
	let id: String
}

/// Удалить картинку из гайда
struct ApiV2GuideImageDeletePostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/guide/image/delete" }
	func method() -> HTTPMethod { return .post }
	let guideId: String?
	let name: String?
}

/// Расписание 1 тура
struct ApiV2ScheduleListGetRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/schedule/list" }
	func method() -> HTTPMethod { return .get }
	let tourId: String?
	/// начало периода
	let start: Float?
	/// конец периода
	let end: Float?
}

/// Обновить свои данные
struct ApiV2ProfilePostRequest : APIRequest {
	typealias ResponseType = User
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/profile" }
	func method() -> HTTPMethod { return .post }
	let id: String
	let firstName: String
	let lastName: String
	let email: String
	let logoPath: String?
	let description: String?
	let specialization: String?
	let gender: String?
	let city: String?
	let birthdate: String?
}

/// Подключение к серверу, авторизация
struct SocketOn_joinPostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/on_join" }
	func method() -> HTTPMethod { return .post }
	/// Идентификатор пользователя
	let username: String
	/// Ключ авторизации пользовтаеля в API-VoipScan
	let tokenauth: String
	/// Токен приложения
	let tokenapp: String
	/// Токен приложения
	let token: String
}

/// Загрузить все комнаты пользователя с preview(количество непрочитанных сообщений и последнее), со списком объектов пользователь
struct ApiV1UserUser_idRoomsFullCacheGetRequest : APIRequest {
	typealias ResponseType = [Room_preview_full]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v1/user/\(user_id)/roomsFullCache" }
	func method() -> HTTPMethod { return .get }
	/// Идентификатор пользователя
	let user_id: String
}

/// Событие, отображает кто сейчас набирает текст
struct SocketOn_typingGetRequest : APIRequest {
	typealias ResponseType = On_typing
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/on_typing" }
	func method() -> HTTPMethod { return .get }
}

/// Пользователь набирает текст сообщения
struct SocketOn_typingPostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/on_typing" }
	func method() -> HTTPMethod { return .post }
	/// Идентификатор комнаты
	let room_id: String
}

/// Статус сообщения поменялся
struct SocketMessage_changeGetRequest : APIRequest {
	typealias ResponseType = Message
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/message_change" }
	func method() -> HTTPMethod { return .get }
}

/// Загрузить сообщения из комнаты по фильтрам и с разбиением на страницы
struct ApiV1RoomRoom_idMessagesGetRequest : APIRequest {
	typealias ResponseType = [Message]
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v1/room/\(room_id)/messages" }
	func method() -> HTTPMethod { return .get }
	/// Идентификатор комнаты
	let room_id: String
	/// Auth token
	let token: String
	/// Идентификатор пользователя. Используется, если token пустой
	let userId: Int?
	/// Количество сообщений
	let limit: Int?
	/// Смещение по сообщениям
	let offset: Int?
	/// Статус сообщений. Не используется
	let status: String
	/// Страница
	let page: Int?
	/// Параметр c даты начала, UNIX Timestamp
	let date_start: Int?
	/// Параметр до даты окончания, UNIX Timestamp
	let date_end: Int?
}

/// Запросить пользователя
struct ApiV2UserUser_idGetRequest : APIRequest {
	typealias ResponseType = User
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/user/\(user_id)" }
	func method() -> HTTPMethod { return .get }
	/// id
	let user_id: String
}

/// Событие, остановка набора текста
struct SocketStop_typingGetRequest : APIRequest {
	typealias ResponseType = On_typing
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/stop_typing" }
	func method() -> HTTPMethod { return .get }
}

/// Пользователь перестал набирать текст сообщения
struct SocketStop_typingPostRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/socket/stop_typing" }
	func method() -> HTTPMethod { return .post }
	/// Идентификатор комнаты
	let room_id: String
}

/// Создать комментарий к туру
struct ApiV2TourCommentPostRequest : APIRequest {
	typealias ResponseType = Comment
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/tour/comment" }
	func method() -> HTTPMethod { return .post }
	let message: String?
	let rating: String?
	let tourId: String?
}

/// Удалить(покинуть) комнату для этого пользователя(собеседник продолжает видеть комнату)
struct ApiV1UserUser_idRoomsRoom_idDeleteGetRequest : APIRequest {
	typealias ResponseType = EmptyResponse
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v1/user/\(user_id)/rooms/\(room_id)/delete" }
	func method() -> HTTPMethod { return .get }
	/// Идентификатор пользователя
	let user_id: String
	/// Идентификатор группы
	let room_id: String
}

/// Авторизация
struct ApiV2LoginPostRequest : APIRequest {
	typealias ResponseType = UserAuth
	typealias ErrorType = EmptyResponse 
	func urlPath() -> String { return "/api/v2/login" }
	func method() -> HTTPMethod { return .post }
	/// Телефон пользователя
	let phone: String
	/// SMS код
	let code: String
}

