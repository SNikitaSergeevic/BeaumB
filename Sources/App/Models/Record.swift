//
//  File.swift
//  
//
//  Created by NikitaSergeevich on 16/08/2022.
//

import Foundation
import Fluent
import Vapor

final class Record: Model, Content {
    
    static let schema = "records"
    
    @ID
    var id: UUID?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    @Parent(key: "adID")
    var ad: Ad // ad to which record
    
    @Parent(key: "clientID")
    var client: User
    
    @Parent(key: "stafID")
    var staf: User
    
    @Field(key: "meetDate")
    var meetDate: Date?
    
    @Field(key: "meetAdress")
    var meetAdress: String
    
    init(){}
    
    init(id: UUID? = nil,
         createdAt: Date? = nil,
         updatedAt: Date? = nil,
         adID: Ad.IDValue,
         client: User.IDValue,
         staf: User.IDValue,
         meetDate: Date? = nil,
         meetAdress: String
    ){
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.$ad.id = adID
        self.$client.id = client
        self.$staf.id = staf
        self.meetAdress = meetAdress
    }
    
    
}
