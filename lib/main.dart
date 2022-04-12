import 'package:block_chain_demo/presentation/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  // Use it only after calling `hiddenWindowAtLaunch`
  windowManager.waitUntilReadyToShow().then((_) async {
    // Hide window title bar
    await windowManager.setMinimumSize(Size(800, 600));
    await windowManager.center();
    await windowManager.show();
    await windowManager.setSkipTaskbar(false);
  });
  runApp(
    ProviderScope(child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      builder: () => MaterialApp(
        builder: (context, child) => ResponsiveWrapper.builder(
          ClampingScrollWrapper.builder(context, child!),
          breakpoints: const [
            ResponsiveBreakpoint.resize(350, name: MOBILE),
            ResponsiveBreakpoint.autoScale(600, name: TABLET),
            ResponsiveBreakpoint.resize(800, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
          ],
        ),
        title: 'Flutter Demo',
        home: const HomePage(),
      ),
    );
  }
}
