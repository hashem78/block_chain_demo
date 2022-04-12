import 'package:block_chain_demo/state/log_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
