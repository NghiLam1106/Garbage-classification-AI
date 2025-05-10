import 'package:flutter/material.dart';
import 'package:garbageClassification/router/app_router.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<Map<String, String>> quizs = [
    {
      'name': 'game abc',
      'quantity': '10 câu',
    },
    {
      'name': 'game abc',
      'quantity': '10 câu',
    },
    {
      'name': 'game abc',
      'quantity': '10 câu',
    },
    {
      'name': 'game abc',
      'quantity': '10 câu',
    },
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredQuizs = quizs.where((quiz) {
      final name = quiz['name']!.toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Trò chơi'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Xử lý khi nhấn nút add
              print('Add button pressed');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: filteredQuizs.length,
                itemBuilder: (context, index) {
                  final quiz = filteredQuizs[index];
                  return GestureDetector(
                    onTap: (){
                       Navigator.pushReplacementNamed(
                              context,
                              AppRouter.quiz,
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            "images/game.png",
                            width: 65,
                            height: 65,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          quiz['name']!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Số câu: ${quiz['quantity']}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
