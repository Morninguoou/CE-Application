import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/service/cegpt_api.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:flutter/material.dart';

class CeGptPage extends StatefulWidget {
  const CeGptPage({super.key});

  @override
  State<CeGptPage> createState() => _CeGptPageState();
}

class _CeGptPageState extends State<CeGptPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _accId;
  final CEgptService _ceGptService = CEgptService();
  String? _sessionId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final accId = context.read<SessionProvider>().accId;
    final accId = '65010782'; // For test API
    
    if (_accId != accId && accId.isNotEmpty) {
      _accId = accId;
      _initSession();
    }
  }

  Future<void> _initSession() async {
    if (_accId == null) return;

    final sessionId = await _ceGptService.createSession(_accId!);

    if (sessionId != null) {
      setState(() {
        _sessionId = sessionId;
      });
    }
  }

  final List<Map<String, dynamic>> _messages = [
    {
      "isBot": true,
      "text": "สงสัยอะไรถามเราได้เลย!",
    }
  ];

  void _sendMessage([String? text]) async {
    final message = text ?? _messageController.text.trim();
    if (message.isEmpty || _sessionId == null) return;

    _messageController.clear();

    setState(() {
      _messages.add({"isBot": false, "text": message});
      _messages.add({"isBot": true, "text": ""});
    });

    final botIndex = _messages.length - 1;

    _scrollToBottom();

    final stream = _ceGptService.generateStream(
      query: message,
      userId: _accId!,
      sessionId: _sessionId!,
    );

    await for (final chunk in stream) {

      setState(() {
        _messages[botIndex]["text"] += chunk;
      });

      _scrollToBottom();
    }
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

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isBot = message["isBot"];
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment:
          isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isBot
              ? AppColors.lightyellow
              : Colors.blue,
          borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isBot ? 0 : 20),
                topRight: Radius.circular(isBot ? 20 : 0),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
        ),
        child: Text(
          message["text"],
          style: TextStyle(
            color: isBot ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionButton(String text) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () => _sendMessage(text),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue),
          ),
          child: Center(
            child: Text(
              text,
              style: TextWidgetStyles.text14LatoRegular().copyWith(color: AppColors.textDarkblue),
            ),
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
        bottom:
            MediaQuery.of(context).viewPadding.bottom + 8,
      ),
      color: AppColors.lightyellow,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textInputAction:
                  TextInputAction.send,
              onSubmitted: (_) =>
                  _sendMessage(),
              decoration: const InputDecoration(
                hintText: "Message...",
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(
                          Radius.circular(
                              30)),
                ),
                contentPadding:
                    EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: const Icon(Icons.send,
                  color: Colors.white),
              onPressed: () =>
                  _sendMessage(),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
          title: "CE-GPT",
          includeBackButton: true),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller:
                  _scrollController,
              padding:
                  const EdgeInsets.all(
                      16),
              itemCount:
                  _messages.length,
              itemBuilder:
                  (context, index) {
                return _buildMessageBubble(
                    _messages[index]);
              },
            ),
          ),

          // แสดง suggestion ตอนยังไม่มี user message
          if (_messages.length == 1)
            Padding(
              padding:
                  const EdgeInsets
                      .symmetric(
                          horizontal:
                              16),
              child: Column(
                children: [
                  _buildSuggestionButton(
                      "อยากเป็น DevOps ต้องลงเรียนอะไรบ้าง"),
                  _buildSuggestionButton(
                      "อาจารย์ผู้สอนวิชา Database คือใคร"),
                  _buildSuggestionButton(
                      "วิชา PREREQUISITE ของ UXUI คือวิชาอะไร"),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar:
          _buildMessageInput(),
    );
  }
}