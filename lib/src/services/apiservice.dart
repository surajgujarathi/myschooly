// import 'dart:convert';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:myschooly/src/services/apierrors.dart';
import 'package:myschooly/src/services/apiconstants.dart';

class ApiService {
  final String? baseOverride;
  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
  };
  ApiService({this.baseOverride});

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final base = '${baseOverride ?? ApiConstants.baseUrl}$path';
    if (query == null || query.isEmpty) return Uri.parse(base);
    final qp = query.map((k, v) => MapEntry(k, v.toString()));
    return Uri.parse(base).replace(queryParameters: qp);
  }

  void _logRequest({
    required String method,
    required Uri url,
    Map<String, String>? headers,
    Object? body,
  }) {
    debugPrint('🚀 [$method] 🌐 ${url.toString()}');

    if (headers != null) {
      debugPrint('🧾 Headers: $headers');
    }

    if (body != null) {
      final bodyStr = body is String ? body : body.toString();
      final trimmed = bodyStr.length > 1000
          ? '${bodyStr.substring(0, 1000)}…'
          : bodyStr;
      debugPrint('📦 Request Body: $trimmed');
    }
  }

  void _logResponse(http.Response res) {
    final bodyStr = res.body;
    final trimmed = bodyStr.length > 1500
        ? '${bodyStr.substring(0, 1500)}…'
        : bodyStr;

    if (res.statusCode >= 200 && res.statusCode < 300) {
      debugPrint('✅ Response Success');
    } else {
      debugPrint('❌ Response Error');
    }

    debugPrint('🔢 Status Code: ${res.statusCode}');
    debugPrint('🌐 URL: ${res.request?.url}');
    debugPrint('📦 Response Body: $trimmed');
  }

  Future<http.Response> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      final url = _uri(path, query);
      final mergedHeaders = {
        ..._defaultHeaders,
        if (headers != null) ...headers,
      };
      _logRequest(method: 'GET', url: url, headers: mergedHeaders);
      final res = await http.get(url, headers: mergedHeaders);
      _throwIfNeeded(res);
      _logResponse(res);
      return res;
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  Future<http.Response> postJson(
    String path,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = _uri(path);
      final mergedHeaders = {
        ..._defaultHeaders,
        if (headers != null) ...headers,
      };
      final payload = jsonEncode(body);
      _logRequest(
        method: 'POST',
        url: url,
        headers: mergedHeaders,
        body: payload,
      );
      final res = await http.post(url, headers: mergedHeaders, body: payload);
      _throwIfNeeded(res);
      _logResponse(res);
      return res;
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  Future<http.Response> postForm(
    String path,
    Map<String, String> fields, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = _uri(path);
      final req = http.MultipartRequest('POST', url);
      req.fields.addAll(fields);
      if (headers != null) req.headers.addAll(headers);
      _logRequest(
        method: 'POST(FORM)',
        url: url,
        headers: req.headers,
        body: fields,
      );
      final streamed = await req.send();
      final res = await http.Response.fromStream(streamed);
      _throwIfNeeded(res);
      _logResponse(res);
      return res;
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  Future<http.Response> putJson(
    String path,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = _uri(path);
      final mergedHeaders = {
        ..._defaultHeaders,
        if (headers != null) ...headers,
      };
      final payload = jsonEncode(body);
      _logRequest(
        method: 'PUT',
        url: url,
        headers: mergedHeaders,
        body: payload,
      );
      final res = await http.put(url, headers: mergedHeaders, body: payload);
      _throwIfNeeded(res);
      _logResponse(res);
      return res;
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  Future<http.Response> delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = _uri(path);
      final mergedHeaders = {
        ..._defaultHeaders,
        if (headers != null) ...headers,
      };
      _logRequest(method: 'DELETE', url: url, headers: mergedHeaders);
      final res = await http.delete(url, headers: mergedHeaders);
      _throwIfNeeded(res);
      _logResponse(res);
      return res;
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  void _throwIfNeeded(http.Response res) {
    final code = res.statusCode;
    if (code >= 200 && code < 300) return;
    switch (code) {
      case 400:
        throw BadRequestException(res.body);
      case 401:
        throw UnauthorisedException(res.body);
      case 404:
        throw ResoruceNotFoundException(res.body);
      case 415:
        throw UnsupportedMediaTypeException(res.body);
      case 422:
        throw UnprocessableEntityException(res.body);
      case 500:
        throw InternalServerErrorException(res.body);
      default:
        throw FetchDataException(res.body);
    }
  }
}
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:myschooly/src/services/apierrors.dart';
// import 'package:myschooly/src/utils/constants.dart';

// class ApiService {
//   Future<http.Response> get(String endPoint) async {
//     try {
//       var apiUrl = Uri.https(ApiConstants.baseDomainUrl, endPoint);
//       var response = await http.get(apiUrl);
//       log(response.toString());
//       debugPrint('Got the response');
//       return response;
//     } catch (e) {
//       log(e.toString());
//       throw FetchDataException(e.toString());
//     }
//   }
// }

// Future<http.Response> delete(String endPoint) async {
//   try {
//     var apiUrl = Uri.https(ApiConstants.baseDomainUrl, endPoint);
//     var response = await http.delete(apiUrl);
//     log(response.toString());
//     var responseJson = json.decode(response.body.toString());
//     debugPrint(responseJson);
//     log(responseJson.toString());
//     return response;
//   } catch (e) {
//     log(e.toString());
//     throw FetchDataException(e.toString());
//   }
// }

// // TESTING
// // Future<http.Response> post(
// //   String endPoint,
// //   Map<String, dynamic> jsonBody,
// // ) async {
// //   try {
// //     Uri apiUrl = Uri.parse(ApiConstants.baseDomainUrl + endPoint);
// //     log(apiUrl.toString());
// //     log(jsonBody.toString());
// //     String body = jsonEncode(jsonBody);
// //     int contentLength = utf8.encode(body).length;
// //     var response = await http.post(apiUrl,
// //         headers: {
// //           'Content-Type': 'application/json',
// //           // 'Host': ApiConstants.baseDomainUrl,
// //           'User-Agent': 'Mozilla/5.0',
// //           // 'Content-Length': contentLength.toString()
// //         },
// //         body: jsonEncode(jsonBody));
// //     String responseBody = utf8.decoder.convert(response.bodyBytes);
// //     // debugPrint(response.headers);
// //     log(response.toString());
// //     log('Url is $apiUrl \n $responseBody');
// //     return response;
// //   } catch (e) {
// //     log('Erros is ==> ${e.toString()} \n Url is ==> $endPoint');
// //     throw FetchDataException(e.toString());
// //   }
// // }

// Future<http.Response> post(
//   String endPoint,
//   Map<String, dynamic> jsonBody,
// ) async {
//   try {
//     Uri apiUrl = Uri.https(ApiConstants.baseDomainUrl, endPoint);
//     log(apiUrl.toString());
//     log(jsonBody.toString());
//     String body = jsonEncode(jsonBody);
//     int contentLength = utf8.encode(body).length;
//     var response = await http.post(
//       apiUrl,
//       headers: {
//         'Content-Type': 'application/json',
//         'Host': ApiConstants.baseDomainUrl,
//         'User-Agent': 'Mozilla/5.0',
//         'Content-Length': contentLength.toString(),
//       },
//       body: jsonEncode(jsonBody),
//     );
//     String responseBody = utf8.decoder.convert(response.bodyBytes);
//     log(response.toString());
//     log('Url is $apiUrl \n $responseBody');
//     return response;
//   } catch (e) {
//     log('Erros is ==> ${e.toString()} \n Url is ==> $endPoint');
//     throw FetchDataException(e.toString());
//   }
// }

// Future<http.Response> put(
//   String endPoint,
//   Map<String, dynamic> jsonBody,
// ) async {
//   try {
//     var apiUrl = Uri.https(ApiConstants.baseDomainUrl, endPoint);
//     var response = await http.put(apiUrl, body: jsonEncode(jsonBody));
//     log(response.toString());
//     debugPrint('Got the response');
//     return response;
//   } catch (e) {
//     log(e.toString());
//     throw FetchDataException(e.toString());
//   }
// }
