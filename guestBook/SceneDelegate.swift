//
//  SceneDelegate.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/10/27.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let eventListVC: EventListViewController = EventListViewController()
        navigationController = UINavigationController(rootViewController: eventListVC)
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        // userActivityプロパティからリンクURLを取得
        guard let url = userActivity.webpageURL else { return }
        let link = url.absoluteString
        
        if Auth.auth().isSignIn(withEmailLink: link) {
            // ローカルに保存していたメールアドレスを取得
            guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                print("メールアドレスが存在しません。")
                return
            }
            // ログイン処理
            Auth.auth().signIn(withEmail: email, link: link) { (auth, error) in
                if let error = error {
                    print(error.localizedDescription)
                    print("ログイン失敗")
                    print(link)
                    print(email)
                    print(auth ?? "auth info is empty...")
                    return
                }
                print("メールリンクログイン成功")
                let eventListVC: EventListViewController = EventListViewController()
                self.navigationController = UINavigationController(rootViewController: eventListVC)
                guard let windowScene = (scene as? UIWindowScene) else { return }
                self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
                self.window?.windowScene = windowScene
                self.window?.rootViewController = self.navigationController
                self.window?.makeKeyAndVisible()
                
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

