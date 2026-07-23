import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:portfolio/data/models/profile.dart';

Future<Profile> loadProfile() async {
  final raw = await rootBundle.loadString('assets/data/profile.json');
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return Profile.fromJson(json);
}
