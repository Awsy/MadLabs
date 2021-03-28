
import UIKit


class AltStoryView: UIViewController {
    
    @IBOutlet weak var altStoryLabel: UILabel!
    
    var altStory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        altStoryLabel.text = altStory
    }
    
    @IBAction func closeAltModal(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
