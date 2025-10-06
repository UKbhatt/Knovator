import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // hive for offline support

  await Hive.openBox('postsBox');
  await Hive.openBox('readBox');
  await Hive.openBox('metaBox');

  final meta = Hive.box('metaBox');
  final isInitialized = meta.get('initialized', defaultValue: false) as bool;
  if (!isInitialized) {
    await Hive.box('readBox').put('readIds', <int>[]);
    await meta.put('initialized', true);
  }

  runApp(const KnovatorApp());
}
