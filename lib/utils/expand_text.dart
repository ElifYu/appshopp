import 'package:appshop/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ExpandText extends StatefulWidget {
  String? labelHeader;
  String? desc;
  String? shortDesc;

  ExpandText({Key? key, this.desc, this.labelHeader, this.shortDesc}) : super(key: key);

  @override
  _ExpandTextState createState() => _ExpandTextState();
}

class _ExpandTextState extends State<ExpandText> {
  bool descTextShowFlag = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 7),
            child: Text(
              this.widget.labelHeader.toString(), style: TextStyle(
              fontSize: 17,
              color: color1,
              fontWeight: FontWeight.w500
            ),
            ),
          ),
          Html(
            data: this.widget.desc,
            style: {
              "div": Style(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                fontSize: FontSize.large
              )
            },
          ),
          Html(
            data: !descTextShowFlag ? '' :
            this.widget.shortDesc,
            style: {
              "div": Style(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  fontSize: FontSize.medium
              )
            },
          ),
          this.widget.shortDesc!.isNotEmpty ?
          Align(
            child: GestureDetector(
              onTap: (){
                setState(() {
                  descTextShowFlag = !descTextShowFlag;
                });
              },
              child: Text(descTextShowFlag ? "Show Less" : "Show More", style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w600
              ),),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}
