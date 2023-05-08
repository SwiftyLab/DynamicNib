import Foundation
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    let group = app.grouped("nibs")
    let resourceURL = Bundle.module.resourceURL!
    group.get { req async throws -> [String] in
        let manager = FileManager.default
        return try manager.contentsOfDirectory(atPath: resourceURL.path)
            .filter { $0.hasSuffix(".nib") }
    }
    group.get(":name") { req async throws in
        let nibURL = resourceURL.appending(path: "\(req.parameters.get("name")!).nib")
        return req.fileio.streamFile(at: nibURL.path)
    }
}
