//
//  File.swift
//  
//
//  Created by NikitaSergeevich on 18/08/2022.
//

import Foundation
import Vapor
import Fluent

struct RecordController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let recordsRoute = routes.grouped("api", "records")
        
        recordsRoute.get(use: requestAllHandler)
        recordsRoute.post(use: createHandler)
        recordsRoute.get(":adID", "records",use: getRecordsAd)
//        recordsRoute.post()
        
    }
    
    func requestAllHandler(_ req: Request) throws -> EventLoopFuture<[Record]> {
        Record.query(on: req.db).all()
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<Record> {
        let record = try req.content.decode(Record.self)
        return record.save(on: req.db).map{record}
    }
    
    func getRecordsAd(_ req: Request) -> EventLoopFuture<[Record]> {
        
        Ad.find(req.parameters.get("adID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { ad in
                ad.$records.get(on: req.db)
            }
        
    }
    
    
    
}
