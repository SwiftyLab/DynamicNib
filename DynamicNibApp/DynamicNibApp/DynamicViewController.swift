import UIKit

class DynamicViewController: UIViewController {
    
    @IBOutlet weak var message: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        message.text = "Welocome to dynamic page"
    }
}
