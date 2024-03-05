import 'package:authentication/common/const/data.dart';
import 'package:authentication/restaurant/component/restaurant_card.dart';
import 'package:authentication/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get('http://$ip/restaurant',
        options: Options(headers: {
          'authorization': 'Bearer $accessToken',
        }));

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List>(
                future: paginateRestaurant(),
                builder: (context, AsyncSnapshot<List> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (_, index) {
                      return SizedBox(
                        height: 16,
                      );
                    },
                    itemBuilder: (_, index) {
                      final item = snapshot.data![index];
                      //parsed
                      final pitem = RestaurantModel.fromJson(json: item);
                      return RestaurantCard.fromModel(
                        model: pitem,
                      );
                    },
                  );
                })),
      ),
    );
  }
}
