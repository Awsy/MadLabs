import Foundation

final class Validation {
  private static let charRegEx = "[a-zA-Z0-9_.+-]*(?:[a-zA-Z][a-zA-Z0-9_.+-]*){2,}$"
  private static let intRegEx = "^[0-9]+$"
  
  func validate(firstName: String) -> Bool {
    // Length can be 2 characters min and 14 characters max.
    return validate(regEx: Validation.charRegEx, arg: firstName)
  }
  
  // I need to write the rest of the function with DRY concept
  
  func validateLocation(locationID: String) -> Bool {
    // Length must be at least 2 characters.
    let locationRegex = "[a-zA-Z0-9_.+-]*(?:[a-zA-Z][a-zA-Z0-9_.+-]*){2,}$"
    let trimmedString = locationID.trimmingCharacters(in: .whitespaces)
    let locationValid = NSPredicate(format:"SELF MATCHES %@", locationRegex)
    let isLocationValid = locationValid.evaluate(with: trimmedString)
    return isLocationValid
  }
  
  func validateVerb(verbID: String) -> Bool {
    // Length must be at least 2 characters.
    let verbRegex = "[a-zA-Z0-9_.+-]*(?:[a-zA-Z][a-zA-Z0-9_.+-]*){2,}$"
    let trimmedString = verbID.trimmingCharacters(in: .whitespaces)
    let verbValid = NSPredicate(format:"SELF MATCHES %@", verbRegex)
    let isVerbValid = verbValid.evaluate(with: trimmedString)
    return isVerbValid
  }
  
  func validateAge(ageID: String) -> Bool {
    // Length must be at least 2 digits.
    
    let trimmedString = ageID.trimmingCharacters(in: .whitespaces)
    let validateAge = NSPredicate(format: "SELF MATCHES %@", Validation.intRegEx)
    let isAgeValid = validateAge.evaluate(with: trimmedString)
    return isAgeValid
  }
  
  private func validate(regEx: String, arg: String) -> Bool {
    let trimmedString = arg.trimmingCharacters(in: .whitespaces)
    let validate = NSPredicate(format: "SELF MATCHES %@", regEx)
    return validate.evaluate(with: trimmedString)
  }
}
