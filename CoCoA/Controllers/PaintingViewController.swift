import UIKit

class PaintingViewController: UIViewController {

    var painting: Painting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = painting.name
    }
}
