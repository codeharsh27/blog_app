import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'app_pallet.dart';

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppPallete.borderColor  // Set the color of the dashed border
      ..strokeWidth = 2                 // Set the stroke width for the border
      ..style = PaintingStyle.stroke;

    double dashWidth = 10.0;
    double dashSpace = 4.0;
    double radius = 12.0; // Radius for rounded corners

    // Create a rounded rectangle path for the border
    Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)));

    // Get the perimeter of the path (for drawing the dashed border)
    PathMetrics pathMetrics = path.computeMetrics();

    // Draw dashed lines along the path
    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0;
      while (distance < pathMetric.length) {
        // Draw a line for each dash
        final start = pathMetric.getTangentForOffset(distance)!.position;
        final end = pathMetric.getTangentForOffset(distance + dashWidth)!.position;
        canvas.drawLine(start, end, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // No need to repaint unless size or color changes
  }
}
