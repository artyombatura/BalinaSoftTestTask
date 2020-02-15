//
//  DeveloperModel.swift
//  BalinaSoftTestApp
//
//  Created by Artyom on 2/14/20.
//  Copyright © 2020 Artyom. All rights reserved.
//

import Foundation

class Developer {
    
    public var name: String?
    public var id: String?
    
    init(jsonObject: [String:Any]) {
        let name = jsonObject["name"] as? String
        let id = jsonObject["id"] as? Int
        
        if let id = id {
            let idString = String(id)
            
            self.name = name
            self.id = idString
        }
        
    }
    
    
    static func getArrayFromJson(from json: Any) -> [Developer]? {
        
        var developersArray = [Developer]()
        
        // Casting json to Json Dictionary
        guard let jsonDict = json as? [String:Any] else { return nil }

        // Content contains array of developers information
        let content = jsonDict["content"]
        
        // Content as array of dicts
        guard let objectsInContent = content as? Array<[String:Any]> else { return nil }
        
        for object in objectsInContent {
            
            let developer = Developer(jsonObject: object)

            developersArray.append(developer)
        }
        
        print("Catch array, size: \(developersArray.count)")
        
        return developersArray
    }
}
