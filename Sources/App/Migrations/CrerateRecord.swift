//
//  File.swift
//  
//
//  Created by NikitaSergeevich on 18/08/2022.
//

import Fluent

struct CreateRecord: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("records")
            .id()
            .field("createdAt", .date, .required)
            .field("updatedAt", .date, .required)
            .field("meetDate", .date, .required)
            .field("meetAdress", .string, .required)
            .field("adID", .uuid, .references("ads", "id"))
            .field("clientID", .uuid, .references("users", "id"))
            .field("stafID", .uuid, .references("users", "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("records").delete()
    }
    
    
}
