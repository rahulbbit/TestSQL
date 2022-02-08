//
//  SQLiteWrapper.swift
//  TestSQL
//
//  Created by Rahul Patel on 07/02/22.
//


import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS user(Id INTEGER PRIMARY KEY,first_name TEXT,last_name TEXT,email TEXT, dob TEXT, gender TEXT, role_name TEXT, user_type INTEGER, type TEXT, profile_pic TEXT, is_first_time INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("user table created.")
            } else {
                print("user table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    /*
     "id": 1,
             "first_name": "",
             "last_name": "",
             "email": "kate@gmail.com",
             "dob": "2021-08-19",
             "gender": "",
             "role_name": "Community member",
             "user_type": 3,
             "type": "Gmail",
             "profile_pic": "",
             "is_first_time": 0
     */
    
    func insert(userInfo : Item)
    {
        guard let id = userInfo.id,
        let first_name = userInfo.firstName,
        let last_name = userInfo.lastName,
        let email = userInfo.email,
        let dob = userInfo.dob,
        let gender = userInfo.gender,
        let role_name = userInfo.roleName,
        let user_type = userInfo.userType,
        let profile_pic = userInfo.profilePic,
              let is_first_time = userInfo.isFirstTime else {return}
        
        let persons = read()
        for p in persons
        {
            if p.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO user (id, first_name, last_name,email,dob,gender,role_name,user_type,type,profile_pic,is_first_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (first_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (last_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (dob as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (gender as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (role_name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 8, Int32(user_type))
            sqlite3_bind_text(insertStatement, 9, (profile_pic as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 10, Int32(is_first_time))

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Item] {
        let queryStatementString = "SELECT * FROM user;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Item] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let first_name =  String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let last_name = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let email =  String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let dob =  String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let gender =  String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let role_name =  String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let user_type =  sqlite3_column_int(queryStatement, 7)
                let type =  String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
                let profile_pic =  String(describing: String(cString: sqlite3_column_text(queryStatement, 9)))
                let is_first_time =  sqlite3_column_int(queryStatement, 10)
                
                psns.append( Item(id: Int(id), firstName: first_name, lastName: last_name, email: email, dob: dob, gender: gender, roleName: role_name, userType: Int(user_type), type: type, profilePic: profile_pic, isFirstTime: Int(is_first_time)))
                print("Query Result:")
                print("\(id) | \(email) | \(role_name)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM user WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
