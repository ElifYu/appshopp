import 'package:flutter/material.dart';

class CustomStepper extends StatefulWidget {
  final int? lowerLimit;
  final int? upperLimit;
  final int? stepValue;
  final double? iconSize;
  int? value;
  final ValueChanged<dynamic>? onChanged;

  CustomStepper({Key? key,
  @required this.value,
  @required this.iconSize,
  @required this.lowerLimit,
  @required this.stepValue,
  @required this.upperLimit,
  @required this.onChanged,
  }) : super(key: key);

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.white, blurRadius: 15, spreadRadius: 10)
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: (){
              setState(() {
                var value = widget.value!;
                widget.value = widget.value == widget.lowerLimit ?
                widget.lowerLimit : value -= widget.stepValue!;

                this.widget.onChanged!(widget.value);
              });
            },
          ),
          Container(
            width: this.widget.iconSize,
            child: Text('${widget.value}',
            style: TextStyle(
              fontSize: widget.iconSize! * 0.7
            ),
              textAlign: TextAlign.center,
           ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              setState(() {
                var value = widget.value!;
                widget.value = widget.value == widget.upperLimit ?
                widget.upperLimit : value += widget.stepValue!;

                this.widget.onChanged!(widget.value);

              });
            },
          ),
        ],
      ),
    );
  }
}
