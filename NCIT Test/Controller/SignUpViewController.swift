//
//  SignUpViewController.swift
//  NCIT Test
//
//  Created by Eslam Ahmed on 5/21/20.
//  Copyright © 2020 Eslam Ahmed. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import StatusAlert
import SwiftMessages

class SignUpViewController: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var username: UITextFieldX!
    @IBOutlet weak var password: UITextFieldX!
    @IBOutlet weak var confirm_password: UITextFieldX!
    
    
    let statusAlert = StatusAlert()
    let reach = Reachability()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        guard let user = username.text, !user.isEmpty else {
            statusAlert.image = UIImage(named: "error")
            statusAlert.title = "لا تضع خانه الاسم فارغة"
            statusAlert.showInKeyWindow()
            return
        }
        guard let pass = password.text, !pass.isEmpty else {
            statusAlert.image = UIImage(named: "error")
            statusAlert.title = "لا تضع خانة الرمز السري فارغة"
            statusAlert.showInKeyWindow()
            return
        }
         if self.password.text == self.confirm_password.text {
            API.SignUp(user, pass) { (error, success) in
                if success {
                    let fadeInAnimation = NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION
                    let size = CGSize(width: 200.0, height: 200.0)
                    self.startAnimating(size, message: "تم إنشاء حساب بنجاح", messageFont: .systemFont(ofSize: 18), type: .lineSpinFadeLoader, color: .black, padding: 20, displayTimeThreshold: 1, minimumDisplayTime: 0, backgroundColor: .clear, textColor: .black, fadeInAnimation: fadeInAnimation)
                    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
                    let blurEffectView = UIVisualEffectView(effect: blurEffect)
                    blurEffectView.frame = self.view.bounds
                    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    self.view.addSubview(blurEffectView)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
                        self.stopAnimating()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                        viewController.modalPresentationStyle = .fullScreen
                        viewController.modalTransitionStyle = .crossDissolve
                        self.present(viewController , animated: true)
                    }
                } else {
                    print(error?.localizedDescription ?? "")
                }
            }
            
         } else {
            statusAlert.image = UIImage(named: "error")
            statusAlert.title = "كلمة المرور غير متطابقة"
            statusAlert.showInKeyWindow()
        }
        
        
        
    }
    
    
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         if CheckInternet.Connection() {
             
         }
         else {
             do {
                 try reach?.startNotifier()
             } catch let error {
                 print(error.localizedDescription)
             }
             handleConnectionReachability()
             
         }
         
     }

     fileprivate func handleConnectionReachability()  {
          NotificationCenter.default.addObserver(forName: .reachabilityChanged, object: reach, queue: .main) { (notification) in
             if let myReach = notification.object as? Reachability {
                 switch myReach.connection {
                 case .cellular:
                     print("cellular")
                     self.displayMessage(message: "اتصلت ببيانات الهاتف", messageError: false)
                 case .wifi:
                     print("wifi")
                     self.displayMessage(message: "اتصل عن طريق ال واي فاي", messageError: false)
                     
                 case .none:
                     print("none")
                     self.displayMessage(message: "لا يوجداتصال بالانترنت ", messageError: true)
                     
                     
                 }
                 
             }
         }
     }
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         reach?.stopNotifier()
         NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reach)
     }
     
     func displayMessage(message: String, messageError: Bool) {
         
         let view = MessageView.viewFromNib(layout: MessageView.Layout.messageView)
         if messageError == true {
             view.configureTheme(.error)
         } else {
             view.configureTheme(.success)
         }
         
         view.iconImageView?.isHidden = true
         view.iconLabel?.isHidden = true
         view.titleLabel?.isHidden = true
         view.bodyLabel?.text = message
         view.titleLabel?.textColor = UIColor.white
         view.bodyLabel?.textColor = UIColor.white
         view.button?.isHidden = true
         
         var config = SwiftMessages.Config()
         config.presentationStyle = .top
         SwiftMessages.show(config: config, view: view)
     }
    
}
