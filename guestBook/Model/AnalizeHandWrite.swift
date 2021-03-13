//
//  AnalizeHandWrite.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/02/25.
//

import PencilKit
import FirebaseFirestore
import Alamofire

let apiQueueGroup = DispatchGroup()
let apiQueue  = DispatchQueue.global(qos: .userInitiated)

class AnalizeHandWrite {
    
    // MARK:- 手書き文字解析
    static func analizeText(guest: Guest, completion: @escaping (Dictionary<String,String>) -> Void) -> Void {
        let tasks: Array = ["GuestName", "CompanyName", "Address", "ZipCode", "TelNumber", "Description"]
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
            case "CompanyName":
                if guest.companyNameImageData != Data() {
                    apiQueueGroup.enter()
                    // processIdentifireを作成
                    let processIdentifire = "companyName\(guest.id)"
                    // CloudVisionAPIで手書き文字解析
                    let imageData: String = makeCompanyNameImageData(guest)
                    // 手書き文字解析
                    apiQueue.async(group: apiQueueGroup) {
                        callGoogleVisionApi(imageData, processIdentifire, completion: { (result) in
                            // 改行コードを取り除く
                            let text = result.trimmingCharacters(in: .whitespacesAndNewlines)
                            apiResult["companyName"] = text
                            print("会社名：\(text)")
                            apiQueueGroup.leave()
                        })
                    }
                }
                break
            case "Address":
                if guest.addressImageData != Data() {
                    apiQueueGroup.enter()
                    // processIdentifireを作成
                    let processIdentifire = "address\(guest.id)"
                    // CloudVisionAPIで手書き文字解析
                    let imageData: String = makeAddressImageData(guest)
                    // 手書き文字解析
                    apiQueue.async(group: apiQueueGroup) {
                        callGoogleVisionApi(imageData, processIdentifire, completion: { (result) in
                            // 改行コードを取り除く
                            let text = result.trimmingCharacters(in: .whitespacesAndNewlines)
                            apiResult["address"] = text
                            print("住所：\(text)")
                            apiQueueGroup.leave()
                        })
                    }
                }
                break
            case "ZipCode":
                if guest.zipCodeImageData != Data() {
                    apiQueueGroup.enter()
                    // processIdentifireを作成
                    let processIdentifire = "companyName\(guest.id)"
                    // CloudVisionAPIで手書き文字解析
                    let imageData: String = makeZipcodeImageData(guest)
                    // 手書き文字解析
                    apiQueue.async(group: apiQueueGroup) {
                        callGoogleVisionApi(imageData, processIdentifire, completion: { (result) in
                            // 改行コードを取り除く
                            let text = result.trimmingCharacters(in: .whitespacesAndNewlines)
                            apiResult["zipCode"] = text
                            print("郵便番号：\(text)")
                            apiQueueGroup.leave()
                        })
                    }
                }
                break
            case "TelNumber":
                if guest.telNumberImageData != Data() {
                    apiQueueGroup.enter()
                    // processIdentifireを作成
                    let processIdentifire = "telNumber\(guest.id)"
                    // CloudVisionAPIで手書き文字解析
                    let imageData: String = makeTelNumberImageData(guest)
                    // 手書き文字解析
                    apiQueue.async(group: apiQueueGroup) {
                        callGoogleVisionApi(imageData, processIdentifire, completion: { (result) in
                            // 改行コードを取り除く
                            let text = result.trimmingCharacters(in: .whitespacesAndNewlines)
                            apiResult["telNumber"] = text
                            print("電話番号：\(text)")
                            apiQueueGroup.leave()
                        })
                    }
                }
                break
            case "Description":
                if guest.descriptionImageData != Data() {
                    apiQueueGroup.enter()
                    // processIdentifireを作成
                    let processIdentifire = "description\(guest.id)"
                    // CloudVisionAPIで手書き文字解析
                    let imageData: String = makeDescriptionImageData(guest)
                    // 手書き文字解析
                    apiQueue.async(group: apiQueueGroup) {
                        callGoogleVisionApi(imageData, processIdentifire, completion: { (result) in
                            // 改行コードを取り除く
                            let text = result.trimmingCharacters(in: .whitespacesAndNewlines)
                            apiResult["description"] = text
                            print("備考：\(text)")
                            apiQueueGroup.leave()
                        })
                    }
                }
                break
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
        let image = canvas.drawing.image(from: CGRect(x: 0, y: 0, width: GuestCardView.guestNameWidth, height: GuestCardView.guestNameHeight), scale: 1.0)
        let binaryImageData = image.pngData()!.base64EncodedString(options: .endLineWithCarriageReturn)
        return binaryImageData
    }
    
    static func makeCompanyNameImageData(_ guest: Guest) -> String {
        let canvas: PKCanvasView = PKCanvasView(frame: .zero)
        canvas.setDrawingData(canvas, guest.companyNameImageData)
        let image = canvas.drawing.image(from: CGRect(x: 0, y: 0, width: GuestCardView.companyNameWidth, height: GuestCardView.companyNameHeight), scale: 1.0)
        let binaryImageData = image.pngData()!.base64EncodedString(options: .endLineWithCarriageReturn)
        return binaryImageData
    }
    
    static func makeAddressImageData(_ guest: Guest) -> String {
        let canvas: PKCanvasView = PKCanvasView(frame: .zero)
        canvas.setDrawingData(canvas, guest.addressImageData)
        let image = canvas.drawing.image(from: CGRect(x: 0, y: 0, width: GuestCardView.addressWidth, height: GuestCardView.addressHeight), scale: 1.0)
        let binaryImageData = image.pngData()!.base64EncodedString(options: .endLineWithCarriageReturn)
        return binaryImageData
    }
    
    static func makeZipcodeImageData(_ guest: Guest) -> String {
        let canvas: PKCanvasView = PKCanvasView(frame: .zero)
        canvas.setDrawingData(canvas, guest.zipCodeImageData)
        let image = canvas.drawing.image(from: CGRect(x: 0, y: 0, width: Int(GuestCardView.zipCodeWidth), height: GuestCardView.zipCodeHeight), scale: 1.0)
        let binaryImageData = image.pngData()!.base64EncodedString(options: .endLineWithCarriageReturn)
        return binaryImageData
    }
    
    static func makeTelNumberImageData(_ guest: Guest) -> String {
        let canvas: PKCanvasView = PKCanvasView(frame: .zero)
        canvas.setDrawingData(canvas, guest.telNumberImageData)
        let image = canvas.drawing.image(from: CGRect(x: 0, y: 0, width: Int(GuestCardView.telNumberWidth), height: GuestCardView.telNumberHeight), scale: 1.0)
        let binaryImageData = image.pngData()!.base64EncodedString(options: .endLineWithCarriageReturn)
        return binaryImageData
    }
    
    static func makeDescriptionImageData(_ guest: Guest) -> String {
        let canvas: PKCanvasView = PKCanvasView(frame: .zero)
        canvas.setDrawingData(canvas, guest.descriptionImageData)
        let image = canvas.drawing.image(from: CGRect(x: 0, y: 0, width: Int(GuestCardView.guestNameWidth), height: Int(GuestCardView.guestNameHeight)), scale: 1.0)
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

