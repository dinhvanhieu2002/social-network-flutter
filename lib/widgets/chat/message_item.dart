import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_network/config/assets.dart';
import 'package:social_network/config/palette.dart';
import 'package:social_network/models/message_model.dart';
import 'package:social_network/widgets/image_full_screen.dart';

class MessageItem extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const MessageItem({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      buildMessageContainer(isMe, message, context),
      buildTimeStamp(context, isMe, message)
    ]);
  }

  buildMessageContainer(bool isMe, MessageModel message, BuildContext context) {
    double lrEdgeInsets = 1.0;
    double tbEdgeInsets = 1.0;
    if (message.body != null && message.body != '') {
      lrEdgeInsets = 15.0;
      tbEdgeInsets = 10.0;
    }

    return Row(
      mainAxisAlignment: isMe
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: buildMessageContent(isMe, message,context),
          padding: EdgeInsets.fromLTRB(
              lrEdgeInsets, tbEdgeInsets, lrEdgeInsets, tbEdgeInsets),
          constraints: const BoxConstraints(maxWidth: 200.0),
          decoration: BoxDecoration(
              color: isMe
                  ? Palette.selfMessageBackgroundColor
                  : Palette.otherMessageBackgroundColor,
              borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.only(
              right: isMe ? 10.0 : 0, left: isMe ? 0 : 10.0),
        )
      ], // aligns the chatitem to right end
    );
  }

  buildMessageContent(bool isMe, MessageModel message, BuildContext context) {
    if (message.body != null && message.body != '') {
      return Text(
        message.body!,
        style: TextStyle(
            color:
                isMe ? Palette.selfMessageColor : Palette.otherMessageColor),
      );
    } else if (message.image != null && message.image != '') {
      return GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ImageFullScreen('ImageMessage_${message.id}', message.image!))),
        child: Hero(
          tag: 'ImageMessage_${message.id}',
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(imageUrl:message.image!, placeholder: (_,url) => Image.asset(Assets.placeholder))),
        ),
      );
    } 
  }
  
  buildTimeStamp(BuildContext context, bool isMe, MessageModel message) {
    return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: isMe ? 0.0 : 10.0,
                right: isMe ? 10.0 : 0.0,
                top: 5.0,
                bottom: 5.0),
            child: Text(
              DateFormat('dd MMM kk:mm').format(
                  DateTime.parse(message.createdAt!)),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          )
        ]);
  }
}