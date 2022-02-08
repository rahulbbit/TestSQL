//
//  RequestModel.swift
//  TestSQL
//
//  Created by Rahul Patel on 07/02/22.
//

import Foundation

//MARK: - Login Req. Model

class LoginReqModel : Encodable {
    
    
    var email : String?
    var password : String?
    var platform : String?
    var os_version : String?
    var application_version : String?
    var model : String?
    var type : String?
    var uid : String?

    
    enum CodingKeys: String, CodingKey {
      
        case email = "email"
        case password = "password"
        case platform = "platform"
        case os_version = "os_version"
        case application_version = "application_version"
        case model = "model"
        case type = "type"
        case uid = "uid"
    }
}

