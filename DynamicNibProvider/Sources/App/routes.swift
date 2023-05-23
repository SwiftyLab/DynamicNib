import Foundation
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    let nibGroup = app.grouped("nibs")
    let resourceURL = Bundle.module.resourceURL!
    nibGroup.get { req async throws -> [String] in
        let manager = FileManager.default
        return try manager.contentsOfDirectory(atPath: resourceURL.path)
            .filter { $0.hasSuffix(".nib") }
    }
    nibGroup.get(":name") { req async throws in
        let nibURL = resourceURL.appending(path: "\(req.parameters.get("name")!).nib")
        return req.fileio.streamFile(at: nibURL.path)
    }

    let jsGroup = app.grouped("js")
    let jsResourceURL = Bundle.module.resourceURL!.appending(path: "Js")
    jsGroup.get { req async throws -> [String] in
        let manager = FileManager.default
        return try manager.contentsOfDirectory(atPath: jsResourceURL.path)
            .filter { $0.hasSuffix(".js") }
    }
    jsGroup.get(":name") { req async throws in
        let jsURL = jsResourceURL.appending(path: "\(req.parameters.get("name")!).js")
        return req.fileio.streamFile(at: jsURL.path)
    }
}
