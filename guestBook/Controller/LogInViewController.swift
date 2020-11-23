//
//  LogInViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/23.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LogInViewController: UIViewController {
    
    fileprivate let googleLogInButton = GIDSignInButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSignInButton()
        googleSignIn()




    }
    
    fileprivate func setupSignInButton() {
        view.addSubview(googleLogInButton)
        googleLogInButton.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 100, height: 50))

    }
    
    fileprivate func googleSignIn() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance().signIn()          // どっち？
        GIDSignIn.sharedInstance()?.delegate = self  // どっち？

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LogInViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let auth = user.authentication else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Google SignIn Success!")
            }
        }
    }
}

