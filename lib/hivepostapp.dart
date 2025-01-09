import 'package:chat_app/detailcardhive.dart';
import 'package:flutter/material.dart';
import 'models/post.dart';
import 'services/api_service.dart';
import 'package:intl/intl.dart';


class HivePostsApp extends StatelessWidget {
  const HivePostsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Posts',
      theme: ThemeData(
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, ),
      ),
      debugShowCheckedModeBanner: false,
      home: const PostScreen(),
    );
  }
}

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();
  List<Post> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final posts = await _apiService.fetchPosts();
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading posts: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Posts', style: TextStyle(color: Colors.white,  fontWeight: FontWeight.w600),),

        backgroundColor: Colors.red[400],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'ALL'),
            Tab(text: 'BOOKMARKS'),
          ],
          labelStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
          unselectedLabelStyle: const TextStyle(
            color: Colors.white,
          ),
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white,
                width: 4.0, // Set the thickness of the underline
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPostList(),
          const Center(child: Text('Bookmarks')),
        ],
      ),
    );
  }

  Widget _buildPostList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_posts.isEmpty) {
      return const Center(child: Text('No posts available'));
    }

    return RefreshIndicator(
      onRefresh: _fetchPosts,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0.5,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            final post = _posts[index];
            return _buildPostCard(post);
          },
        ),
      ),
    );
  }


  Widget _buildPostCard(Post post) {
    String formattedDate;
    try {
      final DateTime parsedDate = DateTime.parse(post.updated);
      formattedDate = DateFormat('MMM d, yyyy HH:mm').format(parsedDate);
    } catch (e) {
      formattedDate = 'Date unavailable';
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailCardHive(post: post),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.author.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Community:',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8), // Optional: Adds space between "Community:" and the value
                                Text(
                                  post.community.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )

                          ],
                        ),
                      ),
                      Image.network(
                        post.thumbnails,
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.broken_image,
                            size: 32,
                            color: Colors.red,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Posted on: $formattedDate',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
