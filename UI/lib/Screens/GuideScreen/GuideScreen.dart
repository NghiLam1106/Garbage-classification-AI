import 'package:flutter/material.dart';
import 'package:garbageClassification/router/app_router.dart';
import 'GuideDetailScreen.dart';

class GuideScreen extends StatelessWidget {
  final List<Map<String, String>> guides = [
    {
      'title': '🌿 Chọn đất phù hợp',
      'description':
          'Đất tốt giúp cây phát triển khỏe mạnh và chống chịu bệnh.',
      'detail':
          'Bạn nên chọn đất tơi xốp, thoát nước tốt. Có thể trộn đất với xơ dừa, trấu hoặc phân hữu cơ để tăng độ thoáng khí.',
    },
    {
      'title': '💧 Tưới nước đúng cách',
      'description':
          'Không tưới quá nhiều hoặc quá ít sẽ ảnh hưởng đến rễ cây.',
      'detail':
          'Hãy tưới vào buổi sáng sớm hoặc chiều mát. Kiểm tra đất bằng cách chạm tay để cảm nhận độ ẩm, nếu khô hãy tưới.',
    },
    {
      'title': '☀️ Đảm bảo đủ ánh sáng',
      'description': 'Ánh sáng là nguồn sống cho cây qua quá trình quang hợp.',
      'detail':
          'Đặt cây gần cửa sổ hoặc vị trí có nắng nhẹ. Tránh ánh nắng gay gắt giữa trưa để không làm cháy lá.',
    },
    {
      'title': '🐛 Kiểm tra sâu bệnh',
      'description':
          'Phòng bệnh hơn chữa bệnh - kiểm tra định kỳ là quan trọng.',
      'detail':
          'Quan sát mặt dưới lá, thân cây để phát hiện sớm sâu hại. Có thể dùng nước rửa nhẹ hoặc thuốc sinh học để xử lý.',
    },
    {
      'title': '✂️ Cắt tỉa định kỳ',
      'description': 'Giúp cây thông thoáng, phát triển tập trung hơn.',
      'detail':
          'Cắt bỏ lá vàng, lá hư để không làm lây lan bệnh. Dụng cụ nên được khử trùng trước và sau khi cắt.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📖 Hướng dẫn chăm sóc cây'),
        backgroundColor: Colors.green.shade700,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRouter.home);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: guides.length,
        itemBuilder: (context, index) {
          final guide = guides[index];
          return ListTile(
            leading: Icon(Icons.eco, color: Colors.green),
            title: Text(
              guide['title']!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(guide['description']!),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => GuideDetailScreen(
                        title: guide['title']!,
                        detail: guide['detail']!,
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
