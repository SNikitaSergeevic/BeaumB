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
    
    var imageFolder = "ProfilePictures/"
    
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("api", "users")
        
        usersRoute.get(use: requestAllHandler)
        usersRoute.post(use: createHandler)
        usersRoute.delete(":userID", use: delete)
        usersRoute.on(.POST, ":userID", "addProfilePicture", body: .collect(maxSize: "10mb") ,use: addProfilePicturePostHandler)
        
        let basicAuthMiddleware = User.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        
        let basAuthMiddleware = Token.authenticator()
        
        let protectedLogin = usersRoute.grouped(basicAuthMiddleware, guardAuthMiddleware)
        let protectedToken = usersRoute.grouped(basAuthMiddleware)
        
//        "id": "57FEDB98-AEFA-4071-99E2-4C5141AD55A1",
//            "user": {
//                "id": "F30CB5BB-FC82-424F-8896-EF22A2C5552B"
//            },
//            "value": "zNkpP0jXnlZZPbb/T0es4A=="
        
        protectedLogin.post("login", use: loginHandlerGetToken) // get firstly token, and get self user data
        protectedToken.get(":userID", "selfUserData", use: getSelfUserData) // get self user data
        
    }
    
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        return user.save(on: req.db).map{user}
    }
    
    func requestAllHandler(_ req: Request) -> EventLoopFuture<[User.Public]> {
        User.query(on: req.db).all().convertToPublic()
    }
    
    func getHandler(_ req: Request) -> EventLoopFuture<User.Public> {
        User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound)).convertToPublic()
    }
    
    func addProfilePicturePostHandler(_ req: Request) throws -> EventLoopFuture<Response> {
        
        let data = try req.content.decode(ImageUploadData.self)
        print("1")
        return User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                let userID: UUID
                print("2")
                do{
                    userID = try user.requireID()
                } catch {
                    return req.eventLoop.future(error: error)
                }
                let name = "\(userID)-\(UUID()).jpg"
                
                                let path = req.application.directory.workingDirectory + imageFolder + name
//                imageFolder
//                req.application.directory.workingDirectory +
//                let path = "~/Users/nikitasergeevich/WorkProject/BM/BeaumB/" + imageFolder + name
                print("3")
                //                print("Dir: ", req.application.directory.workingDirectory, "Dir2: ", path)
                print("path", path)
                return req.fileio
                    .writeFile(.init(data: data.picture), at: path)
                    .flatMap {
                        print("4")
                        user.profilePicture = name
                        let redirect = req.redirect(to: "/user/\(userID)")
                        return user.save(on: req.db).transform(to: redirect)
                    }
            }
        
    }
    
    func loginHandlerGetToken(_ req: Request)  throws -> EventLoopFuture<Token> {
        let user = try req.auth.require(User.self)
        let token = try Token.generate(for: user)
        
        return token.save(on: req.db).map{ token }
    }
    
    func getSelfUserData(_ req: Request) throws -> EventLoopFuture<User> {
        User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound))
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

struct ImageUploadData: Content {
    var picture: Data
}


