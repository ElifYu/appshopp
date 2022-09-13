import 'package:appshop/utils/colors.dart';
import 'package:flutter/material.dart';

class ProgressHUD extends StatelessWidget {

  final Widget? child;
  final bool? inAsyncCall;
  final double opacity;
  final Color color;
  final Animation<Color>? valueColor;

  ProgressHUD({
    Key? key,
    this.child,
    this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = <Widget>[];
    widgetList.add(child!);
    if (inAsyncCall!) {
      final modal = Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          circularProgress(),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}

Widget circularProgress(){
  return Center(
    child: CircularProgressIndicator(color: color3, strokeWidth: 3.3,
      backgroundColor: color1,
    ),
  );
}