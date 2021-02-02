//
//  SettingViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/29.
//

import UIKit
import Alamofire



class SettingViewController: UIViewController {
    var points: [CGPoint]!
    var b64String: String!
    var googleAPIKey = Keys.googleVisionAPIKey
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
//        let task = URLSession.shared.dataTask(with: makeRequest(), completionHandler: { (data, response, err) in
//          UIApplication.shared.isNetworkActivityIndicatorVisible = false
//          guard err == nil else {
//            DispatchQueue.main.async {
//              self.showErrorAlert()
//            }
//            return
//          }
//          do {
//              let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [Any]
//              let jsonMap = json.map { (jsonMap) -> [String: Any] in
//                  return jsonMap as! [String: Any]
//              }
//              print(jsonMap)
//          }
//          catch {
//              print(error)
//          }
//        })
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        task.resume()
    
    
    
    
//    }
    
//    func makeRequest() -> URLRequest {
//      let json = ["requests": [
//      [
//        "image": [
//          "source": [
////            "imageUri": "gs://guest_book/UPLOADFOLDER.png"
//            "imageUri": "gs://vision-api-handwriting-ocr-bucket/handwriting_image.png"
//          ]
//        ],
//        "features": [
//          [
//            "type": "DOCUMENT_TEXT_DETECTION"
//          ]
//        ]
//      ]
//    ]
//                 ]
//      let request = NSMutableURLRequest(url: URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!)
//      request.httpMethod = "POST"
//      if JSONSerialization.isValidJSONObject(json) {
//          request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
//      }
//      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//      request.addValue("application/json", forHTTPHeaderField: "Accept")
//      return request as URLRequest
//    }
//    func showErrorAlert() {
//      let alertController = UIAlertController(title: "Error", message: "Something went wrong 😔", preferredStyle: .alert);
//      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil);
//      alertController.addAction(okAction);
//      self.present(alertController, animated: true, completion: nil);
        
        
        callGoogleVisionApi()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    
    
    
    fileprivate func callGoogleVisionApi() {
        
        let apiURL = "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)"
        let imageUri = "https://storage.googleapis.com/guest_info/技術者のためのやさしい数学.png"
//        let imageUri = "gs://guestbook-311bf.appspot.com/QFQSYdXfzaUceWlWfWsj_guestName.png"
//        let imageUri = "https://storage.googleapis.com/guest_info/QFQSYdXfzaUceWlWfWsj_guestName-6.png"

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

//        AF.request(apiURL, method: .post, parameters: parameters)
        
        
        AF.request(
            apiURL,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers)
            .responseJSON { response in
//                if response.result {
//                    completion(nil)
                debugPrint(response)
                    return
//                }
                print(response.result)
        }
    }
    
    
    
    
    
    
}
