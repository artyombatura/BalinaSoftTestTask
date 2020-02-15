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
    
    
    // Calculated var's
    private var baseUrl: String {
        return "https://junior.balinasoft.com"
    }
    
    private var method: HTTPMethod {
        switch self {
        case .Get:
            return .get
        }
    }
    
    private var parameters: Parameters? {
        
        switch self {
        case .Get(let page):
            return ["page":page]
        }
    }
    
    private var fullUrl: String {
        
        switch self {
        case .Get(_):
            return baseUrl + "/api/v2/photo/type"
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
    
    
}
