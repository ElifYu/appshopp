import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckPoints extends StatelessWidget{
  final int checkedTill;
  final List<String>? checkPoints;
  final Color? checkPointFilledColor;

  CheckPoints({Key? key, this.checkedTill = 1, this.checkPoints, this.checkPointFilledColor});

  final double circleDia = 32;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (c, s)  {
          final double cWidth = ((s.maxHeight - (32.0 * (checkPoints!.length + 1))) / (checkPoints!.length - 1));

          return Container(
            height: 65,
            margin: EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: checkPoints!.map((e) {
                      int index = checkPoints!.indexOf(e);
                      print(index);
                      return Row(
                        children: [
                          Container(
                            width: circleDia,
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.done,
                              color: Colors.white,
                              size: 18,),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index <= checkedTill
                                  ? checkPointFilledColor
                                  : checkPointFilledColor!.withOpacity(0.2) ,
                            ),
                          ),
                          index != (checkPoints!.length - 1) ?
                          Container(
                            color: index < checkedTill
                                ? checkPointFilledColor
                                : checkPointFilledColor!.withOpacity(0.2),
                            height: 4,
                            width: MediaQuery.of(context).size.width / 3.8,
                          ) : Container()
                        ],
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: checkPoints!.map((e) {
                      return Text(e, style: TextStyle(
                        fontSize: 15
                      ),);
                    }).toList(),
                  ),
                )
              ],
            ),
          );
        }
    );
  }
}