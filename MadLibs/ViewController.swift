
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var validation = Validation()
	
	enum Errors {
		case name, location, verb, age, emptyField
	}

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
    
    @IBAction func lessOrMoreValueDidChanged(_ sender: UISegmentedControl) {
        // If user taps on less -> hide the container view
        if sender.selectedSegmentIndex == 0 {
            containerView.isHidden = true
        // If user taps on more -> show the container view
        } else if sender.selectedSegmentIndex == 1 {
            containerView.isHidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		
    }

	
    @IBAction func sliderDidChanged(_ sender: UISlider) {
        // Update the label on the left of the slider base on the current value
        numberLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func stepperDidChange(_ sender: UIStepper) {
        // Update the label on the left of the stepper base on the current value
        numberOfPetsLabel.text = "\(Int(sender.value))"
        
    }
    @IBAction func createStoryDidTapped(_ sender: UIButton) {
        // At the age of 21, Bob took a trip to Austin with 3 pets in order to sing with a moose. Bob decided to buy 42. Now they live happily every after.
        let animal = animalSegmentedControl.titleForSegment(at: animalSegmentedControl.selectedSegmentIndex)
        let story = "At the age of \(ageTextField.text!), \(firstNameTextField.text!) took a trip to \(locationTextField.text!) with \(Int(numberOfPetsStepper.value)) pets in order to \(verbTextField.text!) with a \(animal!). \(firstNameTextField.text!) decided to buy \(Int(numberSlider.value)). Now they live happily ever after"
        print(story)
        
        self.performSegue(withIdentifier: "storyScreen", sender: story)
        
    }
    
    
    @IBAction func createAlternativeStory(_ sender: UIButton) {
        // At the age of 21, Bob took a trip to Austin with 3 pets in order to sing with a moose. Bob decided to buy 42. Things didn't turn out too well....
		let validationResult = validate()
		if let config = validationResult.config {
		
        let animal = animalSegmentedControl.titleForSegment(at: animalSegmentedControl.selectedSegmentIndex)
		let altStory = "At the age of \(config.age), \(config.name) took a trip to \(config.location) with \(Int(numberOfPetsStepper.value)) pets in order to \(config.verb) with a \(animal!). \(firstNameTextField.text!) decided to buy \(Int(numberSlider.value)). Things didn't turn out too well..."
        print(altStory)
        
        self.performSegue(withIdentifier: "altStoryScreen", sender: altStory)
		
	} else if let errors = validationResult.errors {
		var errorMessage = ""
		errors.forEach { (error) in
			switch error {
				case .name:
					errorMessage += "Invalid Name"
					firstNameTextField.backgroundColor = .red
				case .location:
					errorMessage += "Invalid Location"
					locationTextField.backgroundColor = .red
				case .verb:
					errorMessage = "Invalid Action"
					verbTextField.backgroundColor = .red
				case .age:
					errorMessage = "Invalid Age"
					ageTextField.backgroundColor = .red
				case .emptyField:
					errorMessage = "All Fields Are Empty"
			}
			
			func textFieldDidBeginEditing(_ textField: UITextField) {
				
				if textField == firstNameTextField {
					firstNameTextField.backgroundColor = .white
				} else if textField == locationTextField {
					locationTextField.backgroundColor = .white
				} else if textField == verbTextField {
					verbTextField.backgroundColor = .white
				} else if textField == ageTextField {
					ageTextField.backgroundColor = .white
				} else {
					print("All Fields Are Empty")
				}
				
			}
		}
			let alert = UIAlertController.init(title: "Validation Error", message: errorMessage, preferredStyle: .alert)
			let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
			alert.addAction(okAction)
			self.present(alert, animated: true, completion: nil)
		}
		
    }
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "storyScreen", let story = sender as? String {
            let vc = segue.destination as! StoryViewController
            vc.story = story
        } else if segue.identifier == "altStoryScreen", let altStory = sender as? String {
            
            let altVc = segue.destination as! AltStoryView
            altVc.altStory = altStory
        } else {
            return
        }
    }
	
	private	struct Config {
		let name: String
		let location: String
		let verb: String
		let age: String
	}
	
	private struct ValidationResult {
		let config: Config?
		let errors: [Errors]?
	}
    
	private func validate() -> ValidationResult{
		
		var fieldErrors = [Errors]()
		
		guard let firstName = firstNameTextField.text, let location = locationTextField.text, let verb = verbTextField.text, let age = ageTextField.text else {
			return ValidationResult(config: nil, errors: [.emptyField])
		}
		
		
		let firstNameValid = self.validation.validate(firstName: firstName)
		if (firstNameValid == false) {
			print("Incorrect Name")
			fieldErrors.append(.name)
		}
		
		let locationValid = self.validation.validateLocation(locationID: location)
		if (locationValid == false) {
			print("Incorrect Location")
			fieldErrors.append(.location)
		}
		
		let verbValid = self.validation.validateVerb(verbID: verb)
		if (verbValid == false) {
			print("Incorrect Action")
			fieldErrors.append(.verb)
		}
		
		let ageValid = self.validation.validateAge(ageID: age)
		if (ageValid == false) {
			print("Incorrect age")
			fieldErrors.append(.age)
		}
		
		if fieldErrors.isEmpty {
			print("All fields are correct")
			return ValidationResult(config: Config(name: firstName, location: location, verb: verb, age: age), errors: nil)
		} else {
			return ValidationResult(config: nil, errors: fieldErrors)
		}
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
