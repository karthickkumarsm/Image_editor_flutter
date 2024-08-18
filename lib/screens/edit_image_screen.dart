import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_editor/widgets/edit_image_viewmodel.dart';
import 'package:image_editor/widgets/image_text.dart';

class EditImageScreen extends StatefulWidget {
  final String selectedImage;
  const EditImageScreen({super.key, required this.selectedImage});

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends EditImageViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            _selectedImage,
            for (int i = 0; i < texts.length; i++)
              Positioned(
                left: texts[i].left,
                top: texts[i].top,
                child: GestureDetector(
                  onLongPress: () {
                    print('Long press detected');
                  },
                  onTap: () {
                    print('Single press detected');
                  },
                  child: Draggable(
                    feedback: ImageText(textInfo: texts[i]),
                    child: ImageText(textInfo: texts[i]),
                    onDragEnd: (drag){
                      final renderBox = context.findRenderObject() as RenderBox;
                      Offset off = renderBox.globalToLocal(drag.offset);
                      setState(() {
                        texts[i].top = off.dy;
                        texts[i].left = off.dx;
                      });
                    },
                  ),
                ),
              )
          ],
        ),
      )),
      floatingActionButton: _addnewTextFab,
    );
  }

  Widget get _selectedImage => Center(
        child: Image.file(
          File(widget.selectedImage),
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
      );

  Widget get _addnewTextFab => FloatingActionButton(
        onPressed: () => addNewDialog(context),
        backgroundColor: Colors.white,
        tooltip: 'Add new text',
        child: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
      );
}
