enum RequestType { GET, POST, PUT, DELETE, PATCH, MULTIPART_POST ,MULTIPART_PUT}

enum Flavor { prod, stage, dev }

enum LogMode { debug, live }

enum AccountType { personal, business }

enum BusinessMainActivity { exportGoods, exportService, others }

enum BusinessAccountSetupSteps { businessEntity, businessInformation, transactionAndPaymentPreferences, setPassword }

enum KycVerificationSteps {
  panVerification,
  companyIncorporationVerification,
  annualTurnoverDeclaration,
  iecVerification,
  aadharPanVerification,
  contactInformation,
  registeredOfficeAddress,
  bankAccountLinking,
  beneficialOwnershipVerification,
  businessDocumentsVerification,
}

enum PersonalEKycVerificationSteps {
  identityVerification,
  panDetails,
  residentialAddress,
  annualTurnoverDeclaration,
  iecVerification,
  bankAccountLinking,
  // selfie,
}

enum IDVerificationDocType { aadharCard, passport, drivingLicense, voterID }

enum PersonalAccountSetupSteps { personalEntity, personalInformation, personalTransactions, setPassword }

enum LoginType { phone, email }

enum InputType {
  name,
  text,
  email,
  password,
  confirmPassword,
  newPassword,
  phoneNumber,
  digits,
  decimalDigits,
  multiline,
}

enum ImageType { svg, png, network, file, lottie, unknown }

enum DirectorKycSteps { panDetails, aadharDetails }

enum OtherDirectorKycSteps { panDetails, aadharDetails }

enum BeneficialOwnerKycSteps { panDetails, addressDetails }

enum TransactionStatus { received, failed }

enum FilterStatus { active, inactive, locked }
