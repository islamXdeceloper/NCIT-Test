//
//  ViewController.swift
//  NCIT Test
//
//  Created by Eslam Ahmed on 5/21/20.
//  Copyright © 2020 Eslam Ahmed. All rights reserved.
//

import UIKit
import StatusAlert
import NVActivityIndicatorView
import SwiftMessages

class LoginViewController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var username: UITextFieldX!
    @IBOutlet weak var password: UITextFieldX!
    
    //instance from Status Alert
    let statusAlert = StatusAlert()
    //instance form Reachability handle internet error
    let reach = Reachability()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func loginTapped(_ sender: Any) {
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
        API.Login(user, pass) { (error, success) in
            if success {
                let fadeInAnimation = NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION
                let size = CGSize(width: 200.0, height: 200.0)
                self.startAnimating(size, message: "", messageFont: .systemFont(ofSize: 18), type: .lineSpinFadeLoader, color: .black, padding: 20, displayTimeThreshold: 1, minimumDisplayTime: 0, backgroundColor: .clear, textColor: .black, fadeInAnimation: fadeInAnimation)
                let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = self.view.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.view.addSubview(blurEffectView)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                    self.stopAnimating()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                    viewController.modalPresentationStyle = .fullScreen
                    viewController.modalTransitionStyle = .crossDissolve
                    self.present(viewController , animated: true)
            } 
        }
 
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
                     self.displayMessage(message: "Connected by Cellular Data", messageError: false)
                 case .wifi:
                     print("wifi")
                     self.displayMessage(message: "Connected by Wifi", messageError: false)
                     
                 case .none:
                     print("none")
                     self.displayMessage(message: "No Internet Connection", messageError: true)
                     
                     
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

