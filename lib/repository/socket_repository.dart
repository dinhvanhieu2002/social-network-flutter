import 'dart:convert';

import 'package:social_network/clients/socket_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  void sendMessage(
      String senderId, String receiverId, String text, String image) {
    _socketClient.emit(
        "sendMessage", jsonEncode({senderId, receiverId, text, image}));
  }

  dynamic getMessage() {
    _socketClient.on('getMessage', (data) => data);
  }
}
