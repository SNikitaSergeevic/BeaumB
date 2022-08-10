//
//  File.swift
//  
//
//  Created by NikitaSergeevich on 05/08/2022.
//

import Foundation
import Fluent
import Vapor

struct AdController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let ads = routes.grouped("api", "ads")
        
        ads.get(use: requestAllAds)
        ads.post(use: createHandler)
        
    }
    
    func requestAllAds(_ req: Request) throws -> EventLoopFuture<[Ad]> {
        Ad.query(on: req.db).all()
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<Ad> {
        let ad = try req.content.decode(Ad.self)
        return ad.save(on: req.db).map{ad}
        
    }
    
}

