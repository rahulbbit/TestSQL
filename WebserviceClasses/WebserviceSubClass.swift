//
//  WebserviceSubClass.swift
//  TestSQL
//
//  Created by Rahul Patel on 08/02/22.
//

import UIKit

class WebserviceSubClass {
   class func webserviceCallForLogin(url : String, param : Any, completion : @escaping (_ status: Bool,_ apiMessage: String,_ dataDic: Any) -> ())
    {
        
//        WebserviceClass.makeGetRequest(urlString: url, completion: completion)
        WebserviceClass.makeGetRequest(urlString: url) { status, apiMessage, dataDic in
//            completion(status, apiMessage, dataDic)
            completion(status, apiMessage, dataDic)
        }
    }
    
    
}
