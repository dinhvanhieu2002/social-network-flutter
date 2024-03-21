import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:social_network/models/conversation_model.dart';
import 'package:social_network/constants/constants.dart';

final conversationRepositoryProvider = Provider((ref) => ConversationRepository(
      client: Client(),
    ));

class ConversationRepository {
  final Client _client;
  ConversationRepository({required Client client}) : _client = client;

  Future<ConversationModel?> addConversation({required String token, required String senderId, required String receivedId}) async {
    try {
      List<String> users =  [senderId, receivedId];
      final conversation = ConversationModel(
          lastMessageAt: null,
          messages: null,
          users: users,
          createdAt: null,
          updatedAt: null,
          id: '');

      var res = await _client
          .post(Uri.parse('$host/conversations'), body: conversation.toJson(), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });
      ConversationModel? con;
      switch (res.statusCode) {
        case 201:
          con = conversation.copyWith(
            id: jsonDecode(res.body)['id']
          );
          break;
    }

      return con;

    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<ConversationModel>> getConversations(
      String token) async {
    var res = await _client.get(Uri.parse('$host/conversations'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token,
    });

    List<ConversationModel> conversations = [];
    switch (res.statusCode) {
      case 200:
        for (int i = 0; i < jsonDecode(res.body).length; i++) {
          conversations
              .add(ConversationModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
        }
        break;
    }

    return conversations;
  }

  Future<ConversationModel> getConversationById(
      {required String token, required String conversationId}) async {
    var res = await _client.get(Uri.parse('$host/conversations/$conversationId'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token,
    });

    ConversationModel? conversation;
    switch (res.statusCode) {
      case 200:
        conversation = ConversationModel.fromJson(jsonEncode(jsonDecode(res.body)));
        break;
    }

    return conversation!;
  }

  Future<ConversationModel?> getConversationOfUser(
      {required String token, required String userId}) async {
    var res = await _client.get(Uri.parse('$host/conversations/user/$userId'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token,
    });

    ConversationModel? conversation;
    switch (res.statusCode) {
      case 200:
      print(res.body);
        // conversation = ConversationModel.fromJson(res.body);
        conversation = ConversationModel.fromJson(jsonEncode(jsonDecode(res.body)));
        break;
    }

    return conversation;
  }

  Future<void> updateConversation({required String token, required String id, required String messageId}) async {
    
    try {
      var res = await _client.put(Uri.parse('$host/conversations/$id'), 
        body: jsonEncode({'messageId': messageId}),
        headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });
      print(res.statusCode);
    } catch (e) {
      print(e);
    }
  }

  void removeConversation(String token, String id) async {
    try {
      var res = await _client.delete(Uri.parse('$host/conversations/$id'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });
      print(res.statusCode);
    } catch (e) {
      print(e);
    }
  }
}
