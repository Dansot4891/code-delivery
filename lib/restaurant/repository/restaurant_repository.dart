import 'package:authentication/common/const/data.dart';
import 'package:authentication/common/dio/dio.dart';
import 'package:authentication/common/model/cursor_pagination_model.dart';
import 'package:authentication/common/model/pagination_params.dart';
import 'package:authentication/common/repository/base_pagination_repository.dart';
import 'package:authentication/restaurant/model/restaurant_detail_model.dart';
import 'package:authentication/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');
  
  return repository;
});

@RestApi()
abstract class RestaurantRepository implements IBasePaginationRepository<RestaurantModel>{
  // baseUrl = http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl})
  = _RestaurantRepository;

  // http://$ip/restaurant/
  @GET('/')
  @Headers({
    'accessToken' : 'true'
  })
  Future<CursorPagination<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  // http://$ip/restaurant/:id
  @GET('/{id}')
  @Headers({
    'accessToken' : 'true'
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}