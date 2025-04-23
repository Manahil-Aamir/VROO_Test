import 'package:flutter/material.dart';

class RideInfoBottomSheet extends StatelessWidget {
  const RideInfoBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.blue[500],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Ride',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Started at: 8:00 am',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: List.generate(
                        3,
                        (index) =>
                            Icon(Icons.star, color: Colors.amber, size: 18),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Frame 39424',
                      style: TextStyle(color: Colors.amber[300], fontSize: 14),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Rs. 180',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Timeline Section
          Container(
            color: Colors.orange[50],
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 8),
              children: [
                // Source
                _buildTimelineItem(
                  icon: Icons.location_on,
                  title: 'Source Destination',
                  subtitle: 'Sample Address',
                  time: '8:00 am',
                  isFirst: true,
                ),

                // Pickup Asad
                _buildTimelineItem(
                  icon: Icons.person,
                  title: 'Pick up Asad',
                  subtitle: 'Address 1',
                  time: '8:10 am',
                  price: 'Rs. 60',
                ),

                // Pickup Amir
                _buildTimelineItem(
                  icon: Icons.person,
                  title: 'Pick up Amir',
                  subtitle: 'Address 2',
                  time: '8:15 am',
                  price: 'Rs. 60',
                ),

                // Pickup Ali
                _buildTimelineItem(
                  icon: Icons.person,
                  title: 'Pick up Ali',
                  subtitle: 'Address 3',
                  time: '8:20 am',
                  price: 'Rs. 60',
                ),

                // Final Destination
                _buildTimelineItem(
                  icon: Icons.flag,
                  title: 'Final Destination',
                  subtitle: 'IBA Main Campus',
                  time: '8:30 am',
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    String? price,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline and Icon
        SizedBox(
          width: 60,
          child: Column(
            children: [
              if (!isFirst)
                Container(
                  width: 2,
                  height: 15,
                  color: Colors.grey[400],
                ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: Colors.grey[400],
                ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Time and Price
        Container(
          width: 80,
          padding: EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: Colors.orange[800],
                  fontSize: 14,
                ),
              ),
              if (price != null)
                Text(
                  price,
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// How to show this bottom sheet:
void showRideInfoBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: RideInfoBottomSheet(),
        );
      },
    ),
  );
}
