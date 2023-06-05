import UIKit
import JavaScriptCore

@objc
protocol UIViewExports: JSExport { }

@objc
protocol UILabelExports: JSExport {
    var text: String? { get set }
}

extension UILabel: UILabelExports { }
