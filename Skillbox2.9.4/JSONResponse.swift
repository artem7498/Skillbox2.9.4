//
//  JSONResponse.swift
//  Skillbox2.9.4
//
//  Created by Артём on 2/3/21.
//

import Foundation

struct Friends: Decodable {
    var name: String?
    var lastName: String?
    
    init?(data: NSDictionary){
        guard let name = data["first_name"] as? String,
            let lastName = data["last_name"] as? String else { return nil }

        self.name = name
        self.lastName = lastName
        
    }
}
