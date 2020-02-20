class HttpException implements Exception {
  // Implements: override all function that class has
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;

//    return super.toString();
  }
}