import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network/helpers/image_helper.dart';
import 'package:social_network/models/user_model.dart';
import 'package:social_network/repository/auth_repository.dart';
import 'package:social_network/repository/upload_repository.dart';

final imageHelper = ImageHelper();

class EditProfileScreen extends ConsumerStatefulWidget {
  final UserModel user;
  final Function updateUser;

  const EditProfileScreen(
      {super.key, required this.user, required this.updateUser});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _profileImage;
  String _username = '';
  String _fullName = '';
  String _bio = '';
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _username = widget.user.username!;
    _fullName = widget.user.fullName;
    _bio = widget.user.bio;
  }

  handleImageFromGallery() async {
    final files = await imageHelper.pickImage(source: ImageSource.gallery);
    if (files.isNotEmpty) {
      final croppedFile = await imageHelper.crop(file: files.first!);
      if (croppedFile != null) {
        setState(() {
          _profileImage = File(croppedFile.path);
        });
      }
    }
  }

  displayProfileImage() {
    // No new profile image
    if (_profileImage == null) {
      // No existing profile image
      if (widget.user.avatar.isNotEmpty) {
        // User profile image exists
        return CachedNetworkImageProvider(widget.user.avatar);
      }
    } else {
      // New profile image
      return FileImage(_profileImage!);
    }
  }

  submit(context) async {
    if (_formKey.currentState!.validate() && !_isLoading) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      // Update user in database
      String profileImageUrl = '';

      if (_profileImage == null) {
        profileImageUrl = widget.user.avatar;
      } else {
        profileImageUrl = await ref
            .watch(uploadRepositoryProvider)
            .uploadAvatar(_profileImage!, ref.read(userProvider)!.token);
      }

      UserModel user = UserModel(
          id: widget.user.id,
          username: _username,
          email: '',
          fullName: _fullName,
          avatar: profileImageUrl,
          bio: _bio,
          password: '',
          following: [],
          followers: [],
          token: '');

          print(profileImageUrl);
      await ref.watch(authRepositoryProvider).updateProfile(token: ref.watch(userProvider)!.token, user: user);
      widget.updateUser(user);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        shadowColor: Colors.transparent,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop()),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            _isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: const AlwaysStoppedAnimation(Colors.blue),
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 60.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: displayProfileImage(),
                    ),
                    TextButton(
                      onPressed: handleImageFromGallery,
                      child: const Text(
                        'Change Profile Image',
                        style: TextStyle(color: Colors.blue, fontSize: 16.0),
                      ),
                    ),
                    TextFormField(
                      initialValue: _username,
                      style: const TextStyle(fontSize: 18.0),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.person,
                          size: 30.0,
                        ),
                        labelText: 'Username',
                      ),
                      validator: (input) => input!.trim().isEmpty
                          ? 'Please enter a valid username'
                          : null,
                      onSaved: (input) => _username = input!,
                    ),
                    TextFormField(
                      initialValue: _fullName,
                      style: const TextStyle(fontSize: 18.0),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.person_2,
                          size: 30.0,
                        ),
                        labelText: 'Full Name',
                      ),
                      validator: (input) => input!.trim().length > 150
                          ? 'Please enter a valid fullname'
                          : null,
                      onSaved: (input) => _fullName = input!,
                    ),
                    TextFormField(
                      initialValue: _bio,
                      style: const TextStyle(fontSize: 18.0),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.book,
                          size: 30.0,
                        ),
                        labelText: 'Bio',
                      ),
                      validator: (input) => input!.trim().length > 150
                          ? 'Please enter a bio less than 150 characters'
                          : null,
                      onSaved: (input) => _bio = input!,
                    ),
                    Container(
                      margin: const EdgeInsets.all(40.0),
                      height: 40.0,
                      width: 250.0,
                      child: ElevatedButton(
                        onPressed: () => submit(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            textStyle: const TextStyle(color: Colors.white)),
                        child: const Text(
                          'Save Profile',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
