import Vapor
import VaporPostgreSQL

let drop = Droplet(
    preparations: [Acronym.self],
    providers: [VaporPostgreSQL.Provider.self]
)

//drop.get { req in
//    return try drop.view.make("welcome", [
//    	"message": drop.localization[req.lang, "welcome", "title"]
//    ])
//}
//
//drop.resource("posts", PostController())

//MARK:
//MARK: Getting Started
drop.get { request in
    return "Hello World!"
}

drop.get("hello") { request in
    return try JSON(node: [
        "message": "Hello Again!"
        ])
}

drop.get("hello", "there") { request in
    return try JSON(node: [
        "message": "Hello There!"
        ])
}

drop.get("beers", Int.self) { request, beers in
    return try JSON(node: [
        "message": "One down, \(beers - 1) left..."
        ])
}

drop.post("post") { request in
    guard let name = request.data["name"]?.string else {
        throw Abort.badRequest
    }
    return try JSON(node: [
        "message": "Hello, \(name)!"
        ])
}

//MARK:
//MARK: Templating with Leaf
drop.get("template") { request in
    return try drop.view.make("hello", Node(node: ["name": "anyone"]))
}

drop.get("template", String.self) { request, name in
    return try drop.view.make("hello", Node(node: ["name": name]))
}

drop.get("template-collection") { request in
    let users = try ["Andrew", "Jacy", "Benben"].makeNode()
    return try drop.view.make("hello_loop", Node(node: ["users": users]))
}

drop.get("template-collection-dictionary") { request in
    let users = try [
        ["name": "Andrew", "email": "andrew@gmail.com"].makeNode(),
        ["name": "Jacy", "email": "jacy@gmail.com"].makeNode(),
        ["name": "Benben", "email": "benebn@gmail.com"].makeNode()
        ].makeNode()
    return try drop.view.make("hello_loop_dic", Node(node: ["users": users]))
}

drop.get("template-ifelse") { request in
    guard let sayHello = request.data["sayHello"]?.bool else {
        throw Abort.badRequest
    }
    return try drop.view.make("hello_ifelse", Node(node: ["sayHello": sayHello.makeNode()]))
}

//MARK:
//MARK: Configuring a Database

//drop.get("version") { request in
//    if let db = drop.database?.driver as? PostgreSQLDriver {
//        let version = try db.raw("SELECT version()")
//        return try JSON(node: version)
//    } else {
//        return "No db connection"
//    }
//}

//MARK:
//MARK: Persisting Models
//drop.get("model") { request in
//    let acronym = Acronym(short: "AFK", long: "Away From Keyboard")
//    return try acronym.makeJSON()
//}

drop.get("test") { request in
    var acronym = Acronym(short: "BRB", long: "Be Right Back")
    try acronym.save()
    return try JSON(node: Acronym.all().makeNode())
}

//MARK:
//MARK: CRUD Database Options
//MARK: Create
drop.get("new") { request in
    var acronym = try Acronym(node: request.json)
    try acronym.save()
    return acronym
}

//MARK: Read
drop.get("all") { request in
    return try JSON(node: Acronym.all().makeNode())
}

drop.get("first") { request in
    return try JSON(node: Acronym.query().first()?.makeNode())
}

drop.get("afks") { request in
    return try JSON(node: Acronym.query().filter("short", "AFK").all().makeNode())
}

drop.get("not-afks") { request in
    return try JSON(node: Acronym.query().filter("short", .notEquals,"AFK").all().makeNode())
}

//MARK: Update
drop.get("update") { request in
    guard var first = try Acronym.query().first(),
        let long = request.data["long"]?.string else {
            throw Abort.badRequest
    }
    first.long = long
    try first.save()
    return first
}

//MARK: Delete
drop.get("delete-afks") { request in
    let query = try Acronym.query().filter("short", "AFK")
    try query.delete()
    return try JSON(node: Acronym.all().makeNode())
}

//MARK:
//MARK: Deploying to Heroku with PostgreSQL
// $heroku addons:create heroku-postgresql:hobby-dev

// $vi Procfile
// $web: App --env=production --workdir="./"
// $web: App --env=production --workdir=./ --config:servers.default.port=$PORT —config:postgresql.url=$DATABASE_URL

//MARK:
//MARK: Basic Controllers
let basic = BasicController()
basic.addRoutes(drop: drop)

drop.run()
