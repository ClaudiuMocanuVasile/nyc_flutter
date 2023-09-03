
import 'package:flutter/material.dart';

Future<String?> showEditModal(BuildContext context, String initialTime) async {
  String? newTime;

  return showDialog<String?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Booking Time'),
        content: TextFormField(
          initialValue: initialTime,
          onChanged: (value) {
            newTime = value;
          },
          decoration: const InputDecoration(
            labelText: 'Booking Time',
            hintText: 'Enter new booking time',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cancel
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(newTime); // Save and return new time
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
