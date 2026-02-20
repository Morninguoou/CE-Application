import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/models/chat_list.dart';
import 'package:ce_connect_app/screens/student/chatPage.dart';
import 'package:ce_connect_app/service/chat_api.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:flutter/material.dart';

class ChatListPageS extends StatefulWidget {
  const ChatListPageS({
    super.key,
  });

  @override
  State<ChatListPageS> createState() => _ChatListPageSState();
}

class _ChatListPageSState extends State<ChatListPageS> {
  List<ChatRoom> chats = [];
  bool isLoading = true;
  String? _accId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final accId = context.read<SessionProvider>().accId;
    final accId = '65010782';

    if (_accId != accId && accId.isNotEmpty) {
      _accId = accId;
      fetchChats();
    }
  }

  Future<void> fetchChats() async {
    if (_accId == null || _accId!.isEmpty) return;

    try {
      final result = await ChatService().fetchChatList(_accId!);
      setState(() {
        chats = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }


  String formatTime(String isoTime) {
    if (isoTime.isEmpty) return "";

    try {
      final date = DateTime.parse(isoTime);
      return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(title: 'Chat', includeBackButton: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];

                return ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.05),

                  title: Text(
                    chat.otherMember,
                    style: TextWidgetStyles.text14LatoBold(),
                  ),

                  subtitle: Text(
                    chat.lastMessage.isEmpty
                        ? "No messages yet"
                        : chat.lastMessage,
                    style: TextWidgetStyles.text12LatoRegular(),
                  ),

                  trailing: Text(
                    formatTime(chat.lastMessageTime),
                    style: TextWidgetStyles.text12LatoRegular(),
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPageS(
                          otherMember: chat.otherMember,
                          roomId: chat.roomId,
                        ),
                      ),
                    ).then((_) {
                      fetchChats();
                    });
                  },
                );
              },
            ),
    );
  }
}