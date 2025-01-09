
class Post {
  final String id;
  final String thumbnails;
  final String author;
  final String community;
  final String updated;
  final String title;
  final String description;
  final String voteCount;

  Post({
    required this.id,
    required this.thumbnails,
    required this.author,
    required this.community,
    required this.updated,
    required this.title,
    required this.description,
    required this.voteCount,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    // Helper function to extract the thumbnail
    String extractThumbnail(Map<String, dynamic>? metadata) {
      if (metadata != null && metadata['image'] is List && metadata['image'].isNotEmpty) {
        return metadata['image'][0]?.toString() ?? '';
      }
      return ''; // Default to an empty string if no image is found
    }

    return Post(
      id: json['post_id']?.toString() ?? '',
      thumbnails: extractThumbnail(json['json_metadata']), // Ensure a non-null String
      author: json['author']?.toString() ?? '',
      community: json['community_title']?.toString() ?? json['community'].toString(),
      updated: json['updated']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['body']?.toString() ?? '',
      voteCount: json['active_votes']?.toString() ?? '',
    );
  }
}
