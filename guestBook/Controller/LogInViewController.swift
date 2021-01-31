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
    fileprivate let emailTextField    = UITextField()
    fileprivate let emailSignUpButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupEmailView()
        
        
        setupSignInButton()
        googleSignIn()

        


    }

    fileprivate func setupEmailView() {
        view.addSubview(emailTextField)
        emailTextField.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: 300, height: 80))
        view.addSubview(emailSignUpButton)
        emailSignUpButton.anchor(top: view.layoutMarginsGuide.topAnchor, leading: emailTextField.trailingAnchor, bottom: nil, trailing: nil, size: .init(width: 200, height: 80))
        emailSignUpButton.setTitle("emailでログイン", for: .normal)
        emailSignUpButton.backgroundColor = .systemTeal
        emailSignUpButton.addTarget(self, action: #selector(emailSignUp), for: .touchUpInside)
    }
    
    @objc func emailSignUp() {
        let email = self.emailTextField.text
        if email != "" {
            let actionCodeSettings = ActionCodeSettings()
            actionCodeSettings.url = URL(string: Keys.emailSignInDynamicLink)
            // The sign-in operation has to always be completed in the app.
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
            actionCodeSettings.setAndroidPackageName("com.example.android",
                                                     installIfNotAvailable: false, minimumVersion: "12")
            
            Auth.auth().sendSignInLink(toEmail:email ?? "",
                                       actionCodeSettings: actionCodeSettings) { error in
                if let error = error {
                  print(error.localizedDescription)
                  return
                }
                // The link was successfully sent. Inform the user.
                // Save the email locally so you don't need to ask the user for it again
                // if they open the link on the same device.
                UserDefaults.standard.set(email, forKey: "Email")
//                self.showMessagePrompt("Check your email for link")
                // ...
            }

        } else {
          print("Email can't be empty")
        }
        
    }
    
    
    
    fileprivate func setupSignInButton() {
        view.addSubview(googleLogInButton)
        googleLogInButton.anchor(top: emailTextField.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 100, height: 50))

    }
    
    fileprivate func googleSignIn() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance().signIn()          // どっち？
        GIDSignIn.sharedInstance()?.delegate = self  // どっち？

    }
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

