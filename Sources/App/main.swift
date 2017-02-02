import Vapor

let drop = Droplet()

//drop.get { req in
//    return try drop.view.make("welcome", [
//    	"message": drop.localization[req.lang, "welcome", "title"]
//    ])
//}
//
//drop.resource("posts", PostController())

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

drop.run()
