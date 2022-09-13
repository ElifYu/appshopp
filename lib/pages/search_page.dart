import 'package:appshop/models/product.dart';
import 'package:appshop/provider/products_provider.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/utils/utils.dart';
import 'package:appshop/widgets/widget_product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetSearchPage extends StatefulWidget {
  const WidgetSearchPage({Key? key}) : super(key: key);

  @override
  _WidgetSearchPageState createState() => _WidgetSearchPageState();
}

class _WidgetSearchPageState extends State<WidgetSearchPage> {

  bool searchProduct = false;

  List saveHistory = [];
  TextEditingController searchController = TextEditingController();

  searchHistory() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(saveHistory.contains(searchController.text)){
      print('Same Word');
    }
    else{
      if(searchController.text.isNotEmpty){
        if(saveHistory.length < 10){
          saveHistory.add(searchController.text.toString());
          List<String> stringsList =  saveHistory.map((i)=> i.toString()).toList();
          prefs.setStringList('saveSearcHistory', stringsList);
          print(prefs.getStringList('saveSearcHistory'));
        }
        if(saveHistory.length == 10){
          print('10 nuncu');
          saveHistory.removeLast();
          saveHistory.insert(0, searchController.text.toString());
          List<String> stringsList =  saveHistory.map((i)=> i.toString()).toList();
          prefs.setStringList('saveSearcHistory', stringsList);
          print(prefs.getStringList('saveSearcHistory'));
        }
      }
    }
  }

  String filter = '';

  getHistory() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var get = prefs.getStringList('saveSearcHistory');
    setState(() {
      if(get != null){
        saveHistory = get;
      }
    });
  }

  var selectedIndex;
  final _sortByOptions = [
    SortBy("price", "Price: High to Low", "desc"),
    SortBy("rating", "Popularity", "desc"),
    SortBy("include", "Latest", "desc"),
    SortBy("price", "Price: Low to high", "asc"),
  ];

  FocusNode inputNode = FocusNode();
  void openKeyboard(){
    FocusScope.of(context).requestFocus(inputNode);
  }


  openKeyboardDuration() async{
    await Future.delayed(Duration(milliseconds: 950)).then((value){
      setState(() {
        WidgetsBinding.instance.addPostFrameCallback((_) => openKeyboard());
      });
    });
  }

  int _page = 1;
  ScrollController _scrollController = ScrollController();

  _onSearchChange() {
    FocusScope.of(context).unfocus();
    var productList = Provider.of<ProductProvider>(context, listen: false);
    productList.resetStreams();
    productList.setLoadingState(LoadMoreStatus.INITIAL);
    productList.fetchProducts(_page, strSearch: searchController.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHistory();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    var productList = Provider.of<ProductProvider>(context, listen: false);

    productList.resetStreams();
    productList.setLoadingState(LoadMoreStatus.INITIAL);

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        productList.setLoadingState(LoadMoreStatus.LOADING);
        productList.fetchProducts(++_page);
      }
    });
    openKeyboardDuration();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.2,
        titleSpacing: 5,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 65,
        title: Container(
          margin: EdgeInsets.only(top: 13, bottom: 13, left: 5),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(13),
          ),
          child: InkWell(

            borderRadius: BorderRadius.circular(13),
            child: TextField(
              onTap: () {
                setState(() {
                  searchProduct = false;
                });
              },
              focusNode: inputNode,
              textInputAction: TextInputAction.done,
              onSubmitted: (value){
                setState(() {
                  searchProduct = true;
                });
                searchHistory();
                _onSearchChange();
              },
              controller: searchController,
              cursorColor: Colors.black54,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF424874),
                  size: 24,
                ),

                hintText:  'Search products',
                hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
              ),
            )
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
              Get.back();
            },
            child: Text('Cancel', style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 16,
                fontWeight: FontWeight.w600
            ),),
          ),
          SizedBox(width: 6),
        ],
      ),
      body: searchProduct == false ?
      CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return saveHistory[index].toLowerCase().contains(filter.toLowerCase()) ? InkWell(
                onLongPress: () async{
                  FocusScope.of(context).unfocus();

                  Utils.showMessage(context, saveHistory[index], 'Remove from search history?',
                      'REMOVE', () async{
                        Navigator.pop(context);
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        setState(() {
                          saveHistory.removeAt(index);
                          List<String> stringsList=  saveHistory.map((i)=> i.toString()).toList();
                          pref.setStringList('saveSearcHistory', stringsList);
                        });
                      },
                      buttonText2: 'CANCEL',
                      isConfirmationDialog: true,
                      onPressed2: (){
                        Navigator.of(context).pop();
                      });

                },
                onTap: (){
                  setState(() {
                    searchProduct = true;
                    searchController.text = saveHistory[index];
                  });
                  searchHistory();
                  _onSearchChange();
                },
                child: ListTile(
                  contentPadding: EdgeInsetsDirectional.only(start: 19.0),
                  horizontalTitleGap: 3,
                  title: Text(saveHistory[index], style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),),
                  leading: LineIcon.history(color: Colors.black87, size: 26),
                ),
              ) : Container();
            },
              childCount: saveHistory.length,
            ),
          ),
        ],
      ) :
      Column(
        children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                  top: BorderSide(color: Colors.grey.shade200),
                )
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _sortByOptions.map((item) {
                return GestureDetector(
                  onTap: (){
                    var empty;
                    setState(() {
                      _page = 1;
                      selectedIndex = item.text;
                    });
                    FocusScope.of(context).unfocus();
                    var productList = Provider.of<ProductProvider>(context, listen: false);
                    productList.resetStreams();
                    productList.setLoadingState(LoadMoreStatus.INITIAL);
                    productList.setSortOrder(item ?? empty);
                    productList.fetchProducts(_page, strSearch: searchController.text);
                  },
                  child: selectedIndex == item.text ?
                  Center(
                    child: Container(
                        margin: EdgeInsets.only(left: 10, right: 2),
                        decoration: BoxDecoration(
                            color: color3,
                            border: Border.all(color: color2),
                            borderRadius: BorderRadius.circular(90)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 13, right: 9, bottom: 7, top: 7),
                          child: Row(
                            children: [
                              Text(item.text),
                              SizedBox(width: 4,),
                              LineIcon.angleRight(size: 15, color: color1,),
                            ],
                          ),
                        )),
                  ) :
                  Center(
                    child: Container(
                        margin: EdgeInsets.only(left: 10, right: 2),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(90)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 13, right: 9, bottom: 7, top: 7),
                          child: Row(
                            children: [
                              Text(item.text),
                              SizedBox(width: 4,),
                              LineIcon.angleRight(size: 15, color: color2,),
                            ],
                          ),
                        )),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
                builder: (context, productModel, child){
                  if(productModel.allProducts != null &&
                      productModel.allProducts!.length > 0 &&
                      productModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL){
                    return _buildList(productModel.allProducts, productModel.getLoadMoreStatus() == LoadMoreStatus.LOADING);
                  }
                  if(productModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL && productModel.allProducts!.length == 0){
                    return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Oops!', style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 25
                            ),),
                            SizedBox(height: 15),
                            Text('No products found',
                              textAlign: TextAlign.center,)
                          ],
                        )
                    );
                  }
                  return circularProgress();
                }
            ),
          ),
        ],
      )
    );
  }

  Widget _buildList(List<Product>? items, bool isLoadMore){

    return Column(
      children: [
        Flexible(
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 2 / 4.2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 0.1),
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: items!.length,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext ctx, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ProductCard(data: items[index],),
                );
              }
          ),
        ),
        Visibility(
          child: LinearProgressIndicator(
            minHeight: 3,
            backgroundColor: color1,
            valueColor: AlwaysStoppedAnimation<Color>(color3),
          ),
          visible: isLoadMore,
        )
      ],
    );
  }

  showAlertDialog(BuildContext context, title, index) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("REMOVE", style: TextStyle(
          fontSize: 14,
          color: Colors.blue[800]
      ),),
      onPressed: () async{

      },
    );

    Widget noButton = TextButton(
      child: Text("CANCEL", style: TextStyle(
          fontSize: 14,
          color: Colors.blue[800]
      ),),
      onPressed: () {
        Navigator.pop(context);
      },
    );


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title, maxLines: 1, style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17
      ),),
      content: Text('Remove from search history?', style: TextStyle(
          fontSize: 17
      ),),
      actions: [
        noButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
