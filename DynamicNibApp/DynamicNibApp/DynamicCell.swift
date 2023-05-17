import UIKit

class DynamicCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!

    func setTitle(_ text: String) {
        title.text = text
    }
}
