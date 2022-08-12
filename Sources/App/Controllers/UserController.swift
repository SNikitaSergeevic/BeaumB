//
//  File.swift
//  
//
//  Created by NikitaSergeevich on 05/08/2022.
//

import Foundation
import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("api", "users")
        
        usersRoute.get(use: requestAllHandler)
        usersRoute.post(use: createHandler)
        usersRoute.delete(":userID", use: delete)
        
    }
    
    func requestAllHandler(_ req: Request) throws -> EventLoopFuture<[User]> {
        User.query(on: req.db).all()
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map{user}
    }
    
    func delete(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
    
}


