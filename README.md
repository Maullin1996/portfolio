# Mauricio Llanos — Portfolio

Sitio de portafolio personal, construido en Flutter Web como una página única de scroll
(Inicio → Proyectos → Sobre mí → Experiencia → Contacto). Todo el estilo visual viene del
sistema de diseño propio [`atomic_design`](https://github.com/Maullin1996/atomic_design.git),
consumido como dependencia git.

🔗 **Demo en vivo:** https://maullin1996.github.io/portfolio/

## Stack

- **Flutter** (SDK `^3.12.2`), target web
- [`atomic_design`](https://github.com/Maullin1996/atomic_design.git) — tema, tipografía, espaciado y
  componentes (`AppButtons`, `AppChip`, `AppText`, `AppAssetsImage`, etc.), configurado desde
  `assets/config/app_config.json`
- `url_launcher` — enlaces de contacto (correo, redes, WhatsApp)
- `youtube_player_iframe` — demos de proyectos embebidas
- `visibility_detector` — animaciones de aparición al hacer scroll

## Estructura del proyecto

```
lib/
  main.dart                     # bootstrap: carga app_config.json y lanza PortfolioApp
  app.dart                      # MaterialApp + ThemeController + AppThemeProvider
  layout/
    portfolio_shell.dart        # shell con scroll y navegación entre secciones
    portfolio_section.dart      # enum con el orden de las secciones y sus etiquetas
    breakpoints.dart            # breakpoints responsive (alineados a atomic_design)
  sections/
    hero_section.dart           # Inicio: nombre, rol, stack, CTA, foto
    projects_section.dart       # Proyectos (grid)
    about_section.dart          # Sobre mí + skills
    experience_section.dart     # Experiencia / educación (timeline)
    contact_section.dart        # Contacto + footer
  models/                       # Project, WorkExperience, SkillCategory, ContactLink
  theme/
    theme_controller.dart       # toggle explícito claro/oscuro (ValueNotifier<ThemeMode>)
  widgets/
    nav_bar.dart                # nav responsive (barra ≥840px, hamburguesa + drawer debajo)
    reveal_on_scroll.dart       # animación de aparición al hacer scroll

assets/
  config/app_config.json        # tokens de tema (colores, tipografía, espaciado) para atomic_design
  images/                        # imágenes en WebP
  fonts/                         # Inter

test/                            # tests de widgets por sección
```

## Empezar

```bash
flutter pub get
flutter run -d chrome
```

## Comandos útiles

| Comando | Descripción |
| --- | --- |
| `flutter pub get` | Instala dependencias |
| `flutter run -d chrome` | Corre la app (web es la única plataforma generada) |
| `flutter analyze` | Análisis estático (`flutter_lints`) |
| `flutter test` | Corre todos los tests |
| `flutter test test/some_test.dart` | Corre un test puntual |
| `dart format .` | Formatea el código |
| `flutter build web` | Build de producción para web |

## Despliegue

Cada push a `main` dispara `.github/workflows/deploy.yml`, que corre `flutter analyze` y
`flutter test`, construye con `flutter build web --release --base-href "/portfolio/"` y publica
el resultado en GitHub Pages.

## Notas de diseño

- **Una sola página, sin rutas**: cada sección vive en `lib/sections/`, está registrada en el enum
  `PortfolioSection` (que define el orden de scroll y de los links del nav) y se llega a ella vía
  `Scrollable.ensureVisible` desde `PortfolioShell`.
- **Tema claro/oscuro explícito** (no `ThemeMode.system`), con `AppThemeProvider` colgado del
  `builder` de `MaterialApp` —no de `home`— para que los diálogos (p. ej. el video demo de un
  proyecto) también puedan resolver el tema.
- **Breakpoint del nav desacoplado**: el nav colapsa a hamburguesa en 840px, no en 600px como el
  resto de los breakpoints de `atomic_design`, porque cinco links + marca + toggle de tema no caben
  en ese ancho.

## Pendiente

- Resaltado de la sección activa en el nav mientras se hace scroll (scroll-spy).
