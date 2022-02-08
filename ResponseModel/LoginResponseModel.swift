//
//  LoginResponseModel.swift
//  TestSQL
//
//  Created by Rahul Patel on 07/02/22.
//

import UIKit

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    let status: Bool?
    let message, token: String?
    let item: Item?
}

struct Item: Codable {
    let id: Int?
    let firstName, lastName, email, dob: String?
    let gender, roleName: String?
    let userType: Int?
    let type, profilePic: String?
    let isFirstTime: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, dob, gender
        case roleName = "role_name"
        case userType = "user_type"
        case type
        case profilePic = "profile_pic"
        case isFirstTime = "is_first_time"
    }
}

