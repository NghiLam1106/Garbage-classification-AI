import 'package:flutter/material.dart';

class ListviewUser extends StatelessWidget {
  const ListviewUser({
    super.key,
    required this.name,
    required this.imageURL,
    required this.onDelete,
    required this.id,
  });

  final String id, name, imageURL;
  final VoidCallback onDelete;

  bool isValidImageUrl(String url) {
    return url.isNotEmpty && Uri.tryParse(url)?.hasAbsolutePath == true;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: isValidImageUrl(imageURL)
                ? NetworkImage(imageURL)
                : NetworkImage('https://www.flaticon.com/free-icons/user'),
            backgroundColor: Colors.grey[200],
          ),
          title: Text('Tên người dùng: $name',
              style: Theme.of(context).textTheme.titleMedium),
          trailing: IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete),
          ),
        ),
      ),
    );
  }
}
