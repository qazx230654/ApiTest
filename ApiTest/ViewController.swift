//
//  ViewController.swift
//  ApiTest
//
//  Created by Hung-Ming Chen on 2018/12/18.
//  Copyright © 2018 Hung-Ming Chen. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController,UITextFieldDelegate {
    
    
    struct AllData: Decodable{
        var user: [User]?
        var status: String?
    }
    
    struct User: Decodable{
        var pk: String?
        var model: String?
        var fields: Fields?
    }
    
    struct Fields: Decodable {
        var birthday: String?
        var email: String?
        var height: Int?
        var address: String?
        var name: String?
        var weight: Int?
        var gender: String?
    }
    
    struct login: Decodable {
        var token: String?
        var status: Int?
    }
    
    struct register: Decodable{
        var status: String?
    }
        
    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var account :String = ""
    var password :String = ""
    var mytoken :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountTF.delegate = self
        passwordTF.delegate = self
        
        
    }

    @IBAction func loginAction(_ sender: UIButton) {
        account = accountTF.text!
        password = passwordTF.text!
        loginAPI(phoneNumber: account, password: password)
        
    }
    
    @IBAction func userProfileAction(_ sender: UIButton) {
        getuserProfile(token: mytoken!)
    }
    
    func loginAPI(phoneNumber:String,password:String){
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json",
            "cache-control": "no-cache",
            "Postman-Token": "ca9ed07f-1541-48b7-9240-997db9260195"
        ]
        
        let postData = NSMutableData(data: "phoneNumber=\(phoneNumber)".data(using: String.Encoding.utf8)!)
        postData.append("&password=\(password)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://10.20.0.83:8000/api/login")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else if let data = data{
                let decoder = JSONDecoder()
                print(data)
                if let object = try? decoder.decode(login.self, from: data){
                    self.mytoken = object.token
                    print("\(object)")
                }
            }
        })
        
        dataTask.resume()
    }
    
    func getuserProfile(token:String){
        let headers = [
            "cache-control": "no-cache",
            "Postman-Token": "30c0ef31-abab-472d-a686-87b8f38cb868"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://10.20.0.83:8000/api/user/UpUserProfile/?token=\(token)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else if let data = data{
                let decoder = JSONDecoder()
                print(data)
                if let object = try? decoder.decode(AllData.self, from: data){
                    print("\(object)")
                }
            }
        })
        
        dataTask.resume()
    }
    
}

