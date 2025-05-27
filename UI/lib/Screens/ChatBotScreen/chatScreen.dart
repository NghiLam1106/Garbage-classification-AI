import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garbageClassification/Screens/ChatBotScreen/ChatService.dart';

class ChatScreen extends StatefulWidget {
  final String? id;

  const ChatScreen({super.key, this.id});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final GeminiService _gemini = GeminiService();

  void _sendMessage() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": input});
      _controller.clear();
    });

    final reply = await _gemini.sendMessage(input);

    setState(() {
      _messages.add({"role": "ai", "content": reply});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark; // Thêm dòng này để xác định chế độ tối/sáng

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat'),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.blueAccent,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      body: Column(
        children: [
          const Divider(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';

                final user = "trung";
                final userName = 'Bạn';
                final userAvatar = "";

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        if (!isUser)
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: (userAvatar != null && userAvatar.isNotEmpty)
                                ? NetworkImage(userAvatar)
                                : null,
                            backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey,
                            child: (userAvatar == null || userAvatar.isEmpty)
                                ? const Icon(Icons.person, color: Colors.white, size: 18)
                                : null,
                          )
                        else
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: userAvatar != null ? NetworkImage(userAvatar) : null,
                            backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey,
                            child: userAvatar == null
                                ? const Icon(Icons.person, color: Colors.white, size: 18)
                                : null,
                          ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? (isDarkMode ? Colors.blueGrey[700] : Colors.blue[100])
                                  : (isDarkMode ? Colors.grey[800] : Colors.grey[200]),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isUser ? 16 : 0),
                                bottomRight: Radius.circular(isUser ? 0 : 16),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isUser ? userName : 'FinBot 🤖',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isUser
                                        ? (isDarkMode ? Colors.white : Colors.blueGrey)
                                        : (isDarkMode ? Colors.white : Colors.deepPurple),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  message['content'] ?? '',
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.white70 : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blueAccent,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
