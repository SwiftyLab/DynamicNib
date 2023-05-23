import UIKit
import JavaScriptCore

@objc
protocol JSViewControllerExport: JSExport {
    var outlets: [String: AnyObject] { get }
}

class JSViewController: UIViewController, JSViewControllerExport {

    lazy var context: JSContext = {
        let context = JSContext(virtualMachine: AppDelegate.jsvm)!
        context.name = "\(self)"
        #if DEBUG
        context.isInspectable = true
        #endif
        let window: @convention(block) () -> JSViewController = { [weak self] in return self! }
        context.setObject(window, forKeyedSubscript: "window" as NSString)
        return context
    }()

    // @IBOutlet weak var countLabel: UILabel!
    @objc
    var outlets: [String: AnyObject] = [:]

    override func value(forUndefinedKey key: String) -> Any? {
        return outlets[key] ?? super.value(forUndefinedKey: key)
    }

    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        guard let value = value as? AnyObject else {
            super.setValue(value, forUndefinedKey: key)
            return
        }
        outlets[key] = value
    }

    // @IBAction func actionAdd(_ sender: UIButton) { }
    // @IBAction func actionSubtract(_ sender: UIButton) { }
    override class func resolveInstanceMethod(_ sel: Selector!) -> Bool {
        guard sel.description.starts(with: "action") else { return super.resolveInstanceMethod(sel) }
        let types = sel.description.reduce(into: "v@:") { result, char in
            guard char == ":" else { return }
            result.append("@")
        }
        switch types.count {
        case 3:
            let dynamicMethodIMP: @convention(c) (JSViewController, Selector) -> Void = dynamicMethod0
            class_addMethod(Self.self, sel, unsafeBitCast(dynamicMethodIMP, to: IMP.self), types)
        case 4:
            let dynamicMethodIMP: @convention(c) (JSViewController, Selector, AnyObject) -> Void = dynamicMethod1
            class_addMethod(Self.self, sel, unsafeBitCast(dynamicMethodIMP, to: IMP.self), types)
        case 5:
            let dynamicMethodIMP: @convention(c) (JSViewController, Selector, AnyObject, AnyObject) -> Void = dynamicMethod2
            class_addMethod(Self.self, sel, unsafeBitCast(dynamicMethodIMP, to: IMP.self), types)
        case 6:
            let dynamicMethodIMP: @convention(c) (JSViewController, Selector, AnyObject, AnyObject, AnyObject) -> Void = dynamicMethod3
            class_addMethod(Self.self, sel, unsafeBitCast(dynamicMethodIMP, to: IMP.self), types)
        default:
            return super.resolveInstanceMethod(sel)
        }
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let name = "\(Self.self)"
        let dynamicNibURL = URL(string: "http://127.0.0.1:8080/js/\(name)")!
        URLSession.shared.downloadTask(with: dynamicNibURL) { localURL, response, error in
            guard let localURL = localURL else { return }
            do {
                let script = try String(contentsOf: localURL, encoding: .utf8)
                DispatchQueue.main.async { self.context.evaluateScript(script) }
            } catch {
                print(error)
            }
        }.resume()
    }
}

func dynamicMethod(_ self: JSViewController, _ sel: Selector, _ args: AnyObject...) {
    let action = String(sel.description.split(separator: ":").first!)
    self.context.objectForKeyedSubscript("controller").invokeMethod(action, withArguments: args)
}

func dynamicMethod0(_ self: JSViewController, _ sel: Selector) {
    dynamicMethod(self, sel)
}

func dynamicMethod1(_ self: JSViewController, _ sel: Selector, _ arg1: AnyObject) {
    dynamicMethod(self, sel, arg1)
}

func dynamicMethod2(_ self: JSViewController, _ sel: Selector, _ arg1: AnyObject, _ arg2: AnyObject) {
    dynamicMethod(self, sel, arg1, arg2)
}

func dynamicMethod3(_ self: JSViewController, _ sel: Selector, _ arg1: AnyObject, _ arg2: AnyObject, _ arg3: AnyObject) {
    dynamicMethod(self, sel, arg1, arg2, arg3)
}
