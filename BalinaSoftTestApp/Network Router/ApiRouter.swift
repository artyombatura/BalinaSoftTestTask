//
//  ApiRouter.swift
//  BalinaSoftTestApp
//
//  Created by Artyom on 2/14/20.
//  Copyright © 2020 Artyom. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum ApiRouter {
    
    // All active cases
    case Get(page: Int)
    case Post(id: String, name: String, image: Data)
    
    
    // Calculated var's
    private var baseUrl: String {
        return "https://junior.balinasoft.com"
    }
    
    private var method: HTTPMethod {
        switch self {
        case .Get:
            return .get
        case .Post:
            return .post
        }
    }
    
//    private var parameters: Parameters? {
//
//        switch self {
//        case .Get(let page):
//            return ["page" : page]
//
//        case .Post(let id, let name, let image):
//            return ["name" : name,
//                    "typeId" : id,
//                    "photo" : image]
//        }
//    }
    
    private var parameters: Parameters {

        switch self {
        case .Get(let page):
            return ["page" : page]

        case .Post(let id, let name, let image):
            return ["name" : name,
                    "typeId" : id]
        }
    }
    
    private var fullUrl: String {
        
        switch self {
        case .Get(_):
            return baseUrl + "/api/v2/photo/type"
        case .Post(_):
            return baseUrl + "/api/v2/photo"
        }
    }
    
    func getRequest(completion: @escaping ([Developer]?)->()) {
        
        
        AF.request(fullUrl, method: method, parameters: parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON { (json) in
            
            switch json.result {
            case .success(let value):
                
                var developers = [Developer]()
            
                if let developersArray = Developer.getArrayFromJson(from: value) {

                    developers = developersArray
                    
                    completion(developers)
                } else { print("FAILURE WHILE GETTING ARRAY FROM JSON") }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func postRequest(imageData: Data) {
        
        
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: "photo", fileName: "photo/jpeg", mimeType: "photo/jpeg")
            
            for (key, value) in self.parameters {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
        }, to: self.fullUrl).responseJSON { (json) in

            switch json.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }

    
    
    }
    
}
