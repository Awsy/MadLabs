import UIKit

class StoryViewController: UIViewController {
  @IBOutlet weak var storyLabel: UILabel!

  var story: String = ""

  override func viewDidLoad() {
    super.viewDidLoad()
    //ToDo assign story value to label outlet
    storyLabel.text = story
  }

  @IBAction func closeModal(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
}
