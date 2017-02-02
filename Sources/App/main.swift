import Vapor

let drop = Droplet()

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

drop.run()
