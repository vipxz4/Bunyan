import 'package:flutter/material.dart';

void main(){

  runApp(MyApp());  
}
@immutable
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  Text("data"),
    );
  }
}     
