import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:social_network/models/conversation_model.dart';
import 'package:social_network/models/message_model.dart';
import 'package:social_network/models/user_model.dart';
import 'package:social_network/repository/auth_repository.dart';
import 'package:social_network/repository/conversation_repository.dart';
import 'package:social_network/repository/message_repository.dart';
import 'package:social_network/widgets/loader.dart';

class RecentChats extends ConsumerStatefulWidget {
  const RecentChats({super.key});

  @override
  ConsumerState<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends ConsumerState<RecentChats> {
  // List<ConversationModel>? _conversations;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getConversations();
  }

  // getConversations() async {
  //   final conversations = await ref
  //       .read(conversationRepositoryProvider)
  //       .getConversations(ref.read(userProvider)!.id);
  //   setState(() {
  //     _conversations = conversations;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    String currentUserId = ref.watch(userProvider)!.id;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: FutureBuilder(
            future: ref
                .watch(conversationRepositoryProvider)
                .getConversations(ref.watch(userProvider)!.token),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              List<ConversationModel> conversations = snapshot.data!;

              return ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (BuildContext context, int index) {
                  final ConversationModel conversation = conversations[index];
                  return FutureBuilder(
                      future: ref.watch(authRepositoryProvider).getUserWithId(
                          token: ref.watch(userProvider)!.token,
                          userId: conversation.users.singleWhere((element) =>
                              element != currentUserId)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Loader();
                        }
                        UserModel user = snapshot.data!;
                        if(conversation.messages!.isEmpty) {
                          return GestureDetector(
                                onTap: () => Routemaster.of(context).push(
                                  "/conversations/${conversation.id}"
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 35.0,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                user.avatar),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            user.username!,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5.0),
                                          Row(
                                            children: [
                                              const Text(
                                                'Start chat',
                                                style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 15.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(width: 10,),
                                              Text(
                                                DateFormat()
                                                    .add_jm()
                                                    .format(DateTime.parse(
                                                        conversation
                                                            .lastMessageAt!)),
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                        }
                        return FutureBuilder(
                            future: ref
                                .watch(messageRepositoryProvider)
                                .getMessageById(
                                    token: ref.watch(userProvider)!.token,
                                    messageId: conversation.messages![conversation.messages!.length - 1]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Loader();
                              }

                              MessageModel lastMessage = snapshot.data!;
                              // print(lastMessage.image);
                              String userStatus = currentUserId == user.id ? 'You' : user.username!;
                              return GestureDetector(
                                onTap: () => Routemaster.of(context).push(
                                  "/conversations/${conversation.id}"
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 35.0,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                user.avatar),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            user.username!,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5.0),
                                          Row(
                                            children: [
                                              Text(
                                                lastMessage.body != '' || lastMessage.body != null
                                                    ? '$userStatus: ${lastMessage.body!}'
                                                    : '$userStatus: Sent a image',
                                                style: const TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 15.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(width: 10,),
                                              Text(
                                                DateFormat()
                                                    .add_jm()
                                                    .format(DateTime.parse(
                                                        conversation
                                                            .lastMessageAt!)),
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      });
                },
              );
            }),
      ),
    );
  }
}
