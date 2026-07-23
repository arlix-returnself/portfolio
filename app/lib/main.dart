import 'package:flutter/widgets.dart';
import 'package:portfolio/core/bootstrap.dart';
import 'package:portfolio/core/config/config_loader.dart';
import 'package:portfolio/data/models/profile.dart';
import 'package:portfolio/data/profile_repository.dart';

// Entry point
void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load configs and environment varialbles
  final configs = await getConfigs(args);

  // Load profile content (content/profile.yaml, via scripts/build.rs's
  // generated app/assets/data/profile.json) before the first frame.
  Profile? profile;
  try {
    profile = await loadProfile();
  } catch (_) {
    profile = null;
  }

  // Run bootstrap
  await bootstrap(configs, profile);
}


