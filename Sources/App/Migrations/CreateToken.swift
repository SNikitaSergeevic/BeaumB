//
//  File.swift
//  
//
//  Created by NikitaSergeevich on 01/11/2022.
//

import Fluent

struct CreateToken: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tokens")
            .id()
            .field("value", .string, .required)
            .field("userID", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("tokens").delete()
    }
}

