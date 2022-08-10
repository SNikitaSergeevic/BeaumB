import Fluent


struct CreateUser: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("createdAt", .date, .required)
            .field("updatedAt", .date, .required)
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("phoneNumber", .string, .required)
            .field("password", .string, .required)
            .field("grade", .double, .required)
            .field("sex", .string, .required)
//            .field("avatar", .data, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
    
}


//{
//    "password": "16710985",
//    "id": "B1540938-DF74-4333-8017-585F4151C164",
//    "grade": 0,
//    "email": "nikitoskasys@gmail.com",
//    "updatedAt": "2022-08-05T21:12:19Z",
//    "createdAt": "2022-08-05T21:12:19Z",
//    "sex": "male",
//    "name": "Nikita",
//    "phoneNumber": "+79539475474"
//}


