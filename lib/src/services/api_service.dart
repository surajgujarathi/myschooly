import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/post_model.dart';

class ApiService {
  final Map<String, String> _defaultHeaders = {'Content-Type': 'application/json'};
  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final base = '${Constants.baseUrl}$path';
    if (query == null || query.isEmpty) return Uri.parse(base);
    final qp = query.map((k, v) => MapEntry(k, v.toString()));
    return Uri.parse(base).replace(queryParameters: qp);
  }

  Future<http.Response> getRaw(String path, {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    return http.get(_uri(path, query), headers: {..._defaultHeaders, if (headers != null) ...headers});
  }

  Future<http.Response> postRaw(String path, {Object? body, Map<String, String>? headers}) async {
    return http.post(_uri(path), headers: {..._defaultHeaders, if (headers != null) ...headers}, body: body);
  }

  Future<http.Response> putRaw(String path, {Object? body, Map<String, String>? headers}) async {
    return http.put(_uri(path), headers: {..._defaultHeaders, if (headers != null) ...headers}, body: body);
  }

  Future<http.Response> deleteRaw(String path, {Map<String, String>? headers}) async {
    return http.delete(_uri(path), headers: {..._defaultHeaders, if (headers != null) ...headers});
  }

  Future<List<Post>> fetchPosts() async {
    final response = await getRaw(Constants.postsEndpoint);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Post> posts = body.map((dynamic item) => Post.fromJson(item)).toList();
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Post> fetchPost(int id) async {
    final response = await getRaw('${Constants.postsEndpoint}/$id');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Post.fromJson(data);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Post> createPost({required String title, required String body, int userId = 1}) async {
    final payload = jsonEncode({'title': title, 'body': body, 'userId': userId});
    final response = await postRaw(Constants.postsEndpoint, body: payload);
    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Post.fromJson(data);
    } else {
      throw Exception('Failed to create post');
    }
  }

  Future<Post> updatePost(int id, {String? title, String? body}) async {
    final payload = jsonEncode({'title': title, 'body': body});
    final response = await putRaw('${Constants.postsEndpoint}/$id', body: payload);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Post.fromJson(data);
    } else {
      throw Exception('Failed to update post');
    }
  }

  Future<bool> deletePost(int id) async {
    final response = await deleteRaw('${Constants.postsEndpoint}/$id');
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete post');
    }
  }
}
