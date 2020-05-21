//
//  Api.swift
//  NCIT Test
//
//  Created by Eslam Ahmed on 5/21/20.
//  Copyright © 2020 Eslam Ahmed. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import StatusAlert
import NVActivityIndicatorView


class API : NSObject {

    //MARK:- (1) SignUP Function POST
    
    /// func Sign Up to Create New Account
    ///  - Parameters:
    ///    - password : String
    ///    - name : String

    class  func SignUp(  _ user_name : String, _ user_pass :String, completion: @escaping (_ error:Error? , _ success : Bool )->Void ) {
        
        let url = URLs.signup
        
        let parameters: [String: Any] = [
            "user_name": user_name,
            "user_pass": user_pass
         
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseJSON { response in

            switch response.result {
            case .failure(let error):
                let statusAlert = StatusAlert()
                statusAlert.image = UIImage(named: "error")
                statusAlert.title = "لا يوجد اتصال بالانترنت"
                statusAlert.showInKeyWindow()
                completion(error, false)
            case .success(let value):
                let json = JSON(value)
                print(json)
                if json["response_id"].intValue == 1 {
                    completion(nil,true)
                }
                if json["error_id"].intValue == -1 {
                    let statusAlert = StatusAlert()
                    statusAlert.image = UIImage(named: "error")
                    statusAlert.title = "لا يمكنك إنشاء حساب بأسم متسخدم متواجد بالفعل حاول مره اخري."
                    statusAlert.showInKeyWindow()
                    completion(nil, false)
                }
  
            }
            
        }
        
        
    }
    
    //MARK:- (2) Sginin Function POST
    /// func Sign Up to Create New Account
    ///  - Parameters:
    ///    - password : String
    ///    - name : String
      class  func Login(  _ user_name : String, _ user_pass :String, completion: @escaping (_ error:Error? , _ success : Bool )->Void ) {
          
          let url = URLs.login
          
          let parameters: [String: Any] = [
              "user_name": user_name,
              "user_pass": user_pass
           
          ]
          AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseJSON { response in

              switch response.result {
              case .failure(let error):
                  let statusAlert = StatusAlert()
                  statusAlert.image = UIImage(named: "error")
                  statusAlert.title = "لا يوجد اتصال بالانترنت"
                  statusAlert.showInKeyWindow()
                  completion(error, false)
              case .success(let value):
                  let json = JSON(value)
                  print(json)
                  if json["user_id"].stringValue != "" {
                    completion(nil, true)

                  }
                  if json["error_id"].intValue == -1 {
                      let statusAlert = StatusAlert()
                      statusAlert.image = UIImage(named: "error")
                      statusAlert.title = "الاسم او الرقم السري خطأ حاول مره اخري"
                      statusAlert.showInKeyWindow()
                      completion(nil, false)
                  }
    
              }
              
          }
          
          
      }


}
