import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:security_guard_app/controllers/visitor_controller.dart';

class VisitorRegistrationScreen extends StatelessWidget {
  final VisitorController visitorController = Get.find<VisitorController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitor Registration'),
        backgroundColor: Colors.yellow[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: visitorController.visitorNameController,
              decoration: const InputDecoration(labelText: 'Visitor Name'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: visitorController.visitorPurposeController,
              decoration: const InputDecoration(labelText: 'Purpose of Visit'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: visitorController.visitorContactController,
              decoration: const InputDecoration(labelText: 'Contact Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: visitorController.visitorFlatNoController,
              decoration: const InputDecoration(labelText: 'Flat Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  visitorController.addVisitorToFirestore(
                      visitorController.visitorNameController.text,
                      visitorController.visitorPurposeController.text,
                      visitorController.visitorContactController.text,
                      visitorController.visitorFlatNoController.text);
                },
                child: const Text('Register Visitor'))
          ],
        ),
      ),
    );
  }
}
