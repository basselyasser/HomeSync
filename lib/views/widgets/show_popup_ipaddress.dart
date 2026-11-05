import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/ip_address_repository.dart';


void showIpInputDialog(BuildContext context, WidgetRef ref) {
  final TextEditingController ipController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Enter IP Address'),
        content: TextField(
          controller: ipController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            hintText: '192.168.1.9',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async{
              String enteredIp = ipController.text.trim();
              print('New IP: $enteredIp'); // you can save it to your service
              await IpRepository().setIp(ipController.text);
              Navigator.of(context).pop(); // close dialog
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

class IpService {
}