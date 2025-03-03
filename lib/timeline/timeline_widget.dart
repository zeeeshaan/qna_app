import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qna_app/timeline/timeline_event.dart';

const double _indicatorSize = 52.0;

class TimelineWidget extends StatefulWidget {
  final List<TimelineEvent> events;
  final String? projectId;

  const TimelineWidget({
    super.key,
    required this.events,
    required this.projectId,
  });

  @override
  State<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _lineAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _lineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onMilestoneTap(int index) {
    final event = widget.events[index];

    FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectId)
        .collection('completedMilestones')
        .doc(event.title.toLowerCase().replaceAll(' ', '-')) // Use lowercase slug
        .get()
        .then((snapshot) {
      if (!snapshot.exists) {
        // ✅ Mark as completed if not already in Firestore
        FirebaseFirestore.instance
            .collection('projects')
            .doc(widget.projectId)
            .collection('completedMilestones')
            .doc(event.title.toLowerCase().replaceAll(' ', '-'))
            .set({
          "name": event.title,
          "completedAt": FieldValue.serverTimestamp(), // Track completion time
        }).then((_) {
          _updateProjectProgress(); // ✅ Update project progress
        });
      }
    });
  }



  void _updateProjectProgress() async {
    final categoriesSnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .get(); // Get total milestones

    final completedSnapshot = await FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectId)
        .collection('completedMilestones')
        .get(); // Get completed milestones

    final totalMilestones = categoriesSnapshot.docs.length;
    final completedMilestones = completedSnapshot.docs.length;

    final newProgress = totalMilestones > 0 ? completedMilestones / totalMilestones : 0.0;

    await FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectId)
        .update({"progress": newProgress});
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _lineAnimation,
      builder: (context, child) {
        return CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: widget.events.length,
                    (context, index) {
                  final event = widget.events[index];
                  final progressFraction = (index + 1) / widget.events.length;
                  final lineProgress = _lineAnimation.value * progressFraction;

                  return _buildTimelineItem(event, index, lineProgress, screenWidth);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimelineItem(TimelineEvent event, int index, double lineProgress, double screenWidth) {
    final isFirst = index == 0;
    final isLast = index == widget.events.length - 1;

    return Stack(
      children: [
        Positioned(
          left: _indicatorSize / 1.8,
          top: 0,
          bottom: 0,
          child: CustomPaint(
            size: const Size(3, double.infinity),
            painter: _TimelineLinePainter(
              itemIndex: index,
              totalItems: widget.events.length,
              lineProgress: lineProgress,
              isFirst: isFirst,
              isLast: isLast,
              lineColor: event.color,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: _indicatorSize + 16,
            right: screenWidth * 0.05, // ✅ Responsive Padding
            top: isFirst ? 0 : 20,
            bottom: isLast ? 0 : 20,
          ),
          child: Hero(
            tag: 'timeline_card_${event.title}',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _onMilestoneTap(index),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  decoration: BoxDecoration(
                    color: event.isExpanded
                        ? event.color.withOpacity(0.1)
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: event.isExpanded
                          ? event.color.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: event.isExpanded
                            ? event.color.withOpacity(0.2)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: event.isExpanded ? 12 : 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _buildCardContent(event, context),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardContent(TimelineEvent event, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(event.icon, color: event.color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: event.isExpanded ? event.color : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(event.isExpanded ? Icons.expand_less : Icons.expand_more, color: event.color.withOpacity(0.5)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            event.subtitle,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineLinePainter extends CustomPainter {
  final int itemIndex;
  final int totalItems;
  final double lineProgress;
  final bool isFirst;
  final bool isLast;
  final Color lineColor;

  _TimelineLinePainter({
    required this.itemIndex,
    required this.totalItems,
    required this.lineProgress,
    required this.isFirst,
    required this.isLast,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double startY = isFirst ? _indicatorSize / 2 : 0;
    final double endY = isLast ? size.height - _indicatorSize / 2 : size.height;
    final double actualLineHeight = startY + (endY - startY) * lineProgress;

    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width / 2, startY),
      Offset(size.width / 2, actualLineHeight),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TimelineLinePainter oldDelegate) {
    return oldDelegate.lineProgress != lineProgress ||
        oldDelegate.lineColor != lineColor;
  }
}
