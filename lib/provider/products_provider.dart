import 'package:appshop/api_service.dart';
import 'package:appshop/models/product.dart';
import 'package:flutter/cupertino.dart';

class SortBy{
  String value;
  String text;
  String sortOrder;

  SortBy(this.sortOrder, this.text, this.value);
}

enum LoadMoreStatus { INITIAL, LOADING, STABLE }

class ProductProvider with ChangeNotifier {
  APIService? _apiService;
  List<Product>? _productList;
  SortBy? _sortBy;

  int pageSize = 10;

  List<Product>? get allProducts => _productList;
  double get totalRecords => _productList!.length.toDouble();


  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;
  getLoadMoreStatus() => _loadMoreStatus;

  ProductProvider(){
    resetStreams();
    _sortBy = SortBy('date', 'Latest', "desc");
  }

  void resetStreams(){
    _apiService = APIService();
    _productList = <Product>[];
  }

  setLoadingState(LoadMoreStatus loadMoreStatus){
    _loadMoreStatus = loadMoreStatus;
    notifyListeners();
  }

  setSortOrder(SortBy sortBy){
    _sortBy = sortBy;
  }

  cleanSortOrder(){
    _sortBy = SortBy('date', 'Latest', "desc");
  }

  fetchProducts(pageNumber, {
    String? strSearch,
    String? tagName,
    String? categoryId,
    String? sortBy,
    var productsIDs,
    String sortOrder = "asc"
  }) async {
    List<Product> itemModel = await _apiService!.getProducts(
      strSearch: strSearch,
      tagName: tagName,
      pageNumber: pageNumber,
      productsIDs: productsIDs,
      pageSize: this.pageSize,
      categoryId: categoryId,
      sortBy: this._sortBy!.sortOrder,
      sortOrder: this._sortBy!.value
    );


    if(itemModel.length > 0){
      _productList!.addAll(itemModel);
    }

    setLoadingState(LoadMoreStatus.STABLE);
    notifyListeners();
  }
}