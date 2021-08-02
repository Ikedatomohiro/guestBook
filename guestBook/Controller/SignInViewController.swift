//
//  SignInViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/23.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class SignInViewController: UIViewController {
    
    fileprivate let emailSignInHeadlineLabel = UILabel()
    fileprivate let emailSignInUnderline    = UIBezierPath()
    fileprivate let googleSignInHeadlineLabel = UILabel()
    fileprivate let googleLogInButton = GIDSignInButton()
    fileprivate let emailTextField    = UITextField()
    fileprivate let emailSignUpButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupEmailSignInView()
        setupGoogleSignInButton()
        googleSignIn()
        if Auth.auth().currentUser != nil {
            print(Auth.auth().currentUser?.uid)
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    fileprivate func setupEmailSignInView() {
        
        self.view.addSubview(emailSignInHeadlineLabel)
        emailSignInHeadlineLabel.text = "メールアドレスでログイン"
        emailSignInHeadlineLabel.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 20, left: .zero, bottom: .zero, right: .zero))
        emailSignInHeadlineLabel.textAlignment = .center
        
        self.view.addSubview(emailTextField)
        emailTextField.anchor(top: emailSignInHeadlineLabel.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 30, left: screenSize.width / 2 - 200, bottom: .zero, right: screenSize.width / 2 - 200) , size: .init(width: .zero, height: 50))
        emailTextField.placeholder = "メールアドレス"
        emailTextField.backgroundColor = .white
        emailTextField.tintColor = .gray
        emailTextField.layer.borderColor = UIColor.black.cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.cornerRadius = 5
        
        self.view.addSubview(emailSignUpButton)
        emailSignUpButton.anchor(top: emailTextField.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 30, left: screenSize.width / 2 - 140, bottom: .zero, right: screenSize.width / 2 - 140) , size: .init(width: .zero, height: 50))
        emailSignUpButton.setTitle("ログイン認証メールを送信", for: .normal)
        emailSignUpButton.backgroundColor = green
        emailSignUpButton.layer.cornerRadius = 5
        emailSignUpButton.addTarget(self, action: #selector(emailSignUp), for: .touchUpInside)
        
    }
    
    func animateView(_ viewToAnimate:UIView) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
        }) { (_) in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                viewToAnimate.transform = .identity
                
            }, completion: nil)
        }
    }
    
    fileprivate func setupGoogleSignInButton() {
        self.view.addSubview(googleSignInHeadlineLabel)
        googleSignInHeadlineLabel.text = "Googleアカウントでログイン"
        googleSignInHeadlineLabel.anchor(top: emailSignUpButton.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 60, left: .zero, bottom: .zero, right: .zero))
        googleSignInHeadlineLabel.textAlignment = .center
        
        self.view.addSubview(googleLogInButton)
        googleLogInButton.anchor(top: googleSignInHeadlineLabel.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 30, left: screenSize.width / 2 - 100, bottom: .zero, right: screenSize.width / 2 - 100) , size: .init(width: .zero, height: 50))
    }
    
    @objc func emailSignUp() {
        emailSignUpButton.animateView(emailSignUpButton)
        let email = self.emailTextField.text
        if email != "" {
            let actionCodeSettings = ActionCodeSettings()
            actionCodeSettings.url = URL(string: Keys.emailSignInDynamicLink)
            // The sign-in operation has to always be completed in the app.
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
            
            // リンクURL
            var components = URLComponents()
            components.scheme = "https"
            components.host = "guestbook.page.link"
            let queryItemEmailName = "email"
            let emailTypeQueryItem = URLQueryItem(name: queryItemEmailName, value: email)
            components.queryItems = [emailTypeQueryItem]
            guard let linkParameter = components.url else { return }
            print("email:  \(linkParameter.absoluteString)")
            actionCodeSettings.url = linkParameter
            
            // ユーザーに認証リンクを送信
            Auth.auth().sendSignInLink(toEmail:email ?? "",
                                       actionCodeSettings: actionCodeSettings) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                // The link was successfully sent. Inform the user.
                // Save the email locally so you don't need to ask the user for it again
                // if they open the link on the same device.
                UserDefaults.standard.set(email, forKey: "email")
                print("\(String(describing: email))メール送信成功")
                //                self.showMessagePrompt("Check your email for link")
                // ...
            }
            signInButtonTaped()
        } else {
            print("Email can't be empty")
        }
        
    }
    
    fileprivate func signInButtonTaped() {
        guard emailTextField.text != "" else { return }
        if let email = emailTextField.text {
            let dialog = UIAlertController(title: "\(email)にメールを送信しました。", message: "", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
        }
    }
    
    fileprivate func googleSignIn() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
}
// MARK:- Extensions
extension SignInViewController: GIDSignInDelegate {
    
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
                
                let eventListVC = EventListViewController()
                eventListVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(eventListVC, animated: true)
            }
        }
    }
}
