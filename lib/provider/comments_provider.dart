

import 'package:appshop/api_service.dart';
import 'package:flutter/cupertino.dart';

import '../models/get_comments.dart';


enum LoadMoreStatus { INITIAL, LOADING, STABLE }

class ProductProviderComments with ChangeNotifier {
  APIService? _apiService;
  List<GetComments>? _getComments;

  int pageSize = 10;


  List<GetComments>? get allProductsComments => _getComments;
  double get totalRecordsComments => _getComments!.length.toDouble();

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;
  getLoadMoreStatus() => _loadMoreStatus;

  ProductProvider(){
    resetStreamsComments();
  }

  void resetStreamsComments(){
    _apiService = APIService();
    _getComments = <GetComments>[];
  }


  setLoadingState(LoadMoreStatus loadMoreStatus){
    _loadMoreStatus = loadMoreStatus;
    notifyListeners();
  }


  fetchComments(pageNumber, {
    int? pageSize,
    int? productID,
  }) async {
    List<GetComments> itemModel = await _apiService!.getComments(
        pageSize: this.pageSize,
        pageNumber: pageNumber,
        productId: productID.toString()
    );


    if(itemModel.length > 0){
      _getComments!.addAll(itemModel);
    }

    setLoadingState(LoadMoreStatus.STABLE);
    notifyListeners();
  }
}