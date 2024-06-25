import 'package:authentication/common/const/colors.dart';
import 'package:authentication/common/layout/default_layout.dart';
import 'package:authentication/order/provider/order_provider.dart';
import 'package:authentication/order/view/order_done_screen.dart';
import 'package:authentication/product/component/product_card.dart';
import 'package:authentication/user/provider/basket_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    if(basket.isEmpty){
      return DefaultLayout(
        title: '장바구니',
        child: Center(
          child: Text('장바구니가 비어있습니다 ㅠㅠ'),
        ),
      );
    }

    final productsTotal = basket.fold<int>(0, (p, n) => p+n.product.price * n.count);
    final deliveryFee = basket.first.product.restaurant.deliveryFee;

    return DefaultLayout(
      title: "장바구니",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (_, index) {
                  return Divider(
                    height: 32.0,
                  );
                },
                itemCount: basket.length,
                itemBuilder: (_, index) {
                  final model = basket[index];
      
                  return ProductCard.fromProductModel(
                    model: model.product,
                    onAdd: () {
                      ref
                          .read(basketProvider.notifier)
                          .addToBasket(product: model.product);
                    },
                    onSubtract: () {
                      ref
                          .read(basketProvider.notifier)
                          .removeFromBasket(product: model.product);
                    },
                  );
                },
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '장바구니 금액',
                      style: TextStyle(
                        color: BODY_TEXT_COLOR,
                      ),
                    ),
                    Text(
                      '₩' + productsTotal.toString(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '배달비',
                      style: TextStyle(
                        color: BODY_TEXT_COLOR,
                      ),
                    ),
                    if(basket.length > 0)
                    Text(
                      '₩' + deliveryFee.toString(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '총액',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '₩' + (deliveryFee + productsTotal).toString(),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      final resp = await ref.read(orderProvider.notifier).postOrder();

                      if(resp){
                        context.goNamed(OrderDoneScreen.routeName);
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('결제 실패!'),),);
                      }
                    },
                    child: Text('결제하기', style: TextStyle(color: Colors.white,),),
                  ),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 1000 * 16,),
          ],
        ),
      ),
    );
  }
}
