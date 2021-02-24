//
//  DatabaseManager.swift
//  MathiitTeams
//
//  Created by Mac on 23/02/21.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    
    private let database = Database.database().reference()
}
    // MARK: - AccountManagement

extension DatabaseManager {
    

        
    public func UserExists (with email: String , compilication: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "- ")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
            guard snapshot.value as? String != nil  else {
                compilication(true)
                return
            }
            
            compilication(true)
        })
    }
        
        /// inserts new account
        public func insertUser(with user: ChatAppUser) {
            database.child(user.emailAddress).setValue([
                "first_name": user.firstName,
                "last_name": user.lastName
                ])
        }
    }
    
    
    
    struct ChatAppUser {
        let firstName: String
        let lastName: String
        let emailAddress: String
        
        var safeEmail:String {
            var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "- ")
            return safeEmail
        }
        
        //let ProfilePic: String

    
    

}
