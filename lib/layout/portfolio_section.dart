/// The ordered sections of the single-page portfolio.
///
/// Order here defines both the scroll order on the page and the order of
/// links in the nav bar / drawer.
enum PortfolioSection { home, projects, about, experience, contact }

extension PortfolioSectionLabel on PortfolioSection {
  String get label => switch (this) {
    PortfolioSection.home => 'Inicio',
    PortfolioSection.projects => 'Proyectos',
    PortfolioSection.about => 'Sobre mí',
    PortfolioSection.experience => 'Experiencia',
    PortfolioSection.contact => 'Contacto',
  };
}
