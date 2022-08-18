//
//  File.swift
//  
//
//  Created by NikitaSergeevich on 16/08/2022.
//

import Foundation
import Fluent
import Vapor
import OpenGL

final class Like: Model, Content {
    static let schema = "likes"
    
    @ID(key: "id")
    var id: UUID?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    @Parent(key: "userID") // who liked ad
    var user: User
    
    @Parent(key: "adID") // liked ads
    var ad: Ad
    
    init(){}
    
    init(id: UUID? = nil,
         createdAt: Date? = nil,
         updatedAt: Date? = nil,
         userID: User.IDValue,
         adID: Ad.IDValue){
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.$user.id = userID
        self.$ad.id = adID
    }
    
}
