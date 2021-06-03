/// Error message for when file is not found.
const fileNotFoundError = 'File not found';

/// Error message for when the file type is unsupported.
const fileTypeError = 'File type is not supported';

/// Error message for invalid YAML.
const invalidYamlError = 'Front matter is not valid YAML.';

/// Exception thrown when there's an internal error.
class FrontMatterException implements Exception {
  const FrontMatterException(this.message);

  final String message;

  @override
  String toString() => 'FrontMatterException: $message';
}
