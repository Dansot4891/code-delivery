import 'package:authentication/common/component/pagination_list_view.dart';
import 'package:authentication/product/component/product_card.dart';
import 'package:authentication/product/model/product_model.dart';
import 'package:authentication/product/provider/product_provider.dart';
import 'package:authentication/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
      provider: productProvider,
      itemBuilder: <ProductModel>(context, index, model) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return RestaurantDetailScreen(id: model.restaurant.id);
            }));
          },
          child: ProductCard.fromProductModel(model: model));
      },
    );
  }
}
