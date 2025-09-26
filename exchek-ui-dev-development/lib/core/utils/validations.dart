
class ExchekValidations {
  ExchekValidations._();

  // =============================================================================
  // BASIC VALIDATIONS
  // =============================================================================

  /// Validates required fields
  static String? validateRequired(
    String? value, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    // final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates business email format
  static String? validateBusinessEmail(String? value) {
    final basicEmailValidation = validateEmail(value);
    if (basicEmailValidation != null) return basicEmailValidation;

    // Additional business email validations can be added here
    return null;
  }

  /// Validates email address or user ID
  /// Automatically detects whether input is email (contains @) or user ID
  static String? validateEmailOrUserId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email Address / User ID is required';
    }

    final trimmedValue = value.trim();

    // Check minimum length
    if (trimmedValue.length < 3) {
      return 'Email Address / User ID must be at least 3 characters';
    }

    // Check maximum length
    if (trimmedValue.length > 100) {
      return 'Email Address / User ID must not exceed 100 characters';
    }

    // Check if it contains @ symbol (likely an email)
    if (trimmedValue.contains('@')) {
      return _validateEmailFormat(trimmedValue);
    } else {
      return _validateUserIdFormat(trimmedValue);
    }
  }

  /// Validates input as either a valid email or valid Indian mobile number
  static String? validateEmailOrMobileNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email or Mobile number is required';
    }

    final trimmed = value.trim();

    if (trimmed.contains('@')) {
      return validateEmail(trimmed);
    } else {
      return validateMobileNumber(trimmed);
    }
  }

  /// Private helper method to validate email format
  static String? _validateEmailFormat(String email) {
    // Use existing email validation logic
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    // Additional email validation checks
    final parts = email.split('@');
    if (parts.length != 2) {
      return 'Please enter a valid email address';
    }

    final localPart = parts[0];
    final domainPart = parts[1];

    // Check local part length (max 64 characters as per RFC)
    if (localPart.isEmpty || localPart.length > 64) {
      return 'Please enter a valid email address';
    }

    // Check domain part
    if (domainPart.isEmpty || !domainPart.contains('.')) {
      return 'Please enter a valid email address';
    }

    // Check for consecutive dots
    if (email.contains('..')) {
      return 'Please enter a valid email address';
    }

    // Check for leading/trailing dots in local part
    if (localPart.startsWith('.') || localPart.endsWith('.')) {
      return 'Please enter a valid email address';
    }

    return null; // Valid email
  }

  /// Private helper method to validate user ID format
  static String? _validateUserIdFormat(String userId) {
    // User ID should contain only alphanumeric characters, dots, underscores, and hyphens
    final userIdRegex = RegExp(r'^[a-zA-Z0-9._-]+$');

    if (!userIdRegex.hasMatch(userId)) {
      return 'User ID can only contain letters, numbers, dots, underscores, and hyphens';
    }

    // Check if it starts and ends with alphanumeric character (not special characters)
    if (!RegExp(r'^[a-zA-Z0-9]').hasMatch(userId)) {
      return 'User ID must start with a letter or number';
    }

    if (!RegExp(r'[a-zA-Z0-9]$').hasMatch(userId)) {
      return 'User ID must end with a letter or number';
    }

    // Check for consecutive special characters
    if (RegExp(r'[._-]{2,}').hasMatch(userId)) {
      return 'User ID cannot have consecutive special characters';
    }

    // Additional business rules (customize as needed)
    if (userId.length < 3) {
      return 'User ID must be at least 3 characters';
    }

    if (userId.length > 50) {
      return 'User ID must not exceed 50 characters';
    }

    return null; // Valid user ID
  }

  /// Alternative method for strict email-only validation (if needed separately)
  static String? validateEmailStrict(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }

    final trimmedValue = value.trim();

    // Must contain @ symbol for email
    if (!trimmedValue.contains('@')) {
      return 'Please enter a valid email address';
    }

    return _validateEmailFormat(trimmedValue);
  }

  /// Alternative method for strict user ID-only validation (if needed separately)
  static String? validateUserIdStrict(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'User ID is required';
    }

    final trimmedValue = value.trim();

    // Must not contain @ symbol for user ID
    if (trimmedValue.contains('@')) {
      return 'User ID cannot contain @ symbol';
    }

    return _validateUserIdFormat(trimmedValue);
  }

  // =============================================================================
  // MOBILE NUMBER VALIDATIONS
  // =============================================================================

  /// Validates mobile number with country code
  static String? validateMobileNumber(
    String? value, {
    String countryCode = '+91',
  }) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }

    // Remove spaces and special characters except +
    final cleanNumber = value.replaceAll(RegExp(r'[^\d+]'), '');

    // Indian mobile number validation (10 digits)
    if (countryCode == '+91' || countryCode == '91') {
      if (!RegExp(
        r'^[6-9]\d{9}$',
      ).hasMatch(cleanNumber.replaceAll('+91', ''))) {
        return 'Please enter a valid 10-digit mobile number';
      }
    }

    return null;
  }

  // =============================================================================
  // OTP VALIDATIONS
  // =============================================================================

  /// Validates 6-digit OTP
  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter OTP';
    } else if (value.length != 6) {
      return 'OTP must be exactly 6 digits';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'OTP should contain only digits';
    }
    return null;
  }

  // =============================================================================
  // PASSWORD VALIDATIONS
  // =============================================================================

  /// Validates password according to Exchek requirements
  /// Minimum 8 characters, alphanumeric, at least 1 uppercase letter, Special character
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]).+$',
    ).hasMatch(value)) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character';
    }

    return null;
  }

  /// Validates password confirmation
  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm password is required';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  // =============================================================================
  // ADDRESS VALIDATIONS
  // =============================================================================

  /// Validates postal code
  static String? validatePostalCode(String? value, {String country = 'IND'}) {
    if (value == null || value.trim().isEmpty) {
      return 'Postal code is required';
    }

    if (country == 'IND') {
      if (!RegExp(r'^\d{6}$').hasMatch(value.trim())) {
        return 'Please enter a valid 6-digit postal code';
      }
    }

    return null;
  }

  /// Validates full name as per PAN
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }

    if (value.trim().length < 2) {
      return 'Please enter your full name';
    }

    // Only letters and spaces allowed
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Name should contain only letters and spaces';
    }

    return null;
  }

  // =============================================================================
  // DOCUMENT VALIDATIONS
  // =============================================================================

  /// Validates Aadhaar number
  static String? validateAadhaar(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Aadhaar number is required';
    }

    final cleanAadhaar = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanAadhaar.length != 12) {
      return 'Enter your 12-digit Aadhaar number';
    }

    if (!RegExp(r'^\d{12}$').hasMatch(cleanAadhaar)) {
      return 'Enter Valid Aadhaar Number. Please check and try again';
    }

    return null;
  }

  /// Validates PAN number
  static String? validatePAN(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'PAN number is required';
    }
    final cleanPAN = value.trim().toUpperCase();

    if (!RegExp(r'^[A-Z]{3}[P][A-Z][0-9]{4}[A-Z]{1}$').hasMatch(cleanPAN)) {
      return 'Invalid PAN number. Please check and try again';
    }

    return null;
  }

  /// Validates GST number
  static String? validateGST(String? value, {bool isOptional = true}) {
    if (value == null || value.trim().isEmpty) {
      if (isOptional) return null;
      return 'GST number is required';
    }

    final cleanGST = value.trim().toUpperCase();

    if (cleanGST.length != 15) {
      return 'GST number must be exactly 15 characters long';
    }

    if (!RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[0-9]{1}[Z]{1}[0-9A-Z]{1}$',
    ).hasMatch(cleanGST)) {
      return 'Invalid GST number format';
    }

    // Validate state code (first 2 digits)
    final stateCode = int.tryParse(cleanGST.substring(0, 2));
    if (stateCode == null || stateCode < 1 || stateCode > 37) {
      return 'Invalid state code in GST number';
    }

    // Validate PAN format within GST (positions 2-11)
    final panInGST = cleanGST.substring(2, 12);

    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(panInGST)) {
      return 'Invalid PAN structure in GST number';
    }

    // Validate 14th character must be 'Z'
    if (cleanGST[13] != 'Z') {
      return 'Invalid GST format - 14th character must be Z';
    }

    return null;
  }

  static String? validatePersonalGST(
    String? value,
    String? pan, {
    bool isOptional = true,
  }) {
    if (value == null || value.trim().isEmpty) {
      if (isOptional) return null;
      return 'GST number is required';
    }

    final cleanGST = value.trim().toUpperCase();

    if (cleanGST.length != 15) {
      return 'GST number must be exactly 15 characters long';
    }

    if (!RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[0-9]{1}[Z]{1}[0-9A-Z]{1}$',
    ).hasMatch(cleanGST)) {
      return 'Invalid GST number format';
    }

    // Validate state code (first 2 digits)
    final stateCode = int.tryParse(cleanGST.substring(0, 2));
    if (stateCode == null || stateCode < 1 || stateCode > 37) {
      return 'Invalid state code in GST number';
    }

    // Validate PAN format within GST (positions 2-11)
    final panInGST = cleanGST.substring(2, 12);

    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(panInGST)) {
      return 'Invalid PAN structure in GST number';
    }

    if (pan != null && pan.isNotEmpty && panInGST != pan) {
      return 'PAN does not match with GST number. Please check your details';
    }

    // Validate 14th character must be 'Z'
    if (cleanGST[13] != 'Z') {
      return 'Invalid GST format - 14th character must be Z';
    }

    return null;
  }

  /// Validates passport number
  static String? validatePassport(String? value, {bool isOptional = true}) {
    if (value == null || value.trim().isEmpty) {
      return isOptional ? null : 'Passport number is required';
    }

    final input = value.trim(); // No `.toUpperCase()`

    if (!RegExp(r'^[A-Z][0-9]{7}$').hasMatch(input)) {
      return 'Enter valid passport number';
    }

    return null;
  }

  // =============================================================================
  // BANK VALIDATIONS
  // =============================================================================

  /// Validates bank account number
  static String? validateBankAccount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bank account number is required';
    }

    final cleanAccount = value.replaceAll(RegExp(r'\s+'), '');

    // Check: only digits and at least 9 characters
    if (!RegExp(r'^\d{9,}$').hasMatch(cleanAccount)) {
      return 'Please enter a valid account number.';
    }

    return null;
  }

  /// Validates IFSC code
  static String? validateIFSC(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'IFSC code is required';
    }

    final cleanIFSC = value.trim().toUpperCase();

    // Regex: 4 uppercase letters + 0 + 6 alphanumeric
    final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');

    if (!ifscRegex.hasMatch(cleanIFSC)) {
      return 'Enter a valid IFSC code';
    }

    return null;
  }

  /// Validates account number confirmation
  static String? validateAccountConfirmation(
    String? original,
    String? confirmation,
  ) {
    if (confirmation == null || confirmation.trim().isEmpty) {
      return 'Please re-enter your account number';
    }

    if (original?.trim() != confirmation.trim()) {
      return 'Account numbers do not match';
    }

    return null;
  }

  // =============================================================================
  // BUSINESS VALIDATIONS
  // =============================================================================

  /// Validates business name
  static String? validateBusinessName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Business name is required';
    }

    if (value.trim().length < 2) {
      return 'Business name must be at least 2 characters';
    }

    return null;
  }

  /// Validates DBA (Doing Business As)
  /// Rules:
  /// - If empty and required => "This field is required."
  /// - Disallow special characters: <, >, ', "
  static String? validateDBA(String? value, {bool isOptional = false}) {
    final text = (value ?? '').trim();
    if (text.isEmpty) {
      return isOptional ? null : 'This field is required.';
    }

    // Disallow: <, >, ', "
    if (RegExp(r"""[<>'\"]""").hasMatch(text)) {
      return 'Special characters are not allowed';
    }

    return null;
  }

  /// Validates CIN number
  static String? validateCIN(String? value, {bool isOptional = true}) {
    if (value == null || value.trim().isEmpty) {
      if (isOptional) return null;
      return 'Please enter a valid registration number';
    }

    final cleanCIN = value.trim().toUpperCase();

    if (cleanCIN.length != 21) {
      return 'CIN must be exactly 21-character long';
    }

    if (!RegExp(
      r'^[LU][0-9]{5}[A-Z]{2}[0-9]{4}[A-Z]{3}[0-9]{6}$',
    ).hasMatch(cleanCIN)) {
      return 'Enter a valid CIN format';
    }

    // Validate first character (Listing status)
    final listingStatus = cleanCIN[0];
    if (!['L', 'U'].contains(listingStatus)) {
      return 'Enter a valid CIN format';
    }

    // Validate year (positions 8-11)
    final year = int.tryParse(cleanCIN.substring(8, 12));
    final currentYear = DateTime.now().year;
    if (year == null || year < 1850 || year > currentYear) {
      return 'Enter a valid CIN format';
    }

    return null;
  }

  /// Validates LLPIN number
  static String? validateLLPIN(String? value, {bool isOptional = true}) {
    if (value == null || value.trim().isEmpty) {
      if (isOptional) return null;
      return 'LLPIN number is required';
    }

    final input = value.trim().toUpperCase();

    // LLPIN format: A + 2 letters + 4 digits = 7 characters total
    final pattern = RegExp(r'^A[A-Z]{2}[0-9]{4}$');

    if (!pattern.hasMatch(input)) {
      return 'Enter a valid LLPIN format';
    }

    return null;
  }

  /// Validates website URL
  static String? validateWebsite(String? value, {bool isOptional = true}) {
    if (value == null || value.trim().isEmpty) {
      if (isOptional) return null;
      return 'Website URL is required';
    }

    final urlRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
      caseSensitive: false,
    );

    if (!urlRegex.hasMatch(value.trim())) {
      return 'Please enter a valid website URL';
    }

    return null;
  }

  // =============================================================================
  // FILE VALIDATIONS
  // =============================================================================

  /// Validates file size (in bytes)
  static String? validateFileSize(int? fileSizeInBytes, {int maxSizeInMB = 2}) {
    if (fileSizeInBytes == null) {
      return 'File size information not available';
    }

    final maxSizeInBytes = maxSizeInMB * 1024 * 1024;
    if (fileSizeInBytes > maxSizeInBytes) {
      return 'File size exceeds ${maxSizeInMB}MB limit';
    }

    return null;
  }

  /// Validates file format
  static String? validateFileFormat(
    String? fileName,
    List<String> allowedFormats,
  ) {
    if (fileName == null || fileName.trim().isEmpty) {
      return 'File name is required';
    }

    final extension = fileName.split('.').last.toLowerCase();

    if (!allowedFormats.map((f) => f.toLowerCase()).contains(extension)) {
      return 'Invalid file format. Allowed: ${allowedFormats.join(', ')}';
    }

    return null;
  }

  /// Validates document upload for KYC
  static String? validateDocumentUpload(
    String? fileName,
    int? fileSizeInBytes,
  ) {
    if (fileName == null || fileName.trim().isEmpty) {
      return 'Please upload a document';
    }

    final formatValidation = validateFileFormat(fileName, [
      'pdf',
      'jpeg',
      'png',
    ]);
    if (formatValidation != null) return formatValidation;

    final sizeValidation = validateFileSize(fileSizeInBytes, maxSizeInMB: 2);
    if (sizeValidation != null) return sizeValidation;

    return null;
  }

  // =============================================================================
  // UTILITY VALIDATIONS
  // =============================================================================

  /// Validates dropdown selection
  static String? validateDropdownSelection(
    String? value, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty || value == 'Select') {
      return 'Please select $fieldName';
    }
    return null;
  }

  /// Validates checkbox agreement
  static String? validateCheckboxAgreement(
    bool? isChecked, {
    String fieldName = 'terms and conditions',
  }) {
    if (isChecked != true) {
      return 'Please agree to $fieldName';
    }
    return null;
  }

  /// Validates age (18+ for KYC)
  static String? validateAge(DateTime? dateOfBirth) {
    if (dateOfBirth == null) {
      return 'Date of birth is required';
    }

    final now = DateTime.now();
    final age = now.year - dateOfBirth.year;

    if (age < 18) {
      return 'You must be at least 18 years old';
    }

    if (age > 120) {
      return 'Please enter a valid date of birth';
    }

    return null;
  }

  /// Validates date format (DD/MM/YYYY)
  static String? validateDate(String? value, {bool isOptional = false}) {
    if (value == null || value.trim().isEmpty) {
      if (isOptional) return null;
      return 'Date is required';
    }

    if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value.trim())) {
      return 'Please use DD/MM/YYYY format';
    }

    try {
      final parts = value.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final date = DateTime(year, month, day);

      if (date.day != day || date.month != month || date.year != year) {
        return 'Please enter a valid date';
      }
    } catch (e) {
      return 'Please enter a valid date';
    }

    return null;
  }

  /// Validates driving licence number
  static String? validateDrivingLicence(
    String? value, {
    bool isOptional = true,
  }) {
    if (value == null || value.trim().isEmpty) {
      return isOptional ? null : 'Driving license number is required';
    }

    final input = value.replaceAll(' ', '').toUpperCase();

    // Format: 2 letters + 2 digits + 4-digit year + 7-digit number
    final dlRegex = RegExp(r'^[A-Z]{2}[0-9]{2}[0-9]{4}[0-9]{7}$');

    if (!dlRegex.hasMatch(input)) {
      return 'Enter valid driving license number';
    }

    return null;
  }

  /// Validates voter id number
  static String? validateVoterId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Voter id number is required';
    }

    final cleanValue = value.trim().toUpperCase();

    final pattern = RegExp(r'^[A-Z]{3}\d{7}$');

    if (!pattern.hasMatch(cleanValue)) {
      return 'Enter a valid voter ID number';
    }

    return null;
  }

  /// Validates ICE Certificate Number
  static String? validateIceCertificateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your IEC number.';
    }

    final input = value.trim().toUpperCase();

    // 3 letters + 1 char from [P/C/F/H] + 1 letter + 4 digits + 1 letter
    final panRegex = RegExp(r'^[A-Z]{3}[PCFH][A-Z][0-9]{4}[A-Z]$');

    // Only numeric values
    final numericRegex = RegExp(r'^[0-9]+$');

    // Accept either PAN OR Numeric
    if (!(panRegex.hasMatch(input) || numericRegex.hasMatch(input))) {
      return 'Enter a valid IEC number (PAN format or numeric only)';
    }

    return null; // Valid
  }

  /// Helper function to create info message checker for multiple validation messages
  static bool Function(String?) createInfoMessageChecker(
    List<String> infoMessages,
  ) {
    return (String? validationMessage) {
      if (validationMessage == null) return false;
      return infoMessages.any((message) => validationMessage.contains(message));
    };
  }

  /// Common PAN validation for all entity types
  static String? validatePANByType(String? value, String entityType) {
    if (value == null || value.trim().isEmpty) {
      return 'PAN number is required';
    }
    final cleanPAN = value.trim().toUpperCase();

    // Supported entity types and their 4th character
    final entityTypeMap = {
      'COMPANY': 'C',
      'PROPRIETOR': 'P',
      'HUF': 'H',
      'KARTA': 'P',
      'LLP': 'F',
      'PARTNERSHIP': 'F',
      'INDIVIDUAL': 'P',
    };

    final typeChar = entityTypeMap[entityType.toUpperCase()];
    if (typeChar == null) {
      return 'Invalid PAN number';
    }

    // Regex: 3 alphabets, 4th is typeChar, 5th alphabet, 4 digits, 1 alphabet
    final panRegex = RegExp(r'^[A-Z]{3}' + typeChar + r'[A-Z][0-9]{4}[A-Z]$');
    if (!panRegex.hasMatch(cleanPAN)) {
      // Return specific validation messages based on entity type
      switch (entityType.toUpperCase()) {
        case 'PARTNERSHIP':
          return 'Please enter a valid Partnership PAN number.';
        case 'LLP':
          return 'Please enter a valid LLP PAN number.';
        case 'PROPRIETOR':
          return 'Please enter a valid Proprietor PAN number.';
        case 'HUF':
          return 'Please enter a valid HUF PAN number.';
        case 'COMPANY':
          return 'Please enter a valid Company PAN number.';
        case 'KARTA':
          return 'Invalid PAN number';
        case 'INDIVIDUAL':
          return 'Invalid PAN number';
        default:
          return 'Invalid PAN number';
      }
    }

    return null;
  }

  /// Validates that PAN numbers for Authorized Director and Other Director are different
  static String? validateDirectorPANsAreDifferent(
    String? authorizedDirectorPAN,
    String? otherDirectorPAN,
  ) {
    if (authorizedDirectorPAN == null || authorizedDirectorPAN.trim().isEmpty) {
      return null; // Authorized Director PAN is not entered yet
    }

    if (otherDirectorPAN == null || otherDirectorPAN.trim().isEmpty) {
      return null; // Other Director PAN is not entered yet
    }

    final cleanAuthorizedPAN = authorizedDirectorPAN.trim().toUpperCase();
    final cleanOtherPAN = otherDirectorPAN.trim().toUpperCase();

    if (cleanAuthorizedPAN == cleanOtherPAN) {
      return 'PAN for Authorized Director and Other Director must be different';
    }

    return null;
  }

  /// Validates that Aadhaar numbers for Authorized Director and Other Director are different
  static String? validateDirectorAadhaarsAreDifferent(
    String? authorizedDirectorAadhaar,
    String? otherDirectorAadhaar,
  ) {
    if (authorizedDirectorAadhaar == null ||
        authorizedDirectorAadhaar.trim().isEmpty) {
      return null; // Authorized Director Aadhaar is not entered yet
    }

    if (otherDirectorAadhaar == null || otherDirectorAadhaar.trim().isEmpty) {
      return null; // Other Director Aadhaar is not entered yet
    }

    final cleanAuthorizedAadhaar = authorizedDirectorAadhaar.replaceAll(
      RegExp(r'[^\d]'),
      '',
    );
    final cleanOtherAadhaar = otherDirectorAadhaar.replaceAll(
      RegExp(r'[^\d]'),
      '',
    );

    if (cleanAuthorizedAadhaar == cleanOtherAadhaar) {
      return 'Aadhaar for Authorized Director and Other Director must be different';
    }

    return null;
  }

  // =============================================================================
  // COMMON VALIDATION MESSAGE CHECKERS
  // =============================================================================
  //
  // Usage examples:
  //
  // 1. In CustomTextInputField:
  //    shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForGSTValidation,
  //
  // 2. For custom validation messages:
  //    shouldShowInfoForMessage: ExchekValidations.createInfoMessageChecker([
  //      'Custom message 1',
  //      'Custom message 2',
  //    ]),
  //
  // 3. Direct usage:
  //    bool shouldShow = ExchekValidations.shouldShowInfoForGSTValidation(validationMessage);

  /// Common validation message checker for required field validation
  static bool Function(String?) get shouldShowInfoForRequiredValidation {
    return createInfoMessageChecker([]);
  }

  static bool Function(String?)
  get shouldShowInfoForEmailOrMobileNumberValidation {
    return createInfoMessageChecker([]);
  }

  static bool Function(String?) get shouldShowInfoForMobileNumberValidation {
    return createInfoMessageChecker([
      'Please enter a valid 10-digit mobile number',
    ]);
  }

  static bool Function(String?) get shouldShowInfoForPasswordValidation {
    return createInfoMessageChecker([]);
  }

  static bool Function(String?) get shouldShowInfoForConfirmPasswordValidation {
    return createInfoMessageChecker([]);
  }

  /// Common validation message checker for GST validation
  static bool Function(String?) get shouldShowInfoForGSTValidation {
    return createInfoMessageChecker([
      "GST number must be exactly 15 characters long",
    ]);
  }

  /// Common validation message checker for PAN validation
  static bool Function(String?) get shouldShowInfoForPANValidation {
    return createInfoMessageChecker([]);
  }

  /// Common validation message checker for Aadhaar validation
  static bool Function(String?) get shouldShowInfoForAadhaarValidation {
    return createInfoMessageChecker(['Enter your 12-digit Aadhaar number']);
  }

  static bool Function(String?) get shouldShowInfoForPassportValidation {
    return createInfoMessageChecker([]);
  }

  static bool Function(String?)
  get shouldShowInfoForBankAccountNumberValidation {
    return createInfoMessageChecker([]);
  }

  /// Common validation message checker for email validation
  static bool Function(String?) get shouldShowInfoForEmailValidation {
    return createInfoMessageChecker([]);
  }

  /// Common validation message checker for IFS code validation
  static bool Function(String?) get shouldShowInfoForIFSCodeValidation {
    return createInfoMessageChecker([]);
  }

  /// Common validation message checker for bank account number validation
  static bool Function(String?)
  get shouldShowInfoForBankAccountConfirmationValidation {
    return createInfoMessageChecker([]);
  }

  /// Common validation message checker for business name validation
  static bool Function(String?) get shouldShowInfoForBusinessNameValidation {
    return createInfoMessageChecker([]);
  }

  /// Common validation message checker for professional website URL validation
  static bool Function(String?) get shouldShowInfoForCINNumberValidation {
    return createInfoMessageChecker(['CIN must be exactly 21-character long']);
  }

  /// Common validation message checker for professional website URL validation
  static bool Function(String?) get shouldShowInfoForLLPINNumberValidation {
    return createInfoMessageChecker([]);
  }

  /// Common validation message checker for DrivingLicense
  static bool Function(String?) get shouldShowInfoForDrivingLicenseValidation {
    return createInfoMessageChecker([]);
  }

  /// Common validation message checker for DrivingLicense
  static bool Function(String?) get shouldShowInfoForVoterIdValidation {
    return createInfoMessageChecker([]);
  }

  /// Common validation message checker for address validation
  static bool Function(String?) get shouldShowInfoForAddressValidation {
    return createInfoMessageChecker([]);
  }

  /// Common validation message checker for IEC validation
  static bool Function(String?) get shouldShowInfoForIECValidation {
    return createInfoMessageChecker([
      'IEC number must be 10 characters long and contain only letters and numbers',
      'No special characters or spaces allowed',
    ]);
  }
}
