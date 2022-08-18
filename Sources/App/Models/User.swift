//
//  File.swift
//  
//
//  Created by NikitaSergeevich on 04/08/2022.
//

import Foundation
import Fluent
import Vapor


final class User: Model, Content {
    static let schema = "users"
    
    @ID
    var id: UUID?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "phoneNumber")
    var phoneNumber: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "grade") // user grade found on reviews, default = 0.0
    var grade: Double
    
    @Field(key: "sex")
    var sex: String
    
    @Children(for: \.$staf) // records on service to me
    var records: [Record]
    
    @Children(for: \.$client) // I am records to service
    var iAmRecords: [Record]
    
    @Children(for: \.$user) // my ads
    var ads: [Ad]
    
    @Children(for: \.$user) // what i am liked
    var likes: [Like]
    
//    @Field(key: "avatar")
//    var avatar: File?
    
    // myAds
    
    //favoriteAds
    
    init() {}
    
    init(id: UUID? = nil,
         createdAt: Date? = nil,
         updatedAt: Date? = nil,
         name: String,
         email: String,
         phoneNumber: String,
         password: String,
         grade: Double = 0.0,
         sex: String,
         records: [Record],
         iAmRecords: [Record],
         ads: [Ad],
         likes: [Like]
//         avatar: File? = nil
    ){
        
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.password = password
        self.grade = grade
        self.sex = sex
        self.records = records
        self.iAmRecords = iAmRecords
        self.ads = ads
        self.likes = likes
        
//        self.avatar = avatar
        
        
    }
    
}
