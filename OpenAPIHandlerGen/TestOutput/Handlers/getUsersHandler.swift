import Vapor

func getUsersHandler(_ req: Request) -> EventLoopFuture<Response> {
    return req.eventLoop.future(Response(status: .ok, body: .init(string: "Hello, getUsers!")))
}