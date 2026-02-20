import 'dart:convert';
import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/models/chat_message.dart';
import 'package:ce_connect_app/service/chat_api.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPageS extends StatefulWidget {
  final String otherMember;
  final String roomId;

  const ChatPageS({
    super.key,
    required this.otherMember,
    required this.roomId,
  });

  @override
  State<ChatPageS> createState() => _ChatPageSState();
}

class _ChatPageSState extends State<ChatPageS> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late WebSocketChannel _channel;

  String? _accId;
  String? _roomId;
  String _appBarTitle = "Chat";
  bool _isLoading = true;
  bool _showStartButton = false;
  bool _isChatActive = false;

  List<ChatMessage> _messages = [];
  final Set<String> _pendingMessages = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final accId = '65010782'; // TODO: เปลี่ยนเป็น session จริง

    if (_accId != accId && accId.isNotEmpty) {
      _accId = accId;
      _openChat();
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _titleController.dispose();
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
  
      final history = await service.fetchChatHistory(_roomId!);
  
      setState(() {
        _appBarTitle = response.fullNameEn;
        _showStartButton = response.endTitleStatus;
        _isChatActive = !response.endTitleStatus;
        _messages = history;
        _isLoading = false;
      });
  
      _scrollToBottom();
      _connectWebSocket();
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _connectWebSocket() {
    if (_accId == null) return;

    _channel = WebSocketChannel.connect(
      Uri.parse('ws://127.0.0.1:8080/chat/ws?accId=$_accId'),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _channel.sink.add(jsonEncode({
        "type": "join",
        "room_id": widget.roomId,
        "content": "",
      }));
    });

    _channel.stream.listen((data) {
      final decoded = jsonDecode(data);
      final message = ChatMessage.fromJson(decoded);

      if (message.roomId != widget.roomId) return;

      if (message.type == "message") {
        final key = "${message.roomId}:${message.content}";
        if (_pendingMessages.contains(key)) {
          _pendingMessages.remove(key);
          return;
        }
        setState(() {
          _messages.add(ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            roomId: message.roomId,
            sender: widget.otherMember,
            content: message.content,
            createdAt: DateTime.now().toIso8601String(),
            type: "message",
          ));
        });
        _scrollToBottom();
        return;
      }

      if (message.type == "title") {
        // ✅ dedup title เหมือนกัน
        final key = "${message.roomId}:title:${message.content}";
        if (_pendingMessages.contains(key)) {
          _pendingMessages.remove(key);
          return;
        }
        // ถ้าไม่อยู่ใน pending = title มาจากอีกฝั่ง
        setState(() {
          _messages.add(ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            roomId: message.roomId,
            sender: widget.otherMember,
            content: message.content,
            createdAt: DateTime.now().toIso8601String(),
            type: "title",
          ));
          _showStartButton = false;
          _isChatActive = true;
        });
        _scrollToBottom();
        return;
      }

      if (message.type == "end") {
        setState(() {
          _isChatActive = false;
          _showStartButton = true;
        });
        _scrollToBottom();
      }
    });
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

  void _showStartDialog() {
    double screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Conversation Title",
                style: TextWidgetStyles.text16LatoBold()
                    .copyWith(color: AppColors.textDarkblue),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // ใน _showStartDialog ตอนกดปุ่ม Send
                  onPressed: () {
                    final title = _titleController.text.trim();
                    if (title.isEmpty || _roomId == null) return;

                    _channel.sink.add(jsonEncode({
                      "type": "title",
                      "room_id": _roomId,
                      "content": title,
                    }));

                    // ✅ เพิ่ม pending key สำหรับ title ด้วย
                    final key = "${_roomId!}:title:$title";
                    _pendingMessages.add(key);

                    setState(() {
                      _messages.add(ChatMessage(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        roomId: _roomId!,
                        sender: _accId!,
                        content: title,
                        createdAt: DateTime.now().toIso8601String(),
                        type: "title",
                      ));
                      _showStartButton = false;
                      _isChatActive = true;
                    });

                    _titleController.clear();
                    Navigator.pop(context);
                    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                  ),
                  child: Text(
                    "Send",
                    style: TextWidgetStyles.text14LatoRegular()
                        .copyWith(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _endChat() {
    if (_roomId == null) return;

    final message = {
      "type": "end",
      "room_id": _roomId,
      "content": "Conversation ended",
    };

    _channel.sink.add(jsonEncode(message));

    // ถ้า server ไม่ echo "end" กลับมา ให้ update state ตรงนี้เลย
    // ถ้า server echo กลับ ให้ไปจัดการใน stream.listen แทน
    setState(() {
      _isChatActive = false;
      _showStartButton = true;
    });
  }

  Widget _buildBottomActionButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
            ),
            onPressed: () {
              if (_showStartButton) {
                _showStartDialog();
              } else {
                _endChat();
              }
            },
            child: Text(
              _showStartButton ? "Start Chat" : "End Chat",
              style: TextWidgetStyles.text14LatoRegular()
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || _roomId == null || !_isChatActive) return;

    _channel.sink.add(jsonEncode({
      "type": "message",
      "room_id": widget.roomId,
      "content": text,
    }));

    final key = "${widget.roomId}:$text";
    _pendingMessages.add(key);

    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
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

  Widget _buildMessageBubble(ChatMessage msg) {
    final isMe = msg.sender == _accId;

    if (msg.type == "title") {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            msg.content,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Align(
      alignment:
          isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          msg.content,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildChatBody() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _appBarTitle,
        includeBackButton: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildChatBody(),
      bottomNavigationBar: _isLoading
          ? null
          :_showStartButton
              ? _buildBottomActionButton()
              : SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildBottomActionButton(),
                      _buildMessageInput(),
                    ],
                  ),
                ),
    );
  }
}