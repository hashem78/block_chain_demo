import 'package:block_chain_demo/presentation/home/block_id_dialog.dart';
import 'package:block_chain_demo/state/log_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

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
                      builder: (context) => EnterBlockIdDialog(),
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
