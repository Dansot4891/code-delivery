import 'package:authentication/common/const/colors.dart';
import 'package:authentication/common/layout/default_layout.dart';
import 'package:authentication/common/view/root_tab.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderDoneScreen extends StatelessWidget {
  static String get routeName => 'order_done';
  const OrderDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.thumb_up_alt_outlined,
            color: PRIMARY_COLOR,
            size: 50,
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            '결제가 완료되었습니다.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 32,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              context.goNamed(RootTab.routeName);
            },
            child: Text(
              '홈으로',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
