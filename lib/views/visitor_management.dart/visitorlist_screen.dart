import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:security_guard_app/controllers/visitor_controller.dart';

class VisitorListScreen extends StatelessWidget {
  final VisitorController visitorController = Get.find<VisitorController>();

  void _clearVisitorList() {
    visitorController.clearVisitors(); // Method to clear the list
  }

  @override
  Widget build(BuildContext context) {
    visitorController.onInit();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Visitor List'),
        backgroundColor: Colors.yellow[300],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () {
                final visitors = visitorController.visitors;
                return ListView.builder(
                  itemCount: visitors.length,
                  itemBuilder: (context, index) {
                    final visitor = visitors[index];
                    return Dismissible(
                      key: Key(visitor.name),
                      onDismissed: (direction) async {
                        await visitorController.deleteVisitor(visitor.id);
                      },
                      background: Container(color: Colors.red),
                      child: ListTile(
                        title: Row(
                          children: [
                            Text(visitor.name),
                            const Text('🧍🏻‍♂️'),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Purpose: ${visitor.purpose}'),
                            Text('Contact: ${visitor.contact}'),
                          ],
                        ),
                        trailing: Text(
                            visitor.checkedIn ? 'Checked In ' : 'Checked Out'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _clearVisitorList,
              child: const Text('Clear Visitor List'),
            ),
          ),
        ],
      ),
    );
  }
}
