import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:routemaster/routemaster.dart';
import 'package:social_network/helpers/image_helper.dart';
import 'package:social_network/repository/post_repository.dart';
import 'package:social_network/repository/upload_repository.dart';
import 'package:social_network/repository/auth_repository.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

final imageHelper = ImageHelper();

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  File? _image;
  final TextEditingController _captionController = TextEditingController();
  String _caption = '';
  bool _isLoading = false;
  showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Add Photo'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Take Photo'),
              onPressed: () async {
                final files =
                    await imageHelper.pickImage(source: ImageSource.camera);
                if (files.isNotEmpty) {
                  final croppedFile =
                      await imageHelper.crop(file: files.first!);
                  if (croppedFile != null) {
                    setState(() {
                      _image = File(croppedFile.path);
                    });
                  }
                }
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Choose From Gallery'),
              onPressed: () async {
                final files = await imageHelper.pickImage();
                if (files.isNotEmpty) {
                  final croppedFile =
                      await imageHelper.crop(file: files.first!);
                  if (croppedFile != null) {
                    setState(() {
                      _image = File(croppedFile.path);
                    });
                  }
                }
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  _androidDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Add Photo'),
          children: <Widget>[
            SimpleDialogOption(
              child: const Text('Take Photo'),
              onPressed: () async {
                final files =
                    await imageHelper.pickImage(source: ImageSource.camera);
                if (files.isNotEmpty) {
                  final croppedFile =
                      await imageHelper.crop(file: files.first!);
                  if (croppedFile != null) {
                    setState(() {
                      _image = File(croppedFile.path);
                    });
                  }
                }
              },
            ),
            SimpleDialogOption(
              child: const Text('Choose From Gallery'),
              onPressed: () async {
                final files = await imageHelper.pickImage();
                if (files.isNotEmpty) {
                  final croppedFile =
                      await imageHelper.crop(file: files.first!);
                  if (croppedFile != null) {
                    setState(() {
                      _image = File(croppedFile.path);
                    });
                  }

                }
              },
            ),
            SimpleDialogOption(
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void submit(context, ref) async {
    if (!_isLoading && _image != null && _caption.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      String token = ref.watch(userProvider)!.token;
      // Create post
      String imageUrl =
          await ref.watch(uploadRepositoryProvider).uploadPost(_image!, token);

      final errorModel = await ref
          .watch(postRepositoryProvider)
          .createPost(token: token, caption: _caption, photo: imageUrl);

      if (errorModel.data != null) {
        print("Create new post sucessfull!");
      } else {
        print(errorModel.error!);
      }
      _captionController.clear();

      Routemaster.of(context).pop();

      setState(() {
        _caption = '';
        _image = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final navigator = Routemaster.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: Colors.black,
          onPressed: () => navigator.pop(),
        ),
        title: const Text(
          'Create Post',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            color: Colors.black,
            icon: const Icon(Icons.add),
            onPressed: () {
              submit(context, ref);
            }  
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: height,
            child: Column(
              children: <Widget>[
                _isLoading
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.blue[200],
                          valueColor: const AlwaysStoppedAnimation(Colors.blue),
                        ),
                      )
                    : const SizedBox.shrink(),
                GestureDetector(
                  onTap: showSelectImageDialog,
                  child: Container(
                    height: width,
                    width: width,
                    color: Colors.grey[300],
                    child: _image == null
                        ? const Icon(
                            Icons.add_a_photo,
                            color: Colors.white70,
                            size: 150.0,
                          )
                        : Image(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    controller: _captionController,
                    style: const TextStyle(fontSize: 18.0),
                    decoration: const InputDecoration(
                      labelText: 'Caption',
                    ),
                    onChanged: (input) => _caption = input,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
