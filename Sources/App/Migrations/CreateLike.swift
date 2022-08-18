//
//  File.swift
//  
//
//  Created by NikitaSergeevich on 18/08/2022.
//

import Fluent

struct CreateLike: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("likes")
            .id()
            .field("createdAt", .date, .required)
            .field("updatedAt", .date, .required)
            .field("user", .uuid, .references("users", "id"))
            .field("ad", .uuid, .references("users", "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("likes").delete()
    }
    
    
}
