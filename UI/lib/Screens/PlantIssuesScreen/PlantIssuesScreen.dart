import 'package:flutter/material.dart';
import 'package:garbageClassification/Screens/PlantIssuesScreen/issue_detail_screen.dart';
import 'package:garbageClassification/router/app_router.dart';

class PlantIssuesScreen extends StatelessWidget {
  final List<Map<String, String>> issues = [
    {
      'title': 'Lá bị vàng',
      'description': 'Thiếu dinh dưỡng hoặc úng nước.',
      'longDescription':
          'Lá cây bị vàng thường là dấu hiệu cây thiếu chất sắt, magie hoặc nitơ. Ngoài ra, hiện tượng này cũng có thể do cây bị úng nước do thoát nước kém hoặc tưới quá nhiều. Cần kiểm tra đất trồng và điều chỉnh chế độ tưới tiêu, bón phân hợp lý.',
      'image': 'images/la01.jpg',
    },
    {
      'title': 'Đốm nâu trên lá',
      'description': 'Có thể là bệnh đốm lá (Leaf Spot).',
      'longDescription':
          'Bệnh đốm lá thường xuất hiện với các đốm nhỏ màu nâu hoặc đen. Đây là bệnh do nấm hoặc vi khuẩn gây ra, dễ lây lan trong điều kiện ẩm ướt. Cần loại bỏ lá bệnh, hạn chế tưới vào lá và sử dụng thuốc đặc trị nếu cần.',
      'image': 'images/la02.jpeg',
    },
    {
      'title': 'Héo rũ cây',
      'description': 'Có thể do nấm hoặc thiếu nước.',
      'longDescription':
          'Cây héo rũ có thể là do bệnh héo rũ do nấm Fusarium hoặc do cây bị hạn nước. Cần kiểm tra rễ cây, độ ẩm đất và loại bỏ cây bệnh nếu thấy biểu hiện nghiêm trọng để tránh lây lan.',
      'image': 'images/la03.jpg',
    },
    {
      'title': 'Lá xoăn lại',
      'description': 'Côn trùng hoặc virus gây hại.',
      'longDescription':
          'Lá xoăn lại có thể là dấu hiệu của sự xâm nhập của rệp hoặc virus gây bệnh. Cần kiểm tra mặt dưới lá, loại bỏ côn trùng bằng tay hoặc thuốc bảo vệ thực vật sinh học và cách ly cây bệnh.',
      'image': 'images/la04.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRouter.home);
          },
        ),
        title: Text('🌿 Vấn đề chung của cây trồng'),
        backgroundColor: Colors.green.shade700,
      ),
      body: ListView.builder(
        itemCount: issues.length,
        itemBuilder: (context, index) {
          final issue = issues[index];
          return Card(
            margin: EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Image.asset(
                issue['image']!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(
                issue['title']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(issue['description']!),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => IssueDetailScreen(
                          title: issue['title']!,
                          image: issue['image']!,
                          longDescription: issue['longDescription']!,
                        ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
