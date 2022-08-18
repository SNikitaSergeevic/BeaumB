//
//  File.swift
//  
//
//  Created by NikitaSergeevich on 04/08/2022.
//

import Foundation
import Fluent
import Vapor


final class Ad: Model, Content {
    static let schema = "ads"
    
    @ID(key: "id")
    var id: UUID?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updateAt: Date?
    
    @Parent(key: "userID")
    var user: User
    
    @Children(for: \.$ad) // records on current ad
    var records: [Record]
    
    @Children(for: \.$ad) // likes on ads
    var likes: [Like]
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "address")
    var address: String
    
    //main picture File?
    
    //other picture File?
    
    //category many-to-many
    
    //type many-to-many
    
    //meetPoint: salon; home; in client. enum???
    
    @Field(key: "whoClient")
    var whoClient: String
    
    @Field(key: "price")
    var price: String
    
    
    
    
    init(){}
    
    init( id: UUID? = nil,
          createdAt: Date? = nil,
          updatedAt: Date? = nil,
          userID: User.IDValue,
          records: [Record],
          likes: [Like],
          title: String,
          description: String,
          address: String,
          whoClient: String,
          price: String
    ){
        self.id = id
        self.createdAt = createdAt
        self.updateAt = updatedAt
        self.$user.id = userID
        self.records = records
        self.likes = likes
        self.title = title
        self.description = description
        self.address = address
        self.whoClient = whoClient
        self.price = price
    }
    
}


