/// Exception thrown when there's an internal error (or user error).
class FrontMatterException implements Exception {
  final String message;

  FrontMatterException(this.message);

  @override
  String toString() => 'FrontMatterException: ${this.message}';
}
