import 'package:chat_app/models/post.dart';
import 'package:flutter/material.dart';

class DetailCardHive extends StatefulWidget {
  final Post post;

  const DetailCardHive({super.key, required this.post});

  @override
  _DetailCardHiveState createState() => _DetailCardHiveState();
}

class _DetailCardHiveState extends State<DetailCardHive> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    // Truncate the description if not expanded
    String displayedDescription =
    _isExpanded ? post.description.substring(0,1000) : '${post.description.substring(0, 200)}...';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          post.author.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
        iconTheme: const IconThemeData(
          color: Colors.white, // Sets the back button color to white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Image.network(
              post.thumbnails,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.broken_image,
                  size: 100,
                  color: Colors.red,
                );
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Text(
                  'Votes: ',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${post.voteCount.length}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Community Title: ',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  post.community.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Description: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: displayedDescription,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (post.description.length > 200)
              TextButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'Show Less' : 'Show More',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
