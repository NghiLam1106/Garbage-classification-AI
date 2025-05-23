import 'package:flutter/material.dart';
import 'package:garbageClassification/router/app_router.dart';
import 'GuideDetailScreen.dart';

class GuideScreen extends StatelessWidget {
  final List<Map<String, String>> guides = [
    {
      'title': '🗑️ Phân loại rác tại nguồn',
      'description': 'Bước đầu tiên và quan trọng nhất trong xử lý rác thải.',
      'detail':
          'Phân chia rác thành các loại: rác hữu cơ (thức ăn thừa, lá cây), rác tái chế (giấy, nhựa, kim loại) và rác vô cơ (nilông, sành sứ). Sử dụng thùng rác màu sắc khác nhau để dễ phân biệt.',
    },
    {
      'title': '♻️ Tái chế rác thải',
      'description': 'Giảm thiểu lượng rác thải ra môi trường.',
      'detail':
          'Các vật dụng như chai nhựa, giấy, lon kim loại có thể làm sạch và đem đến điểm thu gom tái chế. Sáng tạo đồ tái chế thành vật dụng hữu ích trong nhà.',
    },
    {
      'title': '🌱 Ủ rác hữu cơ làm phân',
      'description': 'Biến rác thải thành tài nguyên cho cây trồng.',
      'detail':
          'Thu gom rác hữu cơ vào thùng ủ, trộn với men vi sinh và để khoảng 2-3 tháng. Sản phẩm thu được là phân compost giàu dinh dưỡng cho cây trồng.',
    },
    {
      'title': '⚡ Xử lý rác nguy hại',
      'description': 'Cách ly các loại rác độc hại khỏi môi trường sống.',
      'detail':
          'Pin, bóng đèn hỏng, thiết bị điện tử cần được thu gom riêng và đưa đến điểm thu hồi chuyên dụng. Không vứt chung với rác thông thường.',
    },
    {
      'title': '🚯 Giảm thiểu rác thải nhựa',
      'description': 'Phòng ngừa ô nhiễm từ nguồn.',
      'detail':
          'Sử dụng túi vải, bình nước cá nhân, hộp đựng thức ăn bằng thủy tinh. Ưu tiên sản phẩm có bao bì tự phân hủy hoặc không dùng bao bì.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📚 Hướng dẫn phân loại rác'),
        backgroundColor: Colors.green.shade700,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.home);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: guides.length,
        itemBuilder: (context, index) {
          final guide = guides[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Icon(_getIconForCategory(index), color: Colors.green),
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
                    builder: (_) => GuideDetailScreen(
                      title: guide['title']!,
                      detail: guide['detail']!,
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

  IconData _getIconForCategory(int index) {
    switch (index) {
      case 0:
        return Icons.delete;
      case 1:
        return Icons.recycling;
      case 2:
        return Icons.eco;
      case 3:
        return Icons.warning;
      case 4:
        return Icons.info;
      default:
        return Icons.info;
    }
  }
}