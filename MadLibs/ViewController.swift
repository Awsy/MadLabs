
import UIKit

class ViewController: UIViewController {

  // MARK: - Inner

  private enum ValidationError {
    case name, location, verb, age, emptyField
  }

  private struct Config {
    let name: String
    let location: String
    let verb: String
    let age: String
  }

  private struct ValidationResult {
    let config: Config?
    let errors: [ValidationError]?
  }

  // MARK: - Outlet

  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var verbTextField: UITextField!
  @IBOutlet weak var ageTextField: UITextField!

  @IBOutlet weak var numberLabel: UILabel!
  @IBOutlet weak var numberOfPetsLabel: UILabel!
  @IBOutlet weak var animalSegmentedControl: UISegmentedControl!
  @IBOutlet weak var numberSlider: UISlider!
  @IBOutlet weak var numberOfPetsStepper: UIStepper!
  @IBOutlet weak var containerView: UIView!

  // MARK: - Property

  var validation = Validation()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    [firstNameTextField, locationTextField, verbTextField, ageTextField].forEach {
      $0?.delegate = self
    }
  }

  // MARK: - Action

  @IBAction func lessOrMoreValueDidChanged(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
      containerView.isHidden = true
    } else if sender.selectedSegmentIndex == 1 {
      containerView.isHidden = false
    }
  }

  @IBAction func sliderDidChanged(_ sender: UISlider) {
    numberLabel.text = "\(Int(sender.value))"
  }

  @IBAction func stepperDidChange(_ sender: UIStepper) {
    numberOfPetsLabel.text = "\(Int(sender.value))"
  }

  @IBAction func createStoryDidTapped(_ sender: UIButton) {
    let animal = animalSegmentedControl.titleForSegment(at: animalSegmentedControl.selectedSegmentIndex)
    let story = "At the age of \(ageTextField.text!), \(firstNameTextField.text!) took a trip to \(locationTextField.text!) with \(Int(numberOfPetsStepper.value)) pets in order to \(verbTextField.text!) with a \(animal!). \(firstNameTextField.text!) decided to buy \(Int(numberSlider.value)). Now they live happily ever after"

    print(story)
    performSegue(withIdentifier: "storyScreen", sender: story)
  }

  @IBAction func createAlternativeStory(_ sender: UIButton) {
    let validationResult = validate()

    if let config = validationResult.config {
      showAlternativeStory(config: config)
    } else if let errors = validationResult.errors {
      handleValidationErrors(errors)
    }
  }

  // MARK: - Override

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let story = sender as? String else {
      print("Invalid sender.")
      return
    }

    switch segue.identifier {
      case "storyScreen":
        (segue.destination as! StoryViewController).story = story
      case "altStoryScreen":
        (segue.destination as! AltStoryView).altStory = story
      default:
        print("Undefined identifier: \(String(describing: segue.identifier))")
    }
  }

  // MARK: - Private

  private func showAlternativeStory(config: Config) {
    let animal = animalSegmentedControl.titleForSegment(at: animalSegmentedControl.selectedSegmentIndex)
    let altStory = """
      At the age of \(config.age), \(config.name) took a trip to \(config.location) with \(Int(numberOfPetsStepper.value)) pets
      in order to \(config.verb) with a \(animal!).
      \(config.name) decided to buy \(Int(numberSlider.value)). Things didn't turn out too well...
    """

    print(altStory)
    performSegue(withIdentifier: "altStoryScreen", sender: altStory)
  }

  private func handleValidationErrors(_ errors: [ValidationError]) {
    var errorMessage = ""

    errors.forEach { (error) in
      switch error {
        case .name:
          errorMessage += "Invalid Name\n"
          firstNameTextField.backgroundColor = .red
        case .location:
          errorMessage += "Invalid Location\n"
          locationTextField.backgroundColor = .red
        case .verb:
          errorMessage += "Invalid Action\n"
          verbTextField.backgroundColor = .red
        case .age:
          errorMessage += "Invalid Age\n"
          ageTextField.backgroundColor = .red
        case .emptyField:
          errorMessage = "All Fields Are Empty"
      }
    }

    let alert = UIAlertController.init(title: "Validation Error", message: errorMessage, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    alert.addAction(okAction)

    present(alert, animated: true, completion: nil)
  }

  private func validate() -> ValidationResult {
    guard
      let firstName = firstNameTextField.text,
      let location = locationTextField.text,
      let verb = verbTextField.text,
      let age = ageTextField.text else {
      return ValidationResult(config: nil, errors: [.emptyField])
    }

    var fieldErrors = [ValidationError]()

    if (!validation.validate(firstName: firstName)) {
      print("Incorrect Name")
      fieldErrors.append(.name)
    }

    if (!validation.validateLocation(locationID: location)) {
      print("Incorrect Location")
      fieldErrors.append(.location)
    }

    if (!validation.validateVerb(verbID: verb)) {
      print("Incorrect Action")
      fieldErrors.append(.verb)
    }

    if (!validation.validateAge(ageID: age)) {
      print("Incorrect age")
      fieldErrors.append(.age)
    }

    if fieldErrors.isEmpty {
      print("All fields are correct")
      let config = Config(name: firstName, location: location, verb: verb, age: age)
      return ValidationResult(config: config, errors: nil)
    }

    return ValidationResult(config: nil, errors: fieldErrors)
  }
}

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.backgroundColor = .white
  }
}

/*
 implement the DRY method to the checks i've made
 return the white background color of the field once i tap on it


 -compoleting validation
 -displaying errors in alert
 -highlighting background colors for invalid fields, back to white when everything is ok

 */


//        the below option is for modal appearance of the story:
//        let alertController = UIAlertController(title: "My Story", message: story, preferredStyle: .alert)
//        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alertController.addAction(action)
