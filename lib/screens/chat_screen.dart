// import 'package:flutter/material.dart';
// import 'package:social_network/models/message_model.dart';
// import 'package:social_network/models/user_model.dart';

// class ChatScreen extends StatefulWidget {
//   final UserModel user;

//   const ChatScreen({super.key, required this.user});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   _buildMessage(MessageModel message, bool isMe) {
//     final Container msg = Container(
//       margin: isMe
//           ? const EdgeInsets.only(
//               top: 8.0,
//               bottom: 8.0,
//               left: 80.0,
//             )
//           : const EdgeInsets.only(
//               top: 8.0,
//               bottom: 8.0,
//             ),
//       padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
//       width: MediaQuery.of(context).size.width * 0.75,
//       decoration: BoxDecoration(
//         color: isMe ? Colors.blueAccent : const Color(0xFFFFEFEE),
//         borderRadius: isMe
//             ? const BorderRadius.only(
//                 topLeft: Radius.circular(15.0),
//                 bottomLeft: Radius.circular(15.0),
//               )
//             : const BorderRadius.only(
//                 topRight: Radius.circular(15.0),
//                 bottomRight: Radius.circular(15.0),
//               ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             message.createdAt,
//             style: const TextStyle(
//               color: Colors.blueGrey,
//               fontSize: 16.0,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 8.0),
//           Text(
//             message.body,
//             style: const TextStyle(
//               color: Colors.blueGrey,
//               fontSize: 16.0,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//     if (isMe) {
//       return msg;
//     }
//   }

//   _buildMessageComposer() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       height: 70.0,
//       color: Colors.white,
//       child: Row(
//         children: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.photo),
//             iconSize: 25.0,
//             color: Theme.of(context).primaryColor,
//             onPressed: () {},
//           ),
//           Expanded(
//             child: TextField(
//               textCapitalization: TextCapitalization.sentences,
//               onChanged: (value) {},
//               decoration: const InputDecoration.collapsed(
//                 hintText: 'Send a message...',
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.send),
//             iconSize: 25.0,
//             color: Theme.of(context).primaryColor,
//             onPressed: () {},
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       appBar: AppBar(
//         title: Text(
//           widget.user.username!,
//           style: const TextStyle(
//             fontSize: 28.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         elevation: 0.0,
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.more_horiz),
//             iconSize: 30.0,
//             color: Colors.white,
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30.0),
//                     topRight: Radius.circular(30.0),
//                   ),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(30.0),
//                     topRight: Radius.circular(30.0),
//                   ),
//                   child: ListView.builder(
//                     reverse: true,
//                     padding: const EdgeInsets.only(top: 15.0),
//                     itemCount: messages.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       final Message message = messages[index];
//                       final bool isMe = message.userId == currentUser.id;
//                       return _buildMessage(message, isMe);
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             _buildMessageComposer(),
//           ],
//         ),
//       ),
//     );
//   }
// }