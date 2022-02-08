//
//  ViewController.swift
//  TestSQL
//
//  Created by Rahul Patel on 07/02/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPssword: UITextField!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    let systemVersion = UIDevice.current.systemVersion
    var db:DBHelper = DBHelper()
    var userInformation : [Item]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtEmail.text = "kate@gmail.com"
        txtPssword.text = "12345678"
    }
    
    
    
    @IBAction func btnLogin(_ sender: Any) {
        if(self.validation())
        {
            self.webserviceForLogin()
        }
    }
    
    func webserviceForLogin()
    {
        
        let url = "http://ariel.itcc.net.au/api/v1/auth/login"
        
        
        let reqModelLogin = LoginReqModel()
        reqModelLogin.email = txtEmail.text?.trimString() ?? ""
        reqModelLogin.password = txtPssword.text?.trimString() ?? ""
        reqModelLogin.platform = "iOS"
        reqModelLogin.os_version = "iOS \(systemVersion)"
        reqModelLogin.application_version = "V1"
        reqModelLogin.model = "iPhone"
        reqModelLogin.type = "Gmail"
        reqModelLogin.uid = "xyz"
        
        self.webserviceForLogin(strURL: url, parameters: reqModelLogin)
    }
    
    
    func validation() -> Bool
    {
        
        if(txtEmail.text?.trimString().count == 0)
        {
            self.ShowAlert(OfMessage: "Please enter Email", buttons: ["OK"])
            return false
        }
        
        if(txtEmail.text?.trimString().isValidEmail() == false)
        {
            self.ShowAlert(OfMessage: "Please enter valid Email", buttons: ["OK"])
            return false
        }
        else if(txtPssword.text?.trimString().count == 0)
        {
            self.ShowAlert(OfMessage: "Please enter Password", buttons: ["OK"])
            return false
        }
        else if((txtPssword.text?.trimString().count ?? 0) < 8)
        {
            self.ShowAlert(OfMessage: "Password should be more than 7 characters", buttons: ["OK"])
            return false
        }
        return true
    }
    
    func navigateToDetailScreen(userData : LoginResponse)
    {
        guard let userInfo = userData.item else {return}
        self.saveInDatabase(userData: userInfo)
        
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "UserDataViewController") as? UserDataViewController else {return}
            nextVC.userData = userInfo
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
    }
    
    func saveInDatabase(userData : Item)
    {
        db.insert(userInfo: userData)
    }
    
}



extension LoginViewController
{
    //MARK: - Api Call
    func webserviceForLogin(strURL : String?,parameters:LoginReqModel) {
        
        guard let url = strURL else {return}
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        if let bodyDic = try? parameters.asDictionary(){
            let dicData = bodyDic.percentEncoded()
            request.httpBody = dicData
        }
        self.activityIndicator.isHidden = false
        
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print(json)
                            let decoder = JSONDecoder()
                            let response = try decoder.decode(LoginResponse.self, from: data)
                            self.navigateToDetailScreen(userData: response)
                        } catch {
                            print(error)
                        }
                    }
                    else
                    {
                        self.activityIndicator.isHidden = true
                        print(error?.localizedDescription ?? "")
                    }
                }.resume()
    }
}

