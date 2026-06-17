/// A single role in the work-experience timeline.
class WorkExperience {
  final String role;
  final String company;
  final String period;

  /// Condensed 1-2 line summary — not the full bullet list from the CV.
  final String summary;

  /// Shown with a "Actual" badge when true.
  final bool isCurrent;

  const WorkExperience({
    required this.role,
    required this.company,
    required this.period,
    required this.summary,
    this.isCurrent = false,
  });
}
