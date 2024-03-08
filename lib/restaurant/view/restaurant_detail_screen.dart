import 'package:authentication/common/const/data.dart';
import 'package:authentication/common/layout/default_layout.dart';
import 'package:authentication/product/component/product_card.dart';
import 'package:authentication/restaurant/component/restaurant_card.dart';
import 'package:authentication/restaurant/model/restaurant_detail_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;
  const RestaurantDetailScreen({required this.id, super.key});

  Future<Map<String,dynamic>> getRestaurantDetail() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$ip/restaurant/$id',
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
    );

    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: FutureBuilder(
        future: getRestaurantDetail(),
        builder: (_, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          print(snapshot);
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final item = RestaurantDetailModel.fromJson(json: snapshot.data!);

          return CustomScrollView(
            slivers: [
              renderTop(
                model: item
              ),
              renderLable(),
              renderProduect(
                products: item.products
              ),
            ],
          );
        },
      ),
    );
  }

  SliverPadding renderLable() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  renderProduect({
    required List<RestaurantProduectModel> products
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final model = products[index];
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ProductCard.fromModel(model: model),
          );
        }, childCount: products.length),
      ),
    );
  }
}
