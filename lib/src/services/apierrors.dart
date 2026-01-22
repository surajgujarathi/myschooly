class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, " ");
}

class NoDataException extends AppException {
  NoDataException([message])
    : super(
        message,
        "The request was successful, but the response has no content.",
      );
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "The request was malformed.");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message])
    : super(
        message,
        "The client is not authorized to perform the requested action.",
      );
}

class ResoruceNotFoundException extends AppException {
  ResoruceNotFoundException([message])
    : super(message, "The requested resource was not found.");
}

class UnsupportedMediaTypeException extends AppException {
  UnsupportedMediaTypeException([message])
    : super(message, "The request data format is not supported by the server.");
}

class UnprocessableEntityException extends AppException {
  UnprocessableEntityException([message])
    : super(
        message,
        "The request data was properly formatted but contained invalid or missing data.",
      );
}

class InternalServerErrorException extends AppException {
  InternalServerErrorException([message])
    : super(message, "The server threw an error when processing the request.");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, " ");
}
