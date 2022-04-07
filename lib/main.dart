import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:http/http.dart' as http;
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

class LogItem {
  final String text;

  LogItem({this.text = ""});
}

class LogNotifier extends StateNotifier<List<LogItem>> {
  LogNotifier() : super([]);
  void addItem(LogItem item) {
    state = [...state, item];
  }
}

final logProvider = StateNotifierProvider<LogNotifier, List<LogItem>>(
  (_) => LogNotifier(),
);

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

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: const ActionsPane()),
          Expanded(child: const LogPane()),
        ],
      ),
    );
  }
}

class ActionsPane extends ConsumerWidget {
  const ActionsPane({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          child: Text('Actions'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(),
        ),
        Expanded(
          child: SizedBox(
            width: 0.5.sw,
            child: ListView(
              children: [
                ListTile(
                  title: Text('Send A Get Block Request'),
                  onTap: () async {
                    final notifier = ref.read(logProvider.notifier);
                    notifier.addItem(LogItem(text: "Sending Request"));
                    try {
                      final response = await http.get(
                        Uri.parse(
                          'http://52.55.214.106:8080/getBlock?blockId=testBlock',
                        ),
                      );
                      notifier.addItem(LogItem(text: response.body));
                    } catch (e) {
                      print(e);
                    }
                  },
                  onLongPress: () async {
                    final bid = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        return EnterBlockIdDialog();
                      },
                    );
                    if (bid != null) {
                      final notifier = ref.read(logProvider.notifier);
                      notifier.addItem(LogItem(text: "Sending Request"));
                      try {
                        final response = await http.get(
                          Uri.parse(
                            'http://52.55.214.106:8080/getBlock?blockId=$bid',
                          ),
                        );
                        notifier.addItem(LogItem(text: response.body));
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class EnterBlockIdDialog extends HookWidget {
  const EnterBlockIdDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    return AlertDialog(
      title: Text('Enter blockId'),
      content: SizedBox(
        width: 0.3.sw,
        child: TextField(
          controller: controller,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, controller.text);
          },
          child: Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}

class LogPane extends ConsumerWidget {
  const LogPane({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(logProvider);
    return ColoredBox(
      color: Colors.grey.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Text('Log'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          Expanded(
            child: SizedBox(
              width: 0.5.sw,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                controller: ScrollController(),
                itemBuilder: (context, index) {
                  return Text(state[index].text);
                },
                itemCount: state.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
