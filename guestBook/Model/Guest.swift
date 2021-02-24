//
//  Guest.swift
//  guestBook
//
//  Created by 杉崎圭 on 2020/11/11.
//

import FirebaseFirestore
import PencilKit
import FirebaseStorage
import Alamofire

fileprivate let storage = Storage.storage().reference(forURL: Keys.firestoreStorageUrl)
let apiQueueGroup = DispatchGroup()
//let apiQueue  = DispatchQueue(label: "queue", attributes: .concurrent)
let apiQueue  = DispatchQueue.global(qos: .userInitiated)

struct Guest {
    var id: String
    let eventId: String
    var guestName: String
    var guestNameImage: PKDrawing
    var guestNameImageData: Data
    var companyName: String
    var companyNameImageData: Data
    var retuals: Dictionary<String, Bool> = [:]
    var zipCode: String
    var zipCodeImageData: Data
    var address: String
    var addressImageData: Data
    var telNumber: String
    var telNumberImageData: Data
    var relations: Array<Bool>
    var groups: Array<Bool>
    var description: String
    var descriptionImageData: Data
    var pageNumber: Int
    let createdAt: Date
    var updatedAt: Date
    
    // MARK:-
    
    init(document: QueryDocumentSnapshot) {
        let dictionary            = document.data()
        self.id                   = document.documentID
        self.eventId              = dictionary["eventId"]     as? String ?? ""
        self.guestName            = dictionary["guestName"]   as? String ?? ""
        self.guestNameImage       = PKDrawing()
        self.guestNameImageData   = dictionary["guestNameImageData"] as? Data ?? Data()
        self.companyName          = dictionary["companyName"] as? String ?? ""
        self.companyNameImageData = dictionary["companyNameImageData"] as? Data ?? Data()
        self.retuals              = dictionary["retuals"]     as? Dictionary<String, Bool> ?? [:]
        self.zipCode              = dictionary["zipCode"]     as? String ?? ""
        self.zipCodeImageData     = dictionary["zipCodeImageData"] as? Data ?? Data()
        self.address              = dictionary["address"]     as? String ?? ""
        self.addressImageData     = dictionary["addressImageData"] as? Data ?? Data()
        self.telNumber            = dictionary["telNumber"]   as? String ?? ""
        self.telNumberImageData   = dictionary["telNumberImageData"] as? Data ?? Data()
        self.relations            = dictionary["rerlations"]  as? Array  ?? [false, false, false, false]
        self.groups               = dictionary["rerlations"]  as? Array  ?? [false, false, false, false, false, false, false, false, false]
        self.description          = dictionary["description"] as? String ?? ""
        self.descriptionImageData = dictionary["descriptionImageData"] as? Data ?? Data()
        self.pageNumber           = 0
        self.createdAt            = dictionary["createdAt"]   as? Date   ?? Date()
        self.updatedAt            = dictionary["updatedAt"]   as? Date   ?? Date()
    }
    
    init(_ id: String,_ retualList: [Retual]) {
        self.id                   = id
        self.eventId              = ""
        self.guestName            = ""
        self.guestNameImage       = PKDrawing()
        self.guestNameImageData   = Data()
        self.companyName          = ""
        self.companyNameImageData = Data()
        self.zipCode              = ""
        self.zipCodeImageData     = Data()
        self.address              = ""
        self.addressImageData     = Data()
        self.telNumber            = ""
        self.telNumberImageData   = Data()
        self.relations            = [false, false, false, false]
        self.groups               = [false, false, false, false, false, false, false, false, false]
        self.description          = ""
        self.descriptionImageData = Data()
        self.pageNumber           = 0
        self.createdAt            = Date()
        self.updatedAt            = Date()
        
        self.retuals     = setDefaultAttendance(retualList: retualList)        
    }
    
    static func registGuest(_ guest: Guest, _ eventId: String, _ analizedText: Dictionary<String, String>) -> DocumentReference {
        let documentRef = Guest.collectionRef(eventId).addDocument(data: [
            "guestName"            : guest.guestName,
            "guestNameImageData"   : guest.guestNameImageData,
            "companyName"          : guest.companyName,
            "companyNameImageData" : guest.companyNameImageData,
            "retuals"              : guest.retuals,
            "zipCode"              : guest.zipCode,
            "zipCodeImageData"     : guest.zipCodeImageData,
            "address"              : guest.address,
            "addressImageData"     : guest.addressImageData,
            "telNumber"            : guest.telNumber,
            "telNumberImageData"   : guest.telNumberImageData,
            "relations"            : guest.relations,
            "groups"               : guest.groups,
            "description"          : guest.description,
            "descriptionImageData" : guest.descriptionImageData,
            "eventId"              : eventId,
            "createdAt"            : Date(),
            "updatedAt"            : Date(),
        ])
        return documentRef
    }
    
    static func updateGuest(_ guest: Guest, _ eventId: String, _ analizedText: Dictionary<String, String>) {
        Guest.collectionRef(eventId).document(guest.id).updateData([
            "guestName"            : analizedText["guestName"] ?? "",
            "guestNameImageData"   : guest.guestNameImageData,
            "companyName"          : guest.companyName,
            "companyNameImageData" : guest.companyNameImageData,
            "retuals"              : guest.retuals,
            "zipCode"              : guest.zipCode,
            "zipCodeImageData"     : guest.zipCodeImageData,
            "address"              : guest.address,
            "addressImageData"     : guest.addressImageData,
            "telNumber"            : guest.telNumber,
            "telNumberImageData"   : guest.telNumberImageData,
            "relations"            : guest.relations,
            "groups"               : guest.groups,
            "description"          : guest.description,
            "descriptionImageData" : guest.descriptionImageData,
            "updatedAt"            : Date(),
        ])
    }
    
    static func collectionRef(_ eventId: String) ->CollectionReference {
        return Firestore.firestore().collection("events").document(eventId).collection("guests")
    }
    
    // 儀式の参列をデフォルト不参加にセット。デフォルトのretualsListの配列をDictionary型に変換して返す。
    func setDefaultAttendance(retualList: [Retual]) -> Dictionary<String, Bool> {
        return retualList.reduce(into: [String: Bool]()) { $0[$1.id] = false }
    }
    
    // 検索
    
    
    // MARK:- 手書き文字解析
    static func analizeText(guest: Guest, completion: @escaping (Dictionary<String,String>) -> Void) -> Void {
        let tasks: Array = ["GuestName", "CompanyName", "Address", "ZipCode", "TelNumber"]
        var apiResult: Dictionary<String, String> = [:]
        
        for task in tasks {
            switch task {
            case "GuestName":
                if guest.guestNameImageData != Data() {
                    apiQueueGroup.enter()
                    // processIdentifireを作成
                    let processIdentifire = "guestName\(guest.id)"
                    // CloudVisionAPIで手書き文字解析
                    let imageData: String = makeGuestNameImageData(guest)
                    // 手書き文字解析
                    callGoogleVisionApi(imageData, processIdentifire, completion: { (result) in
                        apiQueue.async(group: apiQueueGroup) {
                            // 改行コードを取り除く
                            let text = result.trimmingCharacters(in: .whitespacesAndNewlines)
                            apiResult["guestName"] = text
                            print("御芳名：\(text)")
                            apiQueueGroup.leave()
                        }
                    })
                }
                break
            //            case "CompanyName":
            //                if guest.guestNameImageData != Data() {
            //                    // processIdentifireを作成
            //                    let processIdentifire = "companyName\(guest.id)"
            //                    // CloudVisionAPIで手書き文字解析
            //                    let imageData: String = makeGuestNameImageData(guest)
            //                    // 手書き文字解析
            //                    apiQueue.async(group: apiQueueGroup) {
            //                        callGoogleVisionApi(imageData, processIdentifire, completion: { (result) in
            //                            apiResult["CompanyName"] = result
            //                            print("会社名：\(result)")
            //                            apiQueueGroup.leave()
            //                        })
            //                    }
            //
            //                }
            //                break
            //            case "Address":
            //                if guest.guestNameImageData != Data() {
            //                    // processIdentifireを作成
            //                    let processIdentifire = "address\(guest.id)"
            //                    // CloudVisionAPIで手書き文字解析
            //                    let imageData: String = makeGuestNameImageData(guest)
            //                    // 手書き文字解析
            //                    guest.guestName = callGoogleVisionApi(imageData, processIdentifire)
            //                }
            //                break
            //            case "ZipCode":
            //                if guest.guestNameImageData != Data() {
            //                    // processIdentifireを作成
            //                    let processIdentifire = "zipCode\(guest.id)"
            //                    // CloudVisionAPIで手書き文字解析
            //                    let imageData: String = makeGuestNameImageData(guest)
            //                    // 手書き文字解析
            //                    guest.guestName = callGoogleVisionApi(imageData, processIdentifire)
            //                }
            //                break
            //            case "TelNumber":
            //                if guest.guestNameImageData != Data() {
            //                    // processIdentifireを作成
            //                    let processIdentifire = "telNumber\(guest.id)"
            //                    // CloudVisionAPIで手書き文字解析
            //                    let imageData: String = makeGuestNameImageData(guest)
            //                    // 手書き文字解析
            //                    guest.guestName = callGoogleVisionApi(imageData, processIdentifire)
            //                }
            //                break
            default:
                break
            }
        }
        
        // 全ての非同期処理完了後にメインスレッドで処理
        apiQueueGroup.notify(queue: .main) {
            print("Guestモデルのデータ\(apiResult)")
            completion(apiResult)
        }
    }
    
    static func makeGuestNameImageData(_ guest: Guest) -> String {
        let canvas: PKCanvasView = PKCanvasView(frame: .zero)
        canvas.setDrawingData(canvas, guest.guestNameImageData)
        let image = canvas.drawing.image(from: CGRect(x: 0, y: 0, width: guestCardView.guestNameWidth, height: guestCardView.guestNameHeight), scale: 1.0)
        let binaryImageData = image.pngData()!.base64EncodedString(options: .endLineWithCarriageReturn)
        return binaryImageData
    }
    
    static func callGoogleVisionApi(_ imgeData: String, _ processIdentifire: String, completion: @escaping(String) -> Void) {
        
        let apiURL = "https://vision.googleapis.com/v1/images:annotate?key=\(Keys.googleVisionAPIKey)"
        let parameters: Parameters = [
            "requests": [
                "image": [
                    "content": imgeData
                ],
                "features": [
                    "type": "TEXT_DETECTION",
                    "maxResults": 1
                ],
                "imageContext": [
                    "languageHints": [
                        "ja-t-i0-handwrit"
                    ]
                ]
            ]
        ]
        var resultText: String = ""
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Ios-Bundle-Identifier": Bundle.main.bundleIdentifier ?? "",
            "Process-Identifire": processIdentifire]
        AF.request(
            apiURL,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers)
            .responseJSON() { response in
                // JSONデコード
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                do {
                    let decoded: CloudVisionApiResponse = try decoder.decode(CloudVisionApiResponse.self, from: response.data ?? Data())
                    // レスポンスが該当のリクエストに対するものか確認
                    if let requestHeaders = response.request?.headers {
                        for header in requestHeaders {
                            if header.name == "Process-Identifire" {
                                if header.value == processIdentifire {
                                    resultText = decoded.responses[0].fullTextAnnotation.text
                                }
                            }
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
                completion(resultText)
                print("\(processIdentifire)：タスク終わりました")
            }
    }
}

// MARK:- CloudVisionApiレスポンス解析
struct CloudVisionApiResponse: Codable {
    var responses: [Response]
    struct Response: Codable {
        var textAnnotations: [TextAnnotations]
        var fullTextAnnotation: FullTextAnnotation
        struct TextAnnotations: Codable {
            var description: String
        }
        struct FullTextAnnotation: Codable {
            var text: String
        }
    }
}

// MARK:- Extensions
// 入力されているかどうかチェック
extension Guest: Equatable {
    static func == (lhs: Guest, rhs: Guest) -> Bool {
        return lhs.id                   == rhs.id
            && lhs.guestName            == rhs.guestName
            && lhs.guestNameImageData   == rhs.guestNameImageData
            && lhs.companyName          == rhs.companyName
            && lhs.companyNameImageData == rhs.companyNameImageData
            && lhs.retuals              == rhs.retuals
            && lhs.zipCode              == rhs.zipCode
            && lhs.zipCodeImageData     == rhs.zipCodeImageData
            && lhs.address              == rhs.address
            && lhs.addressImageData     == rhs.addressImageData
            && lhs.telNumber            == rhs.telNumber
            && lhs.telNumberImageData   == rhs.telNumberImageData
            && lhs.relations            == rhs.relations
            && lhs.description          == rhs.description
            && lhs.descriptionImageData == rhs.descriptionImageData
    }
}


