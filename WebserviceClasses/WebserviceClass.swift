//
//  WebserviceClass.swift
//  TestSQL
//
//  Created by Rahul Patel on 08/02/22.
//

import UIKit

typealias completionHandler = (_ status: Bool,_ apiMessage: String,_ dataDic: Any) -> ()


class WebserviceClass {
    
    
    
    class func makeGetRequest(urlString: String, completion: @escaping completionHandler) {
        var responseDic : Any?

        guard let url = URL(string: (ApiKey.baseURL).rawValue + urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse{
                print("Status code of the request:=>",httpResponse.statusCode)
                
                var statusCode : Bool = false

            if let responseData = data {
                if let mainDic = responseDic as? [String: Any], let APIStatus = mainDic["status"] as? Bool {
                    statusCode = APIStatus
                }
                
                let alertMessage = getMessageFromApiResponse(param: responseDic ?? "")

                responseDic = getResponseDicFromData(responseData: responseData)
                completion(statusCode, alertMessage, responseDic ?? ["message":"Something went wrong"])

            }
            else
            {
                completion(false,(error?.localizedDescription ?? ""),["message":error?.localizedDescription])
                print(error?.localizedDescription ?? "")
            }
            }
        }.resume()
    }
    
    
    class func getResponseDicFromData(responseData: Data) -> Any{
        let jso = try? JSONSerialization.jsonObject(with: responseData)
        
        if let jsonObj = jso{
            return jsonObj
        }else{
            return ["message":"Something went wrong"]
        }
    }
    
    class func getMessageFromApiResponse(param: Any) -> String {
        
        if let res = param as? String {
            return res
            
        }else if let resDict = param as? NSDictionary {
            
            if let msg = resDict.object(forKey: "message") as? String {
                return msg
                
            }else if let msg = resDict.object(forKey: "msg") as? String {
                return msg
                
            }else if let msg = resDict.object(forKey: "message") as? [String] {
                return msg.first ?? ""
                
            }
            
        }else if let resAry = param as? NSArray {
            
            if let dictIndxZero = resAry.firstObject as? NSDictionary {
                if let msg = dictIndxZero.object(forKey: "message") as? String {
                    return msg
                    
                }else if let msg = dictIndxZero.object(forKey: "msg") as? String {
                    return msg
                    
                }else if let msg = dictIndxZero.object(forKey: "message") as? [String] {
                    return msg.first ?? ""
                }
                
            }else if let msg = resAry as? [String] {
                return msg.first ?? ""
                
            }
        }
        return ""
    }
}
