import 'package:authentication/common/const/colors.dart';
import 'package:authentication/common/layout/default_layout.dart';
import 'package:authentication/common/model/cursor_pagination_model.dart';
import 'package:authentication/common/utils/pagination_utils.dart';
import 'package:authentication/product/component/product_card.dart';
import 'package:authentication/product/model/product_model.dart';
import 'package:authentication/rating/component/rating_card.dart';
import 'package:authentication/rating/model/rating_model.dart';
import 'package:authentication/restaurant/component/restaurant_card.dart';
import 'package:authentication/restaurant/model/restaurant_detail_model.dart';
import 'package:authentication/restaurant/model/restaurant_model.dart';
import 'package:authentication/restaurant/provider/restaurant_provider.dart';
import 'package:authentication/restaurant/provider/restaurant_rating_provider.dart';
import 'package:authentication/restaurant/view/basket_screen.dart';
import 'package:authentication/user/provider/basket_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletons/skeletons.dart';
import 'package:badges/badges.dart' as badges;

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'restaurantDetail';
  final String id;
  const RestaurantDetailScreen({required this.id, super.key});

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(
        restaurantRatingProvider(widget.id).notifier,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);

    if (state == null) {
      return DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return DefaultLayout(
      title: '불타는 떡볶이',
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(BasketScreen.routeName);
        },
        backgroundColor: PRIMARY_COLOR,
        child: badges.Badge(
          badgeStyle: badges.BadgeStyle(
            badgeColor: Colors.white,
            borderRadius: BorderRadius.circular(0),
          ),
          showBadge: basket.isNotEmpty,
          badgeContent: Text(
            basket.fold<int>(0, (previous, next) => previous + next.count).toString(),
            style: TextStyle(
              color: PRIMARY_COLOR,
            ),
          ),
          child: Icon(
            Icons.shopping_basket_outlined,
            color: Colors.white,
          ),
        ),
      ),
      child: CustomScrollView(
        controller: controller,
        slivers: [
          renderTop(
            model: state,
          ),
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLable(),
          if (state is RestaurantDetailModel)
            renderProduct(
              products: state.products,
              restaurant: state,
            ),
          if (ratingsState is CursorPagination<RatingModel>)
            renderRatings(models: ratingsState.data),
        ],
      ),
    );
  }

  SliverPadding renderRatings({
    required List<RatingModel> models,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  child: RatingCard.fromModel(
                    model: models[index],
                  ),
                ),
            childCount: models.length),
      ),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: SkeletonParagraph(
                style: SkeletonParagraphStyle(
                  lines: 5,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
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
    required RestaurantModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  renderProduct({
    required List<RestaurantProduectModel> products,
    required RestaurantModel restaurant,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];
            return InkWell(
              onTap: () {
                ref.read(basketProvider.notifier).addToBasket(
                        product: ProductModel(
                      id: model.id,
                      name: model.name,
                      detail: model.detail,
                      imgUrl: model.imgUrl,
                      price: model.price,
                      restaurant: restaurant,
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ProductCard.fromRestaurantProductModel(model: model),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}
