import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class EntityListScreen extends StatefulWidget {
  @override
  _EntityListScreenState createState() => _EntityListScreenState();
  static const id = "apiTestScreen";
}

class _EntityListScreenState extends State<EntityListScreen> {
  late Future<List<Map<String, dynamic>>> entities;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Assistant Entities')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: entities,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final entity = items[index];
              return ListTile(
                title: Text(entity['entity_id']),
                subtitle: Text(entity['state']),
              );
            },
          );
        },
      ),
    );
  }
}
