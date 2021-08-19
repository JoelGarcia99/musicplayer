import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({ Key? key }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  late Color bgColor;
  late Color borderColor;

  @override
  void initState() {
    
    bgColor = Colors.grey[300]!;
    borderColor = Colors.transparent;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: size.height*0.07,
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 2.0,
            color: bgColor,
            offset: Offset(0.0, 4.0),
          ),
        ],
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.grey[300],
      ),
      child: Center(
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor)
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor)
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor)
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor)
            ),
          ),
        ),
      ),
    );
  }
}