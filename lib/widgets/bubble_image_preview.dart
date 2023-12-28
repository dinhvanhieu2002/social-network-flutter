import 'dart:io';
import 'package:flutter/material.dart';

class BubbleImagePreview extends StatefulWidget {
  final File? image;
  final VoidCallback onPress;
  final VoidCallback onExitMessage;

  const BubbleImagePreview({super.key, required this.image, required this.onPress, required this.onExitMessage});

  @override
  State<BubbleImagePreview> createState() => _BubbleImagePreviewState();
}

class _BubbleImagePreviewState extends State<BubbleImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      bottom: 30,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            SizedBox(
              width: 100,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                            image: FileImage(widget.image!),
                            fit: BoxFit.cover,
                          )
              ),
            ),
            Positioned(
              top: -20,
              right: -20,
              child: IconButton(icon: const Icon(Icons.close), onPressed: widget.onExitMessage,)),
            Positioned(
              left: 20,
              bottom: -10,
              child: ElevatedButton(
                onPressed: widget.onPress,
                child: const Text('Send', style: TextStyle(fontSize: 10)
                        )))
          ],
        ),
      ),
    );
  }
}
