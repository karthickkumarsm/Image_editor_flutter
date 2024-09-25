import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_editor/models/text_info.dart';
import 'package:image_editor/screens/edit_image_screen.dart';
import 'package:image_editor/utils/utils.dart';
import 'package:image_editor/widgets/default_button.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

abstract class EditImageViewModel extends State<EditImageScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  List<TextInfo> texts = [];
  int CurrentIndex = 0;

  saveToGallery(BuildContext context){
    if(texts.isNotEmpty){
      screenshotController.capture().then((Uint8List? image){
        saveImage(image!);
         ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
      content: Text('Image saved',style: TextStyle(fontSize: 16.0),),
    ),
    );
      }).catchError((err)=> print(err));
    }
  }

  saveImage(Uint8List bytes) async{
    final time = DateTime.now().toIso8601String().replaceAll('.','-').replaceAll(':','-');
    final name = "screenshot_$time";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  removeText(BuildContext context){
    setState(() {
      texts.removeAt(CurrentIndex);
    });
     ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
      content: Text('Deleted',style: TextStyle(fontSize: 16.0),),
    ),
    );
  }

  setCurrentIndex(BuildContext context, index) {
    setState(() {
      CurrentIndex = index;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
      content: Text('Selected for styling',style: TextStyle(fontSize: 16.0),),
    ),
    );
  }

  changeTextColor(Color color){
    setState(() {
      texts[CurrentIndex].color = color;
    });
  }

  
increaseFontSize(){
    setState(() {
      texts[CurrentIndex].fontSize += 2;
    });
  }

decreaseFontSize(){
    setState(() {
      texts[CurrentIndex].fontSize -= 2;
    });
  }

 alignLeft(){
    setState(() {
      texts[CurrentIndex].textAlign = TextAlign.left;
    });
  }
 alignRight(){
    setState(() {
      texts[CurrentIndex].textAlign = TextAlign.right;
    });
  }
 alignCenter(){
    setState(() {
      texts[CurrentIndex].textAlign = TextAlign.center;
    });
  }
 boldText(){
    setState(() {
      if(texts[CurrentIndex].fontWeight==FontWeight.bold){
        texts[CurrentIndex].fontWeight = FontWeight.normal;
      }else{
        texts[CurrentIndex].fontWeight = FontWeight.bold;
      }
    });
  }
 italicText(){
    setState(() {
      if(texts[CurrentIndex].fontStyle == FontStyle.italic){
        texts[CurrentIndex].fontWeight = FontWeight.normal;
      }else{
        texts[CurrentIndex].fontStyle == FontStyle.italic;
      }
    });
  }

  addLinesToText() {
    setState(() {
      if( texts[CurrentIndex].text.contains('\n')){
         texts[CurrentIndex].text = texts[CurrentIndex].text.replaceAll('\n', ' ');
      }else{
      texts[CurrentIndex].text = texts[CurrentIndex].text.replaceAll(' ', '\n');
    }
  });
  }

  addNewText(BuildContext context) {
    setState(() {
      texts.add(TextInfo(
          text: textEditingController.text,
          left: 0,
          top: 50,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          fontSize: 20,
          textAlign: TextAlign.left));
      Navigator.of(context).pop();
    });
  }

  addNewDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Add new text"),
        content: TextField(
          controller: textEditingController,
          maxLines: 5,
          decoration: const InputDecoration(
              suffixIcon: Icon(Icons.edit),
              filled: true,
              hintText: 'Your Text Here'),
        ),
        actions: <Widget>[
          DefaultButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Back"),
              color: Colors.redAccent,
              textColor: Colors.white),
          DefaultButton(
              onPressed: () => addNewText(context),
              child: const Text("Add Text"),
              color: Colors.white,
              textColor: Colors.black)
        ],
      ),
    );
  }
}
