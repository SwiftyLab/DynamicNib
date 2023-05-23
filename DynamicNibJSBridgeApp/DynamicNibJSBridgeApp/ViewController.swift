import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func openDynamicPage(_ sender: UIButton) {
        let vcName = "\(JSViewController.self)"
        let dynamicNibURL = URL(string: "http://127.0.0.1:8080/nibs/\(vcName)")!
        URLSession.shared.downloadTask(with: dynamicNibURL) { localURL, response, error in
            guard let localURL = localURL else { return }
            do {
                let manager = FileManager.default
                let bundle = try manager.dynamicBundle
                let nibURL = bundle.bundleURL.appending(path: "\(vcName).nib")
                try manager.moveOrReplaceItem(at: localURL, to: nibURL)
                DispatchQueue.main.async {
                    let controller = JSViewController(nibName: "\(vcName)", bundle: bundle)
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}

extension FileManager {

    var dynamicBundle: Bundle {
        get throws {
            guard let documents = urls(for: .documentDirectory, in: .userDomainMask).first
            else { throw CancellationError() }
            let bundle = documents.appending(path: "Dynamic.bundle")
            do {
                try createDirectory(at: bundle, withIntermediateDirectories: false)
            } catch let error as CocoaError where error.errorCode == 516 {
                // Do nothing
            } catch {
                throw error
            }
            guard let bundle = Bundle(url: bundle) else { throw CancellationError() }
            return bundle
        }
    }

    func moveOrReplaceItem(at srcURL: URL, to destURL: URL) throws {
        if fileExists(atPath: destURL.path) {
            let _ = try replaceItemAt(destURL, withItemAt: srcURL)
        } else {
            try moveItem(at: srcURL, to: destURL)
        }
    }
}
