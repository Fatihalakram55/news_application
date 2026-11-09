class Article {
  final String title;
  final String description;
  final String imageUrl;
  final String sourceName;
  final String publishedAt;
  final String url;

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this. sourceName,
    required this.publishedAt,
    required this.url,
  });

// membuat konstruktor article dari JSON
factory Article. fromJson(Map<String, dynamic> json) {
  final source = json['source'] as Map<String, dynamic> ?;

  return Article(
    // mencocokan data JSON dengan properti dari Article
    title: json['title'] ?? 'Judul tidak tersedia',
    description: json['description'] ?? '',
    imageUrl: json['urlToImage'] ?? '',
    sourceName: source?['name' ] ?? 'Sumber tidak diketahui',
    publishedAt: json['publishedAt'] ?? '',
    url: json['url'] ?? '',
    );
  }
}