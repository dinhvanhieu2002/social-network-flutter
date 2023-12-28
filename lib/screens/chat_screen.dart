import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:routemaster/routemaster.dart';
import 'package:social_network/helpers/image_helper.dart';
import 'package:social_network/models/conversation_model.dart';
import 'package:social_network/models/message_model.dart';
import 'package:social_network/models/user_model.dart';
import 'package:social_network/repository/auth_repository.dart';
import 'package:social_network/repository/conversation_repository.dart';
import 'package:social_network/repository/message_repository.dart';
import 'package:social_network/repository/upload_repository.dart';
import 'package:social_network/widgets/bubble_image_preview.dart';
import 'package:social_network/widgets/chat/message_item.dart';
import 'package:social_network/widgets/loader.dart';
import 'package:social_network/config/config.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;
// import 'package:social_network/repository/socket_repository.dart';
// import 'package:socket_io_client/socket_io_client.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  // final ConversationModel conversation;
  // final UserModel user;

  const ChatScreen({super.key, required this.conversationId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}
final imageHelper = ImageHelper();

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController listScrollController = ScrollController();
  List<MessageModel>? _messages;
  UserModel? friendUser;
  ConversationModel? conversation;
  File? _image;
  final TextEditingController _captionController = TextEditingController();
  String _caption = '';
  bool _isLoading = false;
  // SocketRepository socketRepository = SocketRepository();
  // late Socket socket;

  ably.Realtime? realtimeInstance;
  var newMsgFromAbly = null;
  ably.RealtimeChannel? chatChannel;
  var myRandomClientId = '';

  _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: showSelectImageDialog,
          ),
          Expanded(
            child: TextField(
              controller: _captionController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (input) => _caption = input,
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: sendTextMessage,
          ),
        ],
      ),
    );
  }

  void sendTextMessage() async {
    if (!_isLoading && _caption.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      String token = ref.read(userProvider)!.token;
      String currentUserId = ref.read(userProvider)!.id;
      
      MessageModel savedMessage = await ref.watch(messageRepositoryProvider)
          .addTextMessage(token: token, senderId: currentUserId, body: _caption, conversationId: widget.conversationId);
      await ref.watch(conversationRepositoryProvider).updateConversation(token: token, id: widget.conversationId, messageId: savedMessage.id);    
      publishMyMessage(savedMessage);
      // Map<String, dynamic> map = {
      //     'receivedId': friendUser!.id,
      //     'id': savedMessage.id, 
      //     'conversationId': savedMessage.conversationId, 
      //     'sender': savedMessage.sender, 
      //     'image': savedMessage.image, 
      //     'body': savedMessage.body, 
      //     'createdAt': savedMessage.createdAt, 
      //     'updatedAt': savedMessage.updatedAt
      //   };
      //   sendMessage(map);
      // socketRepository.sendMessage(map);
      
      _captionController.clear();

      setState(() {
        _messages = [savedMessage, ..._messages! ];
        _caption = '';
        _isLoading = false;
      });
    }
  }

  void onExitMessage() {
    setState(() {
      _image = null;
    });
  }

  void sendImageMessage() async {
    if (!_isLoading && _image != null) {
      setState(() {
        _isLoading = true;
      });
      String token = ref.read(userProvider)!.token;
      String currentUserId = ref.read(userProvider)!.id;

      String imageUrl =
          await ref.watch(uploadRepositoryProvider).uploadPost(_image!, token);
      
      MessageModel savedMessage = await ref.watch(messageRepositoryProvider)
          .addImageMessage(token: token, senderId: currentUserId, image: imageUrl, conversationId: widget.conversationId);   

      await ref.watch(conversationRepositoryProvider).updateConversation(token: token, id: widget.conversationId, messageId: savedMessage.id);
      publishMyMessage(savedMessage);
      // Map<String, dynamic> map = {
      //     'receivedId': friendUser!.id,
      //     'id': savedMessage.id, 
      //     'conversationId': savedMessage.conversationId, 
      //     'sender': savedMessage.sender, 
      //     'image': savedMessage.image, 
      //     'body': savedMessage.body, 
      //     'createdAt': savedMessage.createdAt, 
      //     'updatedAt': savedMessage.updatedAt
      //   };
      // socketRepository.sendMessage(map);
      // sendMessage(map);
      
      setState(() {
        _messages = [savedMessage, ..._messages! ];
        _image = null;
        _isLoading = false;
      });
    }
  }

  // void connectToServer() {
  //   String currentUserId = ref.read(userProvider)!.id;
  //   try {
  //     socket = io("https://social-network-api-indol.vercel.app", <String, dynamic> {
  //       'transport': ['websocket'],
  //       'autoConnect': false
  //     });

  //     socket.connect();

  //     socket.on('getMessage', handleMessage);
  //     socket.emit('addUser', currentUserId);
  //   } on Exception catch (_, e) {
  //     print(e);
  //   }
  // }

  // sendMessage(Map<String, dynamic> data) {
  //     socket.emit("sendMessage",
  //       data
  //     );
  // }

  // void handleMessage(data) {
  //   print("handle message receiver");
  //   print(data);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // socketRepository.joinRoom(widget.conversationId);
    setupConversation();
    createAblyRealtimeInstance();
    // connectToServer();
    // socketRepository.getMessage((data) {
    //   MessageModel arrivalMessage = MessageModel(
    //     id: data['id'], 
    //     conversationId: data['conversationId'], 
    //     sender: data['sender'], 
    //     image: data['image'], 
    //     body: data['body'], 
    //     createdAt: data['createdAt'], 
    //     updatedAt: data['updatedAt']
    //   );

    //   setState(() {
    //     _messages = [arrivalMessage, ..._messages!];
    //   });
    // });
    
  }

  void createAblyRealtimeInstance() async {
    // if(friendUser != null) {
    //   String friendUserId = friendUser!.id;
    //   print(friendUserId);
    //   print("user khac null");

    // }
    
    myRandomClientId = ref.read(userProvider)!.id;
    var clientOptions = ably.ClientOptions(key: ablyAPIKey);
    clientOptions.clientId = myRandomClientId;
    try {
      realtimeInstance = ably.Realtime(options: clientOptions);
      print('Ably instantiated');
      chatChannel = realtimeInstance?.channels.get(widget.conversationId);
      subscribeToChatChannel();
      realtimeInstance?.connection
          .on(ably.ConnectionEvent.connected)
          .listen((ably.ConnectionStateChange stateChange) async {
        print('Realtime connection state changed: ${stateChange.event}');
      });
    } catch (error) {
      print('Error creating Ably Realtime Instance: $error');
      rethrow;
    }
  }

  void subscribeToChatChannel() {
    var messageStream = chatChannel?.subscribe();
    messageStream?.listen((ably.Message message) {
      MessageModel? newChatMsg;
      newMsgFromAbly = message.data;
      print("New message arrived ${message.data}");
      print("client Id");
      print(message.clientId);
      if (message.clientId != myRandomClientId) {
        newChatMsg = MessageModel(
          id: newMsgFromAbly['id'], 
          conversationId: newMsgFromAbly['conversationId'], 
          sender: newMsgFromAbly['sender'], 
          image: newMsgFromAbly['image'], 
          body: newMsgFromAbly['body'], 
          createdAt: newMsgFromAbly['createdAt'], 
          updatedAt: newMsgFromAbly['updatedAt']
        );
      } 
      

      setState(() {
        _messages = [newChatMsg!, ..._messages! ];
      });
    });
  }

  void publishMyMessage(MessageModel message) async {
    chatChannel?.publish(name: "chatMsg", data: {
      'id': message.id, 
      'conversationId': message.conversationId, 
      'sender': message.sender, 
      'image': message.image, 
      'body': message.body, 
      'createdAt': message.createdAt, 
      'updatedAt': message.updatedAt
    });
  }

  setupConversation() async {
    String currentUserId = ref.read(userProvider)!.id;
    ConversationModel con = await ref
        .read(conversationRepositoryProvider)
        .getConversationById(
            token: ref.read(userProvider)!.token,
            conversationId: widget.conversationId);
    String userId =
        con.users.singleWhere((element) => element != currentUserId);
    UserModel user = await ref
        .read(authRepositoryProvider)
        .getUserWithId(token: ref.read(userProvider)!.token, userId: userId);

    print("friend User");
    print(user.id);
                  
    List<MessageModel> messages = await ref.read(messageRepositoryProvider).getMessages(
                    token: ref.read(userProvider)!.token,
                    conversationId: widget.conversationId);              

    setState(() {
      conversation = con;
      friendUser = user;
      _messages = messages.reversed.toList();
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(userProvider)!.id;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // ignore: unnecessary_null_comparison
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 30.0,
            color: Colors.black,
            onPressed: () => Routemaster.of(context).pop()),
        title: friendUser != null ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
                SizedBox(
                    width: 30,
                    height: 30,
                    child: CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(friendUser!.avatar),
                    ),
                  )
                ,
            const SizedBox(
              width: 5.0,
            ),Text(
                    friendUser!.username!,
                    style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ,
          ],
        ) : const Loader(),
        elevation: 0.0,
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.black,
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: _messages != null ?
                     ListView.builder(
                      reverse: true,
                      controller: listScrollController,
                      padding: const EdgeInsets.only(top: 15.0),
                      itemCount: _messages!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final MessageModel message = _messages![index];
                        final bool isMe = message.sender == currentUserId;
                        return MessageItem(message: message, isMe: isMe);
                      },
                    ) : const Loader()
                    ),
                  
              _buildMessageComposer(),
            ],
          ),
          _image != null ? BubbleImagePreview(image: _image!, onPress: sendImageMessage, onExitMessage: onExitMessage) : const SizedBox(width: 0.0)

          ],
        ),
      ),
    );
  }
}
