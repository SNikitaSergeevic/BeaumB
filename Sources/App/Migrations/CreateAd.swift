//
//  File.swift
//  
//
//  Created by NikitaSergeevich on 05/08/2022.
//

import Fluent


struct CreateAd: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("ads")
            .id()
            .field("createdAt", .date, .required)
            .field("updatedAt", .date, .required)
            .field("userID", .uuid, .references("users", "id"))
            .field("title", .string, .required)
            .field("description", .string, .required)
            .field("address", .string, .required)
            .field("whoClient", .string, .required)
            .field("price", .string, .required)
            .field("pictureMain", .string)
            .create()
        
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
       database.schema("ads").delete()
    }
}
