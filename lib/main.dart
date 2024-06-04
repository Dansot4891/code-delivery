import 'package:authentication/common/provider/go_router.dart';
import 'package:authentication/common/view/splash_screen.dart';
import 'package:authentication/user/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {  
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(

        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'NotoSans',
        ),
        routerConfig: router,
      );
  }
}
