import 'package:flutter/material.dart';
import 'package:medical_app/assets/Medicine.dart';
import 'package:medical_app/pages/edit_medicine_page.dart';

class Homepagetile extends StatelessWidget {
  final String type;
  final String name;
  List<String> times;
  Icon icon;
  final VoidCallback onDelete;
  Medicine medicine;
  final Function onUpdate;

  Homepagetile({
    super.key,
    required this.type,
    required this.name,
    required this.times,
    required this.icon,
    required this.onDelete,
    required this.medicine,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4), // Slight shadow below
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    icon,
                    const SizedBox(width: 10),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    size: 24,
                    color: Colors.black54,
                  ),
                  onPressed: () async {
                    final RenderBox button = context.findRenderObject() as RenderBox;
                    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

                    // Calculate the position manually using the button's position and size
                    final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
                    final double left = buttonPosition.dx;
                    final double top = buttonPosition.dy + button.size.height;

                    // Show the menu
                    final value = await showMenu<String>(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        left,
                        top,
                        left + button.size.width,
                        top + button.size.height,
                      ),
                      items: [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.blueAccent),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.redAccent),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                      color: Colors.white,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );

                    // Handle actions
                    if (value == 'delete') {
                      onDelete();
                    } else if (value == 'edit') {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditMedicinePage(medicine: medicine),
                        ),
                      );
                      if (result != null) {
                        onUpdate(result);
                      }
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Times Row
            ...List.generate(
              (times.length / 2).ceil(),
              (index) {
                // Get items for the current row
                final first = times[index * 2];
                final second = index * 2 + 1 < times.length ? times[index * 2 + 1] : null;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTimeBox(first, Colors.deepPurpleAccent),
                      if (second != null) _buildTimeBox(second, Colors.pinkAccent),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox(String time, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              time,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
