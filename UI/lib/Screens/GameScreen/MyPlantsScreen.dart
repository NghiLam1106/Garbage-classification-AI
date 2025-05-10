import 'package:flutter/material.dart';

class MyPlantsScreen extends StatefulWidget {
  @override
  _MyPlantsScreenState createState() => _MyPlantsScreenState();
}

class _MyPlantsScreenState extends State<MyPlantsScreen> {
  final List<Map<String, String>> plants = [
    {
      'name': 'Cây Hoài cute',
      'image': 'images/lacute.png',
      'status': '10 điểm',
    },
    {
      'name': 'Cây Hoài dth',
      'image': 'images/lacute.png',
      'status': '10 điểm',
    },
    {
      'name': 'Cây Hoài ngầu',
      'image': 'images/lacute.png',
      'status': '10 điểm',
    },
    {
      'name': 'Cây Hoài học giỏi',
      'image': 'images/lacute.png',
      'status': '10 điểm',
    },
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredPlants = plants.where((plant) {
      final name = plant['name']!.toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('🌱 Cây của tôi'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm cây...',
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
                itemCount: filteredPlants.length,
                itemBuilder: (context, index) {
                  final plant = filteredPlants[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          plant['image']!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        plant['name']!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Tình trạng: ${plant['status']}'),
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
