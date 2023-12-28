import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:social_network/models/message_model.dart';
import 'package:social_network/constants/constants.dart';

final messageRepositoryProvider = Provider((ref) => MessageRepository(
      client: Client(),
    ));

class MessageRepository {
  final Client _client;
  MessageRepository({required Client client}) : _client = client;

  Future<MessageModel> addTextMessage({required String token, required String senderId, required String conversationId, required String body}) async {
    try {
      final message = MessageModel(
          conversationId: conversationId,
          sender: senderId,
          body: body,
          image: null,
          createdAt: null,
          updatedAt: null,
          id: '');

      var res = await _client
          .post(Uri.parse('$host/messages'), body: message.toJson(), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });

      if(res.statusCode == 201) {
        MessageModel messageModel = message.copyWith(
            sender: jsonDecode(res.body)['sender'],
            image: null,
            createdAt: jsonDecode(res.body)['createdAt'],
            updatedAt: jsonDecode(res.body)['updatedAt'],
            conversationId: jsonDecode(res.body)['conversationId'],
            body: jsonDecode(res.body)['body'],
            id: jsonDecode(res.body)['id']
          );
          return messageModel;
      } else {
        throw Exception("something went wrong");
      }

    } catch (e) {
      throw Exception(e);
    }
  }

  Future<MessageModel> addImageMessage({required String token, required String senderId, required String conversationId, required String image}) async {
    try {
      final message = MessageModel(
          conversationId: conversationId,
          sender: senderId,
          body: null,
          image: image,
          createdAt: null,
          updatedAt: null,
          id: '');

      var res = await _client
          .post(Uri.parse('$host/messages'), body: message.toJson(), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });

      if(res.statusCode == 201) {
        MessageModel messageModel = message.copyWith(
            sender: jsonDecode(res.body)['sender'],
            image: jsonDecode(res.body)['image'],
            createdAt: jsonDecode(res.body)['createdAt'],
            updatedAt: jsonDecode(res.body)['updatedAt'],
            conversationId: jsonDecode(res.body)['conversationId'],
            body: null,
            id: jsonDecode(res.body)['id']
          );
          return messageModel;
      } else {
        throw Exception("something went wrong");
      }

    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<MessageModel>> getMessages(
      {required String token, required String conversationId}) async {
    var res = await _client.get(Uri.parse('$host/messages/conversation/$conversationId'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token,
    });

    List<MessageModel> messages = [];
    switch (res.statusCode) {
      case 200:
        for (int i = 0; i < jsonDecode(res.body).length; i++) {
          messages
              .add(MessageModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
        }
        break;
    }

    return messages;
  }

  Future<MessageModel> getMessageById(
      {required String token, required String messageId}) async {
    var res = await _client.get(Uri.parse('$host/messages/$messageId'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token,
    });

    MessageModel? message;
    switch (res.statusCode) {
      case 200:
        message = MessageModel.fromJson(
          jsonEncode(
            jsonDecode(res.body),
          ),
        );

        break;
    }
    return message!;
  }

  
}
