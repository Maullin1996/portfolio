/// A single portfolio project: what it is, the stack it uses, and where to
/// see it (source on GitHub plus an optional embedded video demo).
class Project {
  final String title;
  final String description;
  final List<String> stack;
  final String githubUrl;

  /// Path to the project's logo/icon under `assets/images/`.
  final String logoAsset;

  /// YouTube video ID for the inline demo player (the part after `youtu.be/`
  /// or `/shorts/`). `null` when no demo is available yet — the demo action
  /// is shown disabled in that case instead of being removed.
  final String? youtubeVideoId;

  const Project({
    required this.title,
    required this.description,
    required this.stack,
    required this.githubUrl,
    required this.logoAsset,
    this.youtubeVideoId,
  });
}
