import 'package:appshop/api_service.dart';
import 'package:appshop/models/product.dart';
import 'package:appshop/models/variable_product.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/widgets/widget_product_details.dart';
import 'package:flutter/material.dart';


class ProductDetails extends StatefulWidget {
  Product? product;
  ProductDetails({Key? key, this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  APIService? apiService;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this.widget.product!.type == 'variable' ? _variableProductList() :
      ProductDetailsWidget(data: this.widget.product),
    );
  }
  Widget _variableProductList() {
    apiService = APIService();
    return FutureBuilder(
      future: apiService!.getVariableProducts(this.widget.product!.id),
      builder: (BuildContext context, AsyncSnapshot model) {
        if(model.hasData){
          return ProductDetailsWidget(data: this.widget.product, variableProducts: model.data,);
        }
        return circularProgress();
      },
    );
  }
}
