import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final String? title;
  final Widget? bottomNavigationBar;
  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppbar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
  AppBar? renderAppbar(){
    if(title == null){
      return null;
    }else{
      return AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0, //앞으로 튀어나온듯한 효과
        title: Text(
          title!,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),
        ),
        foregroundColor: Colors.black,//앱바 위에 올라오는 것들의 색상
      );
    }
  }
}