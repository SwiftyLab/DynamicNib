import UIKit

class DynamicViewController: UIViewController {
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        message.text = "Welocome to dynamic page"

        let dynamicNibURL = URL(string: "http://127.0.0.1:8080/nibs/\(DynamicCell.self)")!
        URLSession.shared.downloadTask(with: dynamicNibURL) { localURL, response, error in
            guard let localURL = localURL else { return }
            do {
                let manager = FileManager.default
                let bundle = try manager.dynamicBundle
                let nibURL = bundle.bundleURL.appending(path: "\(DynamicCell.self).nib")
                try manager.moveOrReplaceItem(at: localURL, to: nibURL)
                DispatchQueue.main.async {
                    let nib = UINib(nibName: "\(DynamicCell.self)", bundle: bundle)
                    self.tableView.register(nib, forCellReuseIdentifier: "\(DynamicCell.self)")
                    self.tableView.dataSource = self
                    self.tableView.delegate = self
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}

extension DynamicViewController: UITableViewDataSource, UITableViewDelegate {
    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return formatter
    }()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(DynamicCell.self)", for: indexPath) as! DynamicCell
        cell.setTitle(Self.formatter.string(from: NSNumber(integerLiteral: indexPath.row + 1))!)
        return cell
    }
}
