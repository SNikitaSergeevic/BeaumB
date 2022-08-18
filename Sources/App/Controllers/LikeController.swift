//
//  File.swift
//  
//
//  Created by NikitaSergeevich on 18/08/2022.
//

import Foundation
import Vapor
import Fluent

struct LikeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let likesRoute = routes.grouped("api", "likes")
        
        likesRoute.get(use: requestAllHandler)
        likesRoute.post(use: createHandler)
//        recordsRoute.post()
        
    }
    
    func requestAllHandler(_ req: Request) throws -> EventLoopFuture<[Like]> {
        Like.query(on: req.db).all()
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<Like> {
        let like = try req.content.decode(Like.self)
        return like.save(on: req.db).map{like}
    }
    
    
    
}
