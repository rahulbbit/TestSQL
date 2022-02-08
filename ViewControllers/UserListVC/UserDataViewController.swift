//
//  UserListViewController.swift
//  TestSQL
//
//  Created by Rahul Patel on 07/02/22.
//

import UIKit

class UserDataViewController: UIViewController {

    var userData : Item?
    
    @IBOutlet var lblFirstName: UILabel!
    @IBOutlet var lblLastName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblDOB: UILabel!
    @IBOutlet var lblGender: UILabel!
    @IBOutlet var lblRoleName: UILabel!
    @IBOutlet var lblUserType: UILabel!
    @IBOutlet var lblType: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setData()
    }
    
    func setData()
    {
        guard let id = userData?.id,
              let first_name = userData?.firstName,
              let last_name = userData?.lastName,
              let email = userData?.email,
              let dob = userData?.dob,
              let gender = userData?.gender,
              let role_name = userData?.roleName,
              let user_type = userData?.userType,
              let profile_pic = userData?.profilePic,
              let is_first_time = userData?.isFirstTime else {return}
        
        
        self.lblFirstName.text = first_name
        self.lblLastName.text = last_name
        self.lblEmail.text = email
        self.lblDOB.text = dob
        self.lblGender.text = gender
        self.lblRoleName.text = role_name
        self.lblUserType.text = "\(user_type)"
    
        
        print("H")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
