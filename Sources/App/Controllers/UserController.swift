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

        // user change routes
        usersRoute.get(use: getRequestAllHandler)
        usersRoute.get(":userID", "adsUser", use: getAdsUser)
        usersRoute.get(":userID", "profilePicture", use: getUserProfilePicture)
        usersRoute.on(.POST, ":userID", "addProfilePicture", body: .collect(maxSize: "10mb") ,use: postAddProfilePicture)
        usersRoute.post(use: postCreateHandler)
        usersRoute.delete(":userID","delete", use: delete)

        let basicAuthMiddleware = User.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        
        let basAuthMiddleware = Token.authenticator()
        
        let protectedLogin = usersRoute.grouped(basicAuthMiddleware, guardAuthMiddleware)
        let protectedToken = usersRoute.grouped(basAuthMiddleware)

        protectedToken.get(":userID", "selfUserData", use: getSelfUserData) // get self user data
        protectedLogin.post("login", use: postLoginHandlerGetToken) // get firstly token, and get self user data
        protectedToken.put(":userID", "updateName", use: putUpdateUserName)
        protectedToken.put(":userID", "updateDescription", use: putUpdateUserDescription)
    }
    
    
    // request public user
    func getRequestAllHandler(_ req: Request) -> EventLoopFuture<[User.Public]> {
        User.query(on: req.db).all().convertToPublic()
    }
    // request public user with userID
    func getHandler(_ req: Request) -> EventLoopFuture<User.Public> {
        User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound)).convertToPublic()
    }
    // get self user data with token
    func getSelfUserData(_ req: Request) throws -> EventLoopFuture<User> {
        User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound))
    }

    func getAdsUser(_ req: Request) throws -> EventLoopFuture<[Ad]> {
        User.find(req.parameters.get("userID"), on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap { user in
            user.$ads.get(on: req.db)
        }
    }

    func getUserProfilePicture(_ req: Request) -> EventLoopFuture<Response> {
        User.find(req.parameters.get("userID"), on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMapThrowing { user in
            guard let filename = user.profilePicture else {throw Abort(.notFound)}
            let path = req.application.directory.workingDirectory + imageFolder + filename
            return req.fileio.streamFile(at: path)
        }
        
    }

    //POST
    // update user picture with userID
    func postAddProfilePicture(_ req: Request) throws -> EventLoopFuture<Response> {
       
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
    // create user
    func postCreateHandler(_ req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        return user.save(on: req.db).map{user}
    }
    // user login and get token
    func postLoginHandlerGetToken(_ req: Request)  throws -> EventLoopFuture<Token> {
        let user = try req.auth.require(User.self)
        let token = try Token.generate(for: user)
        
        return token.save(on: req.db).map{ token }
    }

    //PUT
    func putUpdateUserName(_ req: Request) throws -> EventLoopFuture<User> {
        print(req.content)
        let updatedUser = try req.content.decode(User.self)
        return User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { user in
                user.name = updatedUser.name
                return user.save(on: req.db).map {
                    user 
                }
            }
    }

    func putUpdateUserDescription(_ req: Request) throws -> EventLoopFuture<User> {
        let updatedUser = try req.content.decode(User.self)
        return User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { user in
                user.description = updatedUser.description
                return user.save(on: req.db).map {
                    user
                }
        }
               
    }

    // DELETE
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


