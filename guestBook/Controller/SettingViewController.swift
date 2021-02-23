//
//  SettingViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/29.
//

import UIKit

class SettingViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        
        
        
        
        
        doMultiAsyncProcess()

        
        
        
    }
    
    func doMultiAsyncProcess() {
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)

        // 5つの非同期処理を実行
        for i in 1...5 {
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) {
                self.asyncProcess(number: i) {
                    (number: Int) -> Void in
                    print("#\(number) End")
                    dispatchGroup.leave()
                }
            }
        }

        // 全ての非同期処理完了後にメインスレッドで処理
        dispatchGroup.notify(queue: .main) {
            print("All Process Done!")
        }
    }

    // 非同期処理
    func asyncProcess(number: Int, completion: (_ number: Int) -> Void) {
        print("#\(number) Start")
        sleep((arc4random() % 100 + 1) / 10)
        completion(number)
    }

    
    
    
    
    
    
    
    
    
    
    
    
}
