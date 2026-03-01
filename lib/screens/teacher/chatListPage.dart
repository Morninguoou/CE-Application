import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/models/chat_list.dart';
import 'package:ce_connect_app/screens/teacher/chatPage.dart';
import 'package:ce_connect_app/service/chat_api.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:flutter/material.dart';

class ChatListPageT extends StatefulWidget {
  const ChatListPageT({
    super.key,
  });

  @override
  State<ChatListPageT> createState() => _ChatListPageTState();
}

class _ChatListPageTState extends State<ChatListPageT> {
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
    final accId = 'Thana';

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
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Chat', includeBackButton: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];

                return Dismissible(
                  key: Key(chat.roomId),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppColors.background,
                        title: const Text("Delete chat?"),
                        content: const Text("This will clear this conversation."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[600],
                            ),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) async {
                    try {
                      await ChatService().clearChat(
                        accId: _accId!,
                        roomId: chat.roomId,
                        clearSeq: chat.lastSeqNumber,
                      );

                      setState(() {
                        chats.removeAt(index);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Chat cleared")),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Failed to clear chat")),
                      );
                    }
                  },
                  child: ListTile(
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
                      style: chat.unreadCount > 0
                          ? TextWidgetStyles.text12LatoBold()
                          : TextWidgetStyles.text12LatoRegular(),
                    ),

                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatTime(chat.lastMessageTime),
                          style: chat.unreadCount > 0
                              ? TextWidgetStyles.text12LatoBold()
                              : TextWidgetStyles.text12LatoRegular(),
                        ),
                        const SizedBox(height: 4),
                        if (chat.unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              chat.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPageT(
                            otherMember: chat.otherMember,
                            roomId: chat.roomId,
                          ),
                        ),
                      ).then((_) {
                        fetchChats();
                      });
                    },
                  ),
                );
              }
            ),
    );
  }
}