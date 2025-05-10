import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final _messages = [];
  final ScrollController _scrollController =
      ScrollController(); // Controller để cuộn

  final List<String> prompts = [
    "🌿 Cây bị vàng lá, nguyên nhân là gì?",
    "💧 Cây bị héo, làm sao khắc phục?",
    "🚰 Cây thiếu nước, dấu hiệu nhận biết?",
    "❄️ Cách chăm sóc cây trong mùa đông?",
  ];

  // Hàm gửi tin nhắn
  Future<void> _sendMessage(String message) async {
    /*if (message.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(role: 'user', content: message));
    });

    _controller.clear();

    try {
      ChatResponseDTO response =
          await ChatService.sendMessageToChatbot(message);

      setState(() {
        _messages
            .add(ChatMessage(role: 'assistant', content: response.response));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
            role: 'assistant',
            content: "Xin lỗi, hiện chatbot đang gặp sự cố 🛠️"));
      });
    }

    // Cuộn xuống dưới sau khi có tin nhắn mới
    _scrollToBottom();*/
  }

  // Hàm cuộn xuống dưới khi có tin nhắn mới
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildMessage(messag) {
    final bool isUser = true;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUser)
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.green.shade200,
                child: Icon(Icons.android, color: Colors.white),
              ),
            if (!isUser) SizedBox(width: 8),
            Flexible(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUser ? Colors.green.shade200 : Colors.grey.shade300,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: isUser ? Radius.circular(16) : Radius.zero,
                    bottomRight: isUser ? Radius.zero : Radius.circular(16),
                  ),
                ),
                child: Text(
                  //message.content,
                  'asds',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            if (isUser) SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat với Chuyên Gia Cây Trồng"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Danh sách tin nhắn
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Đặt controller cho ListView
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: 2,
              itemBuilder: (context, index) => _buildMessage(_messages[index]),
            ),
          ),

          // Gợi ý prompt
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: prompts.map((prompt) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    onPressed: () => _sendMessage(prompt),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(prompt, style: TextStyle(color: Colors.white)),
                  ),
                );
              }).toList(),
            ),
          ),

          // Ô nhập + gửi
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nhập câu hỏi của bạn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
