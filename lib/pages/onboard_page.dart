
import 'package:appshop/pages/login_page.dart';
import 'package:appshop/utils/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class OnBoardPage extends StatefulWidget {
  const OnBoardPage({required Key key}) : super(key: key);

  @override
  _OnBoardPageState createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage>  with TickerProviderStateMixin{
  final PageController controller = PageController();

  bool showAgainToScreen = true;
  AnimationController? _breathingController;
  var _breathe = 0.0;
  var _breathe2 = 5.0;

  var size;
  var size2;

  List imagesOne = [
    "https://burst.shopifycdn.com/photos/light-up-sneakers.jpg?width=1850&format=pjpg&exif=1&iptc=1",
    "https://burst.shopifycdn.com/photos/pair-of-sunglasses-held-in-front-of-grey-background.jpg?width=1850&format=pjpg&exif=1&iptc=1",
    "https://burst.shopifycdn.com/photos/stacked-bracelets-set.jpg?width=1850&format=pjpg&exif=1&iptc=1",
  ];

  List imagesTwo = [
    "https://burst.shopifycdn.com/photos/teal-t-shirt.jpg?width=1850&format=pjpg&exif=1&iptc=1",
    "https://burst.shopifycdn.com/photos/light-pink-purse.jpg?width=1850&format=pjpg&exif=1&iptc=1"
  ];

  final CarouselController _controller = CarouselController();


  @override
  void initState() {
    super.initState();

    _breathingController = AnimationController(
        vsync: this, duration: Duration(seconds: 3));
    _breathingController!.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _breathingController!.reverse();

      } else if (status == AnimationStatus.dismissed){
        _breathingController!.forward();
      }
    });

    _breathingController!.addListener(() {
      setState(() {
        _breathe =_breathingController!.value;
        _breathe2 =_breathingController!.value;
      });
    });
    _breathingController!.forward();

  }



  @override
  Widget build(BuildContext context) {
    size = 100.0 - 15.0 * _breathe;
    size2 = 120.0 - 15.0 * _breathe2;
    return showAgainToScreen == true ?
    Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: color2,statusBarBrightness: Brightness.light,
          ),
          child: PageView(
            controller: controller,
            scrollDirection: Axis.vertical,
            onPageChanged: (value) async{
              print(value);
              if(value == 1) {
                await Future.delayed(Duration(milliseconds: 1400)).then((value) {
                  setState(() {
                    //showOnBoard = false;
                  });
                });
              }
            },
            children: <Widget>[
              Center(
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color1,
                                color2,
                                color2,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                                  child: Text("App Shop", style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 40,
                                      color: Colors.white
                                  ),),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                                  child: Text("Search for the product you want, and find it quickly. Thousands of products are on AppShop at affordable prices.", style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      height: 1.5
                                  ),),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 8, right: 8, top: 30, bottom: 40),
                                  width: MediaQuery.of(context).size.width,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text('Sign in', style: TextStyle(
                                        fontSize: 18,
                                        color: color1,
                                      ),),
                                    ),
                                    color: Colors.white70,
                                    onPressed: (){
                                      controller.animateToPage(1, duration: Duration(milliseconds: 1500), curve: Curves.ease,);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Wrap(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only( top: 60, left: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: color2,
                                            spreadRadius: 1,
                                            blurRadius: 15,
                                            offset: Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      height: size,
                                      width: size,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network( "https://burst.shopifycdn.com/photos/black-sneakers-with-white-sole.jpg?width=1850&format=pjpg&exif=1&iptc=1",
                                          fit: BoxFit.cover,),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 80, top: 70,),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: color2,
                                              spreadRadius: 1,
                                              blurRadius: 15,
                                              offset: Offset(0, 3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        height: 120,
                                        width: 120,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: CarouselSlider.builder(
                                              itemCount: imagesOne.length,
                                              options: CarouselOptions(
                                                  autoPlay: true,
                                                  viewportFraction: 1,
                                                  autoPlayInterval: Duration(seconds: 7),
                                                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                                                  autoPlayCurve: Curves.fastOutSlowIn,
                                                  aspectRatio: 1.0
                                              ),
                                              carouselController: _controller,
                                              itemBuilder: (context, index, int){
                                                return Image.network(imagesOne[index].toString(),
                                                  fit: BoxFit.cover,);
                                              }

                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Center(
                                child: Wrap(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: color2,
                                            spreadRadius: 1,
                                            blurRadius: 15,
                                            offset: Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      margin: EdgeInsets.only(left: 10, top: 20,),
                                      height: 140,
                                      width: 140,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        child: CarouselSlider.builder(
                                            itemCount: imagesTwo.length,
                                            options: CarouselOptions(
                                                autoPlay: true,
                                                viewportFraction: 1,
                                                autoPlayInterval: Duration(seconds: 9),
                                                autoPlayAnimationDuration: Duration(milliseconds: 800),
                                                autoPlayCurve: Curves.fastOutSlowIn,
                                                aspectRatio: 1.0
                                            ),
                                            carouselController: _controller,
                                            itemBuilder: (context, index, int){
                                              return Image.network(imagesTwo[index].toString(),
                                                fit: BoxFit.cover,);
                                            }

                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 100, top: 80,),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: color2,
                                              spreadRadius: 1,
                                              blurRadius: 15,
                                              offset: Offset(0, 3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        height: size2,
                                        width: size2,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.network("https://burst.shopifycdn.com/photos/gold-arrow-bracelet.jpg?width=1850&format=pjpg&exif=1&iptc=1",
                                            fit: BoxFit.cover,),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),

                    ],
                  )
              ),
              LoginPage()
            ],
          ),
        )
    ) : LoginPage();
  }
}