import 'package:flutter/material.dart';
import 'package:mobile/common/AlertError.dart';
import 'package:mobile/common/TaskEnum.dart';

class MyCardTask extends StatelessWidget {
  final String title;
  final String description;
  final TaskEnum status;
  final bool isSelected;
  final String id;
  final void Function(String id) action;

  const MyCardTask({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.isSelected,
    required this.action,
  });

  Color _getColorFromStatus(TaskEnum status) {
    return status == TaskEnum.DONE ? Colors.green : Colors.black54;
  }

  IconData _getIconFromStatus(TaskEnum status) {
    return status == TaskEnum.DONE ? Icons.check_circle : Icons.cancel;
  }

  void _toggleStatus(BuildContext context) {
    try {
      action(id);
    } catch (e) {
      AlertHelper.show('Error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorStatus = _getColorFromStatus(status);
    final iconButton = _getIconFromStatus(status);

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isSelected ? Colors.blue.shade600 : Colors.transparent,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colorStatus,
                  ),
                ),
                CircleAvatar(radius: 10, backgroundColor: colorStatus),
              ],
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Estado: ${status.label}"),
                IconButton(
                  icon: Icon(iconButton),
                  color: colorStatus,
                  iconSize: 30,
                  onPressed: () => _toggleStatus(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
