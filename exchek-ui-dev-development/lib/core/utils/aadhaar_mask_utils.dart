/// Utility class for Aadhaar number masking operations
class AadhaarMaskUtils {
  /// Masks an Aadhaar number by showing only the last 4 digits
  /// Format: ****-****-1234
  ///
  /// [aadhaarNumber] - The complete Aadhaar number (12 digits)
  /// Returns masked Aadhaar number in the format ****-****-1234
  static String maskAadhaarNumber(String aadhaarNumber) {
    if (aadhaarNumber.isEmpty) return '';

    // Remove any non-digit characters
    final cleanAadhaar = aadhaarNumber.replaceAll(RegExp(r'[^\d]'), '');

    // If not a valid 12-digit Aadhaar, return as is
    if (cleanAadhaar.length != 12) return aadhaarNumber;

    // Extract last 4 digits
    final lastFourDigits = cleanAadhaar.substring(8);

    // Return masked format
    return 'XXXX-XXXX-$lastFourDigits';
  }

  /// Masks an Aadhaar number with custom masking pattern
  ///
  /// [aadhaarNumber] - The complete Aadhaar number (12 digits)
  /// [visibleDigits] - Number of digits to show at the end (default: 4)
  /// [maskChar] - Character to use for masking (default: '*')
  /// Returns masked Aadhaar number
  static String maskAadhaarNumberCustom(String aadhaarNumber, {int visibleDigits = 4, String maskChar = '*'}) {
    if (aadhaarNumber.isEmpty) return '';

    // Remove any non-digit characters
    final cleanAadhaar = aadhaarNumber.replaceAll(RegExp(r'[^\d]'), '');

    // If not a valid 12-digit Aadhaar, return as is
    if (cleanAadhaar.length != 12) return aadhaarNumber;

    // Ensure visibleDigits is within valid range
    if (visibleDigits < 0 || visibleDigits > 12) {
      visibleDigits = 4;
    }

    // Calculate masked digits
    final maskedDigits = 12 - visibleDigits;
    final maskString = maskChar * maskedDigits;

    // Extract visible digits
    final visiblePart = cleanAadhaar.substring(maskedDigits);

    // Format with groups of 4
    if (maskedDigits == 8 && visibleDigits == 4) {
      // Standard format: ****-****-1234
      return '${maskString.substring(0, 4)}-${maskString.substring(4, 8)}-$visiblePart';
    } else {
      // Custom format
      final buffer = StringBuffer();

      // Add masked part
      for (int i = 0; i < maskedDigits; i += 4) {
        final groupSize = (maskedDigits - i) >= 4 ? 4 : (maskedDigits - i);
        buffer.write(maskString.substring(i, i + groupSize));
        if (i + groupSize < maskedDigits) buffer.write('-');
      }

      // Add separator if there are visible digits
      if (visibleDigits > 0) {
        if (buffer.isNotEmpty) buffer.write('-');
        buffer.write(visiblePart);
      }

      return buffer.toString();
    }
  }

  /// Validates if a string is a valid Aadhaar number format
  ///
  /// [aadhaarNumber] - The Aadhaar number to validate
  /// Returns true if valid 12-digit Aadhaar number
  static bool isValidAadhaarFormat(String aadhaarNumber) {
    if (aadhaarNumber.isEmpty) return false;

    final cleanAadhaar = aadhaarNumber.replaceAll(RegExp(r'[^\d]'), '');
    return cleanAadhaar.length == 12 && RegExp(r'^\d{12}$').hasMatch(cleanAadhaar);
  }

  /// Extracts clean Aadhaar number (digits only) from formatted string
  ///
  /// [aadhaarNumber] - The formatted Aadhaar number
  /// Returns clean 12-digit Aadhaar number
  static String extractCleanAadhaar(String aadhaarNumber) {
    return aadhaarNumber.replaceAll(RegExp(r'[^\d]'), '');
  }
}
