import 'package:authentication/common/const/data.dart';
import 'package:authentication/common/dio/dio.dart';
import 'package:authentication/common/model/cursor_pagination_model.dart';
import 'package:authentication/common/model/pagination_params.dart';
import 'package:authentication/common/repository/base_pagination_repository.dart';
import 'package:authentication/rating/model/rating_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_rating_repository.g.dart';

final restaurantRatingRepositoryProvider = Provider.family<RestaurantRatingRepository, String>((ref, id) {
  final dio = ref.watch(dioProvider);

  return RestaurantRatingRepository(dio, baseUrl: 'http://$ip/restaurant/$id/rating');
});

//http://ip/restaurant/:rid/rating
@RestApi()
abstract class RestaurantRatingRepository extends IBasePaginationRepository<RatingModel>{
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) = 
    _RestaurantRatingRepository;

  @GET('/')
  @Headers({
    'accessToken' : 'true'
  })
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}