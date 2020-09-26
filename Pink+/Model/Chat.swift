//
//  Chat.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 26/09/20.
//

struct Chat {
    
    var users: [String]
        
    var dictionary: [String: Any] {
            return ["users": users]
    }
    
}

extension Chat {
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
}
