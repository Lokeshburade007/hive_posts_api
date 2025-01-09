import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const String apiUrl = 'https://api.hive.blog/';

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'id': 1,
          'jsonrpc': '2.0',
          'method': 'bridge.get_ranked_posts',
          'params': {
            'sort': 'trending',
            'tag': '',
            'observer': 'hive.blog'
          }
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('result') && data['result'] is List) {
          final List<dynamic> result = data['result'];
          return result.map((json) => Post.fromJson(json)).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching posts: $e'); // Add logging
      throw Exception('Error: $e');
    }
  }
}