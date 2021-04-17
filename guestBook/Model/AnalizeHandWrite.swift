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
    static func analizeText(guest: Guest, updateGuestParam: Set<String>, completion: @escaping (Dictionary<String,String>) -> Void) -> Void {
        
        let guestDictionary = [
            "guestName": guest.guestNameImageData,
            "companyName": guest.companyNameImageData,
            "address": guest.addressImageData,
            "zipCode": guest.zipCodeImageData,
            "telNumber": guest.telNumberImageData,
            "desription": guest.descriptionImageData,
        ]
        var apiResult: Dictionary<String, String> = [:]
        for item in guestDictionary {
            guard updateGuestParam.contains(item.key) else { continue }
            apiQueueGroup.enter()
            // processIdentifireを作成
            let processIdentifire = "\(item.key)\(guest.id)"
            // CloudVisionAPIで手書き文字解析
            let imageData: String = makeImageData(item.value)
            // 手書き文字解析
            callGoogleVisionApi(imageData, processIdentifire, completion: { (result) in
                apiQueue.async(group: apiQueueGroup) {
                    // 改行コードを取り除く
                    let text = result.trimmingCharacters(in: .whitespacesAndNewlines)
                    apiResult["\(item.key)"] = text
                    print("\(item.key)：\(text)")
                    apiQueueGroup.leave()
                }
            })
        }
        // 全ての非同期処理完了後にメインスレッドで処理
        apiQueueGroup.notify(queue: .main) {
            print("Guestモデルのデータ\(apiResult)")
            completion(apiResult)
        }
    }
    
    static func makeImageData(_ imageData: Data) -> String {
        let canvas: PKCanvasView = PKCanvasView(frame: .zero)
        canvas.setDrawingData(canvas, imageData)
        let image = canvas.drawing.image(from: CGRect(x: 0, y: 0, width: GuestCardView.addressWidth, height: GuestCardView.addressWidth), scale: 1.0)
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
                            if header.name == "Process-Identifire" && header.value == processIdentifire {
                                resultText = decoded.responses[0].fullTextAnnotation.text
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
