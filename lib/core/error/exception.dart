import 'package:dio/dio.dart';

class Failure extends DioError {
  final String? errorMessage;

  final int? applicationStatusCode;

  @override
  String get message => errorMessage ?? '';

  Failure({
    this.applicationStatusCode,
    this.errorMessage,
  }) : super(requestOptions: RequestOptions(path: ''));

  @override
  String toString() {
    if (message.isNotEmpty) {
      return message;
    } else {
      return "Something went wrong, Please try again";
    }
  }
}

class UnknownException extends Failure {
  final String? errMessage;
  UnknownException([this.errMessage]) : super(errorMessage: errMessage);

  @override
  String toString() {
    if ((errMessage ?? '').isNotEmpty) {
      return message;
    } else {
      return "Something went wrong, Please try again";
    }
  }
}
