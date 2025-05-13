import 'package:flutter/material.dart';

Future<void> showDeleteConfirmationDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: const Text("Bạn có chắc chắn muốn xóa không?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng hộp thoại
            },
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng hộp thoại trước
              onConfirm(); // Gọi hàm xử lý xóa
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

Future<void> showAddAndUpdateDialog(BuildContext context,
    String? id, {
    String? name,
    String? category,
    String? price,
    String? imageURL,
  }) async {

}