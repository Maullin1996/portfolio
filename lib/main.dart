import 'package:atomic_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AtomicDesignConfig.initializeFromAsset('assets/config/app_config.json');
  runApp(const PortfolioApp());
}
