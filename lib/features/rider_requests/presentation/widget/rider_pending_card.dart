// lib/presentation/widgets/pending_request_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/color/color_theme.dart';
import '../../domain/entity/rider_pending_request_entity.dart';

class PendingRequestCard extends StatelessWidget {
  final RiderPendingRequest request;

  const PendingRequestCard({Key? key, required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date and time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEE, MMM d, yyyy').format(request.date),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: ThemeColors.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Pending',
                    style: TextStyle(
                      color: ThemeColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Source location
            Row(
              children: [
                const Icon(Icons.place_outlined, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'From: ${request.source.address}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Destination location
            Row(
              children: [
                const Icon(Icons.place, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'To: ${request.destination.address}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Ride details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem(
                  Icons.schedule,
                  'Pickup',
                  '${DateFormat('h:mm a').format(request.pickupTimeRange.min)} - ${DateFormat('h:mm a').format(request.pickupTimeRange.max)}',
                ),
                _buildDetailItem(
                  Icons.timer_outlined,
                  'Duration',
                  '${(request.duration / 60).round()} min',
                ),
                _buildDetailItem(
                  Icons.straighten,
                  'Distance',
                  '${(request.distance / 1000).toStringAsFixed(1)} km',
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Preferences
            Row(
              children: [
                const Icon(Icons.settings_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                const Text(
                  'Preferences:',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(width: 8),
                if (request.preferences.femaleOnly)
                  _buildPreferenceTag('Female Only', Colors.pink.shade100),
                if (request.preferences.maleOnly)
                  _buildPreferenceTag('Male Only', Colors.blue.shade100),
                if (request.preferences.canWalk)
                  _buildPreferenceTag('Can Walk', Colors.green.shade100),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildPreferenceTag(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color.withRed(color.red - 100).withGreen(color.green - 100).withBlue(color.blue - 100),
        ),
      ),
    );
  }
}

// lib/presentation/widgets/approved_request_card.dart
