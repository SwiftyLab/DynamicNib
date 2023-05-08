import Foundation
import PackagePlugin

struct CustomError: Error {
    let msg: String
}

@main
struct BuildNib: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard let target = target as? SourceModuleTarget else { return [] }
        let manager = FileManager.default
        let xibs = target.directory.appending(subpath: "Xibs")
        let items = try manager.contentsOfDirectory(atPath: xibs.string)
        return items.map { item in
            let input = xibs.appending(subpath: item)
            let base = input.stem
            let output = context.pluginWorkDirectory.appending(subpath: "\(base).nib")
            return .buildCommand(
                displayName: "Building nib for xib \(base)",
                executable: .init("/usr/bin/xcrun"),
                arguments: [
                    "ibtool",
                    "--compile",
                    output.string,
                    input.string
                ],
                inputFiles: [input],
                outputFiles: [output]
            )
        }
    }
}
