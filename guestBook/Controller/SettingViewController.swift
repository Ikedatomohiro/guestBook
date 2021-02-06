//
//  SettingViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/29.
//

import UIKit
import Alamofire
import FirebaseStorage
import SwiftyJSON

struct responseText {
    let responseText: String
    let responseDescription: String
}

class SettingViewController: UIViewController {
    var points: [CGPoint]!
    var b64String: String!
    var googleAPIKey = Keys.googleVisionAPIKey
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        callGoogleVisionApi()
    }
    
    fileprivate func callGoogleVisionApi() {
        
        let apiURL = "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)"
        var imageUri = ""
        FirebaseStorage.Storage.storage().reference().child("QFQSYdXfzaUceWlWfWsj_guestName.png").downloadURL { (URL, error) in
            // 画像URLを取得できたときに画像解析を行う
            if URL != nil {
                imageUri = URL?.absoluteString ?? ""
                let parameters: Parameters = [
                    "requests": [
                        "image": [
                            "source": ["imageUri": imageUri
                            ]
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
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "X-Ios-Bundle-Identifier": Bundle.main.bundleIdentifier ?? ""]
                AF.request(
                    apiURL,
                    method: .post,
                    parameters: parameters,
                    encoding: JSONEncoding.default,
                    headers: headers)
                    .responseJSON { response in
                        guard let responseData = response.data else { return }
                        let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options:.allowFragments) as? [String: Any]
                        
//                        print(jsonObject)
//                        print(">>>>>>>>>>>>>>>>>>>>>>>>>>.")
//                        debugPrint(response)
//                        let responseName = try? JSONDecoder().decode(responseText.self, from: responseData)
                        
                        let jsonValue = JSON(jsonObject)
                        let responseName = jsonValue["responses"][0]["textAnnotations"][0]["description"].string!  // ここは不安定だから対処必要
                        let trimedName = responseName.trimmingCharacters(in: .newlines)
                        print(responseName)
                        print(trimedName)
                        
                        
                        
                        
                        
                        
                        return
                    }
            } else {
                print(URL ?? "画像が見つかりません")

            }
        }
    }
    
    
}
