import 'package:authentication/common/const/data.dart';
import 'package:authentication/common/dio/dio.dart';
import 'package:authentication/common/model/cursor_pagination_model.dart';
import 'package:authentication/restaurant/component/restaurant_card.dart';
import 'package:authentication/restaurant/model/restaurant_model.dart';
import 'package:authentication/restaurant/repository/restaurant_repository.dart';
import 'package:authentication/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List<RestaurantModel>> paginateRestaurant() async {
    final dio = Dio();

    dio.interceptors.add(
      CustomInterceptor(storage: storage)
    );
    final resp = await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant').paginate();

    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<RestaurantModel>>(
                future: paginateRestaurant(),
                builder: (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (_, index) {
                      return SizedBox(
                        height: 16,
                      );
                    },
                    itemBuilder: (_, index) {
                      final pitem = snapshot.data![index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RestaurantDetailScreen(
                                id: pitem.id,
                              ),
                            ),
                          );
                        },
                        child: RestaurantCard.fromModel(
                          model: pitem,
                        ),
                      );
                    },
                  );
                })),
      ),
    );
  }
}
