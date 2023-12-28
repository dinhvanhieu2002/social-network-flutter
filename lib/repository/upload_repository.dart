import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:social_network/constants/constants.dart';

final uploadRepositoryProvider = Provider((ref) => UploadRepository(
      client: http.Client(),
    ));

class UploadRepository {
  final http.Client _client;
  UploadRepository({required http.Client client}) : _client = client;

  Future<String> uploadPost(File imageFile, String token) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$host/upload/post'));
    request.headers['x-auth-token'] = token;
    final multipartFile = await http.MultipartFile.fromPath(
      'file', // This should match the name of the field in your server
      imageFile.path,
    );

    request.files.add(multipartFile);

    try {
      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        return jsonDecode(response.body)['secure_url'];
      } else {
        print('Image upload failed with status code ${response.statusCode}');
        return "upload faild";
      }
    } catch (e) {
      return "$e";
    }
  }

  Future<String> uploadAvatar(File imageFile, String token) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$host/upload/avatar'));
    request.headers['x-auth-token'] = token;
    final multipartFile = await http.MultipartFile.fromPath(
      'file', // This should match the name of the field in your server
      imageFile.path,
    );

    request.files.add(multipartFile);

    try {
      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        return jsonDecode(response.body)['secure_url'];
      } else {
        print('Image upload failed with status code ${response.statusCode}');
        return "upload faild";
      }
    } catch (e) {
      return "$e";
    }
  }

  Future<String> uploadMessage(File imageFile, String token) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$host/upload/message'));
    request.headers['x-auth-token'] = token;
    final multipartFile = await http.MultipartFile.fromPath(
      'file', // This should match the name of the field in your server
      imageFile.path,
    );

    request.files.add(multipartFile);

    try {
      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        return jsonDecode(response.body)['secure_url'];
      } else {
        print('Image upload failed with status code ${response.statusCode}');
        return "upload faild";
      }
    } catch (e) {
      return "$e";
    }
  }
}
