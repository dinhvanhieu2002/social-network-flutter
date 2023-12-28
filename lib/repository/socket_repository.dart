import 'package:social_network/clients/socket_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  void joinRoom(String conversationId) {
    _socketClient.emit('join', conversationId);
  }

  void sendMessage(Map<String, dynamic> data) {
    _socketClient.emit(
        "sendMessage", data);
  }

  void getMessage(Function(Map<String, dynamic>) func) {
    _socketClient.on('getMessage', (data) => func(data));
  }

  // dynamic getMessage() {
  //   _socketClient.on('getMessage', (data) => data);
  // }
}
