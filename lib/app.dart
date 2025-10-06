import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/binding/InitialBinding.dart';
import 'core/routes/AppRoutes.dart';
import 'core/theme/AppTheme.dart';
import 'modules/Post/views/PostPage.dart';

class KnovatorApp extends StatelessWidget {
  const KnovatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Knovator Posts',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBindings(),
      theme: AppTheme.light,
      getPages: AppRoutes.pages,
      home: const PostsPage(),
    );
  }
}