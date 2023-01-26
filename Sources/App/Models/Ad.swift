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
    
    //other picture File?
    
    //category many-to-many
    
    //type many-to-many
    
    //meetPoint: salon; home; in client. enum???
    
    @Field(key: "whoClient")
    var whoClient: String
    
    @Field(key: "price")
    var price: String
    
    @OptionalField(key: "pictureMain")
    var pictureMain: String?
    
    
    
    init(){}
    
    init( id: UUID? = nil,
          createdAt: Date? = nil,
          updateAt: Date? = nil,
          userID: User.IDValue,
          records: [Record],
          likes: [Like],
          title: String,
          description: String,
          address: String,
          whoClient: String,
          price: String,
          pictureMain: String? = nil
    ){
        self.id = id
        self.createdAt = createdAt
        self.updateAt = updateAt
        self.$user.id = userID
        self.records = records
        self.likes = likes
        self.title = title
        self.description = description
        self.address = address
        self.whoClient = whoClient
        self.price = price
        self.pictureMain = pictureMain
    }

    final class Short: Content {
        var id: UUID?
        var createdAt: Date? = nil
        var userID: User.IDValue
        var title: String
        var address: String
        var price: String
        var pictureMain: String?
        init(id: UUID?,
            createdAt: Date?, 
            userID: User.IDValue, 
            title: String, 
            address: String, 
            price: String, 
            pictureMain: String?) {
            self.id = id
            self.createdAt = createdAt
            self.userID = userID
            self.title = title
            self.address = address
            self.price = price
            self.pictureMain = pictureMain
        }
    }
    
}

extension Ad {
    func convertAdToShort() -> Ad.Short {
        return Ad.Short(id: id, 
                        createdAt: createdAt, 
                        userID: $user.id, 
                        title: title, 
                        address: address, 
                        price: price, 
                        pictureMain: pictureMain)
    }
}

extension EventLoopFuture where Value: Ad {
    func convertAdToShort() -> EventLoopFuture<Ad.Short> {
        return self.map{ ad in
            return ad.convertAdToShort()
        }
    }
}

extension Collection where Element: Ad {
    func convertAdToShort() -> [Ad.Short] {
        return self.map{$0.convertAdToShort()}
    }
}

extension EventLoopFuture where Value == Array<Ad> {
    func convertAdToShort() -> EventLoopFuture<[Ad.Short]> {
        return self.map{$0.convertAdToShort()}
    }
}


