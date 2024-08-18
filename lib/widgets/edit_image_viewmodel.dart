import 'package:flutter/material.dart';
import 'package:image_editor/screens/edit_image_screen.dart';
import 'package:image_editor/widgets/default_button.dart';

abstract class EditImageViewModel extends State<EditImageScreen> {
  TextEditingController textEditingController = TextEditingController();
  
  addNewText(BuildContext context){
    setState(() {
      
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
              onPressed: () => {},
              child: const Text("Add Text"),
              color: Colors.white,
              textColor: Colors.black)
        ],
      ),
    );
  }
}
