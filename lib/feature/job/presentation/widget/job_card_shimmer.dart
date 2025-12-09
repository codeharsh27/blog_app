import 'package:flutter/material.dart';

class JobCardShimmer extends StatefulWidget {
  const JobCardShimmer({super.key});

  @override
  State<JobCardShimmer> createState() => _JobCardShimmerState();
}

class _JobCardShimmerState extends State<JobCardShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 14,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 6),
                      Container(width: 60, height: 10, color: Colors.grey[300]),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 20,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(width: 80, height: 24, color: Colors.grey[300]),
                const SizedBox(width: 8),
                Container(width: 80, height: 24, color: Colors.grey[300]),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
