import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plantsnap/pages/homepage.dart';

class Identifypage extends StatefulWidget {
  final File? selectedImage;
  // final int login;
  const Identifypage({super.key,required this.selectedImage,});

  @override
  State<Identifypage> createState() => _IdentifypageState();
}

class _IdentifypageState extends State<Identifypage> {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("PlantSnap"),
          backgroundColor: Colors.greenAccent,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              Text("Identification of Image",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text("Selected Image :"),
              SizedBox(height: 10,),
              if (widget.selectedImage != null)
              Image.file(
                widget.selectedImage!,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              )
            else
              Text("No image selected"),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: ()=>Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Homepage(login: 0),)),
                    child: Text("Re-Select"),
                  ),
                  ElevatedButton(
                    onPressed: (){},
                    child: Text("Identify"),
                  ),
                ],
              ),
            ),
              
      
            ],
          ),
        ),
      ),
    );
  }
}