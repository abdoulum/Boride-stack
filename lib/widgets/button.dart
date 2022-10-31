import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Widget child;
  final Function onClick;

  Button({required this.child, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: Colors.black12),
      child: Material(
        color: Colors.red,
        child: InkWell(
            onTap: onClick(),
            child: Center(
              child: child,
            )),
      ),
    );
  }
}