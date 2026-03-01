import 'dart:convert';
import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/models/chat_message.dart';
import 'package:ce_connect_app/service/chat_api.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPageT extends StatefulWidget {
  final String otherMember;
  final String roomId;

  const ChatPageT({
    super.key,
    required this.otherMember,
    required this.roomId,
  });

  @override
  State<ChatPageT> createState() => _ChatPageTState();
}

class _ChatPageTState extends State<ChatPageT> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late WebSocketChannel _channel;

  String? _accId;
  String? _roomId;
  String _appBarTitle = "Chat";
  bool _isLoading = true;
  bool _isChatEnded = false;

  List<ChatMessage> _messages = [];
  final Set<String> _pendingMessages = {};

  String _formatTime(String isoString) {
    final dateTime = DateTime.parse(isoString);

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return "$hour:$minute";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final accId = 'Thana';

    if (_accId != accId && accId.isNotEmpty) {
      _accId = accId;
      _openChat();
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openChat() async {
    if (_accId == null || _accId!.isEmpty) return;

    try {
      final service = ChatService();

      final response = await service.openChat(
        accId: _accId!,
        person2: widget.otherMember,
      );

      _roomId = widget.roomId;

      final history =
          await service.fetchChatHistory(_roomId!, _accId!);

      setState(() {
        _appBarTitle = response.fullNameEn;
        _isChatEnded = response.endTitleStatus;
        _messages = history;
        _isLoading = false;
      });

      _scrollToBottom();
      _connectWebSocket();

      if (_messages.isNotEmpty) {
        _sendSeen();
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _connectWebSocket() {
    if (_accId == null) return;

    _channel = WebSocketChannel.connect(
      Uri.parse('ws://127.0.0.1:8080/chat/ws?accId=$_accId'),
    );

    _channel.sink.add(jsonEncode({
      "type": "join",
      "room_id": widget.roomId,
    }));

    _channel.stream.listen(
      (data) {
        try {
          final decoded = jsonDecode(data);
          if (decoded is! Map<String, dynamic>) return;

          final message = ChatMessage.fromJson(decoded);
          if (message.roomId != widget.roomId) return;

          if (message.type == "message") {
            final key =
                "${message.roomId}:${message.content}";

            if (_pendingMessages.contains(key)) {
              _pendingMessages.remove(key);
              return;
            }

            setState(() {
              _messages.add(message);
            });

            _scrollToBottom();
            _sendSeen();
            return;
          }

          if (message.type == "end") {
            setState(() {
              _isChatEnded = true;
            });
            return;
          }
        } catch (e) {
          print("WS PARSE ERROR: $e");
        }
      },
      cancelOnError: false,
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || _roomId == null || _isChatEnded)
      return;

    _channel.sink.add(jsonEncode({
      "type": "message",
      "room_id": widget.roomId,
      "content": text,
    }));

    final key = "${widget.roomId}:$text";
    _pendingMessages.add(key);

    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
        roomId: widget.roomId,
        sender: _accId!,
        content: text,
        createdAt: DateTime.now().toIso8601String(),
        type: "message",
      ));
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _sendSeen() {
    if (_roomId == null || _accId == null) return;
    if (_messages.isEmpty) return;

    final lastMsg = _messages.lastWhere(
      (m) => m.seqNumber != null,
      orElse: () => _messages.last,
    );

    if (lastMsg.seqNumber == null) return;

    _channel.sink.add(jsonEncode({
      "type": "seen",
      "room_id": _roomId,
      "last_seq": lastMsg.seqNumber,
      "reader": _accId,
    }));
  }

  void _endChat() {
    if (_roomId == null) return;

    _channel.sink.add(jsonEncode({
      "type": "end",
      "room_id": _roomId,
      "content": "Conversation ended",
    }));

    setState(() {
      _isChatEnded = true;
    });
  }

  Widget _buildEndButton() {
    if (_isChatEnded) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightblue,
          ),
          onPressed: _endChat,
          child: Text(
            "End Chat",
            style: TextWidgetStyles.text14LatoRegular()
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
   return Container(
     padding: EdgeInsets.only(
       left: 12,
       right: 12,
       top: 8,
       bottom: MediaQuery.of(context).viewPadding.bottom + 8,
     ),
     color: AppColors.lightyellow,
     child: Row(
       children: [
         Expanded(
           child: TextField(
             controller: _messageController,
             textInputAction: TextInputAction.send,
             onSubmitted: (_) => _sendMessage(),
             decoration: const InputDecoration(
               hintText: "Message...",
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.all(Radius.circular(30)),
               ),
               contentPadding:
                   EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               filled: true,
               fillColor: Colors.white,
             ),
           ),
         ),
         const SizedBox(width: 8),
         CircleAvatar(
           backgroundColor: Colors.blue,
           child: IconButton(
             icon: const Icon(Icons.send, color: Colors.white),
             onPressed: _sendMessage,
           ),
         )
       ],
     ),
   );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isMe = msg.sender == _accId;
    final screenWidth = MediaQuery.of(context).size.width;

    if (msg.type == "title") {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            msg.content,
            style: TextWidgetStyles.text12LatoBold(),
          ),
        ),
      );
    }

    final time = _formatTime(msg.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isMe) ...[
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Container(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.75,
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
            decoration: BoxDecoration(
              color: isMe ? AppColors.lightblue : AppColors.lightyellow,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isMe ? 20 : 0),
                topRight: Radius.circular(isMe ? 0 : 20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              msg.content,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
          ),
          if (!isMe) ...[
            const SizedBox(width: 6),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChatBody() {
    return ListView.builder(
      controller: _scrollController,
      padding:
          const EdgeInsets.symmetric(vertical: 10),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return _buildMessageBubble(
            _messages[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: _appBarTitle,
        includeBackButton: true,
      ),
      body: _isLoading
        ? const Center(
            child: CircularProgressIndicator())
        : _buildChatBody(),
      bottomNavigationBar: _isLoading
        ? null
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEndButton(),
              if (!_isChatEnded)
                _buildMessageInput(),
            ],
          ),
    );
  }
}