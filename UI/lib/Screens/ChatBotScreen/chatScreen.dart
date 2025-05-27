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
  static const List<String> _financeKeywords = [
    // Bảo vệ môi trường
    'môi trường', 'bảo vệ môi trường', 'biến đổi khí hậu', 'ô nhiễm', 'tái chế',
    'tiết kiệm năng lượng', 'năng lượng tái tạo', 'trồng cây',
    'hạn chế rác thải',
    'bảo tồn thiên nhiên', 'phát triển bền vững',

    // Phân loại rác thải
    'rác thải', 'phân loại rác', 'rác hữu cơ', 'rác vô cơ', 'rác tái chế',
    'rác nguy hại', 'rác sinh hoạt', 'xử lý rác thải', 'thu gom rác',
    'tái sử dụng',
  ];
static const List<String> _suggestedQuestions = [
  // Câu hỏi về bảo vệ môi trường
  'Tại sao chúng ta cần bảo vệ môi trường?',
  'Những hành động nào giúp bảo vệ môi trường?',
  'Biến đổi khí hậu là gì và ảnh hưởng thế nào đến cuộc sống?',
  'Làm thế nào để tiết kiệm năng lượng trong sinh hoạt hàng ngày?',
  'Năng lượng tái tạo có vai trò gì trong bảo vệ môi trường?',

  // Câu hỏi về phân loại rác thải
  'Phân loại rác là gì và tại sao nó quan trọng?',
  'Rác hữu cơ và rác vô cơ khác nhau như thế nào?',
  'Những loại rác nào có thể tái chế được?',
  'Làm sao để xử lý rác nguy hại một cách an toàn?',
  'Có thể tái sử dụng rác thải như thế nào trong cuộc sống hàng ngày?',
];

  void _sendMessage() async {
  final input = _controller.text.trim();
  if (input.isEmpty) return;

  // Kiểm tra nếu không chứa từ khóa liên quan
  final lowerInput = input.toLowerCase();
  final isRelevant = _financeKeywords.any((keyword) => lowerInput.contains(keyword));

  if (!isRelevant) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Câu hỏi không liên quan đến môi trường hoặc phân loại rác thải.'),
        backgroundColor: Colors.redAccent,
      ),
    );
    return;
  }

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
    final isDarkMode = MediaQuery.of(context).platformBrightness ==
        Brightness.dark; // Thêm dòng này để xác định chế độ tối/sáng

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ai Chat Bảo Vệ Môi Trường'),
        backgroundColor:
            isDarkMode ? const Color(0xFF1E1E1E) : const Color.fromARGB(255, 7, 189, 31),
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
            if (_messages.isEmpty)
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bạn có thể hỏi:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _suggestedQuestions.map((question) {
                return ActionChip(
                  label: Text(question),
                  onPressed: () {
                    _controller.text = question;
                    _sendMessage();
                  },
                  backgroundColor: isDarkMode
                      ? Colors.blueGrey[700]
                      : Colors.blue[50],
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
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
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!isUser)
                          CircleAvatar(
                            radius: 18,
                            backgroundImage:
                                (userAvatar != null && userAvatar.isNotEmpty)
                                    ? NetworkImage(userAvatar)
                                    : null,
                            backgroundColor:
                                isDarkMode ? Colors.grey[700] : Colors.grey,
                            child: (userAvatar == null || userAvatar.isEmpty)
                           ? ClipOval(
        child: Image.asset(
          'assets/image.png',
          width: 36,
          height: 36,
          fit: BoxFit.cover,
        ),
      )
    : null,
                          )
                        else
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: userAvatar != null
                                ? NetworkImage(userAvatar)
                                : null,
                            backgroundColor:
                                isDarkMode ? Colors.grey[700] : Colors.grey,
                            child: userAvatar == null
                                ? const Icon(Icons.person,
                                    color: Colors.white, size: 18)
                                : null,
                          ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? (isDarkMode
                                      ? Colors.blueGrey[700]
                                      : Colors.blue[100])
                                  : (isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.grey[200]),
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
                                  isUser ? userName : 'GARBAGE CLASSIFICATION AI',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isUser
                                        ? (isDarkMode
                                            ? Colors.white
                                            : Colors.blueGrey)
                                        : (isDarkMode
                                            ? Colors.white
                                            : Colors.deepPurple),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  message['content'] ?? '',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black87,
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
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      hintStyle: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.grey),
                      filled: true,
                      fillColor:
                          isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: const Color.fromARGB(255, 0, 255, 13),
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
