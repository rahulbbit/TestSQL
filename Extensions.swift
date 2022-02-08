//
//  Extensions.swift
//  TestSQL
//
//  Created by Rahul Patel on 07/02/22.
//

import UIKit


extension UIViewController
{
    
    func ShowAlert(title : String = "", OfMessage : String, buttons : [String], _ completion: ((_ title : String) -> ())? = nil) -> Void {
        
        DispatchQueue.main.async {
            print("the alert message is \(OfMessage)")
            let alertController = UIAlertController(title: title, message: OfMessage, preferredStyle: UIAlertController.Style.alert)
            
            for title in buttons
            {
                let action = UIAlertAction(title: title, style: .default, handler: {
                    (alert: UIAlertAction!) in
                    completion?(title)
                    
                })
                alertController.addAction(action)
                
            }
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
}

extension String
{
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func trimString() -> String
    {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    
    func asString() -> String? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        if let data = try? encoder.encode(self), let str = String(data: data, encoding: .utf8){
            return str
        }else{
            return nil
        }
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""//"\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

