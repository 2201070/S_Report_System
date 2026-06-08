import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';

class TimelineStepModel {
  final int id;
  final String label;
  final String description;
  final String time;
  final String status;

  TimelineStepModel({
    required this.id,
    required this.label,
    required this.description,
    required this.time,
    required this.status,
  });
}

class ReportTrackingScreen extends StatefulWidget {
  final String reportId;

  const ReportTrackingScreen({
    super.key,
    required this.reportId,
  });

  @override
  State<ReportTrackingScreen> createState() => _ReportTrackingScreenState();
}

class _ReportTrackingScreenState extends State<ReportTrackingScreen> with TickerProviderStateMixin {
  final List<TimelineStepModel> timelineSteps = [
    TimelineStepModel(
      id: 1,
      label: 'Report Received',
      description: 'Your report has been received and logged',
      time: '2 hours ago',
      status: 'completed',
    ),
    TimelineStepModel(
      id: 2,
      label: 'Authority Assigned',
      description: 'Routed to Infrastructure Department',
      time: '1 hour ago',
      status: 'completed',
    ),
    TimelineStepModel(
      id: 3,
      label: 'Maintenance Team on Site',
      description: 'Team is currently working on the issue',
      time: 'Active now',
      status: 'active',
    ),
    TimelineStepModel(
      id: 4,
      label: 'Resolution',
      description: 'Issue will be marked as resolved',
      time: 'Pending',
      status: 'pending',
    ),
  ];

  late AnimationController _lineController;
  late Animation<double> _lineAnimation;

  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late Animation<double> _pulseScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Line fill animation
    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _lineAnimation = Tween<double>(begin: 0.0, end: 0.65).animate(
      CurvedAnimation(parent: _lineController, curve: Curves.easeOut),
    );
    _lineController.forward();

    // Truck rotation animation
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // In Progress dot pulsing animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseScaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(_pulseController);
  }

  @override
  void dispose() {
    _lineController.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundStart, AppColors.backgroundEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.borderPrimary)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                      ),
                    ),
                    Text(
                      'history.tracking_title'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'history.report_id'.tr(args: [widget.reportId]),
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100), // padding for bottom button
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Map View
                      Container(
                        margin: const EdgeInsets.all(24),
                        height: 192,
                        decoration: BoxDecoration(
                          color: AppColors.surfacePrimary,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppColors.borderPrimary),
                        ),
                        child: Stack(
                          children: [
                            // Mock Map Grid
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Color(0xFF1a1f26), Color(0xFF0f1318)],
                                  ),
                                ),
                                child: Opacity(
                                  opacity: 0.1,
                                  child: GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 6,
                                      childAspectRatio: 1.0,
                                    ),
                                    itemCount: 24,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.borderPrimary),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                            // Location Pin
                            const Center(
                              child: Icon(
                                Icons.location_on,
                                color: AppColors.accentBlue,
                                size: 40,
                              ),
                            ),

                            // Address Label
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundStart.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.borderPrimary),
                                ),
                                child: Text(
                                  '123 Al-Ahram St, Giza',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Timeline
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'history.timeline'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            Stack(
                              children: [
                                // Vertical Line Base
                                Positioned(
                                  left: 23, // 48/2 - 1
                                  top: 0,
                                  bottom: 0,
                                  width: 2,
                                  child: Container(
                                    color: AppColors.borderPrimary,
                                  ),
                                ),
                                // Animated Vertical Line Fill
                                Positioned(
                                  left: 23,
                                  top: 0,
                                  bottom: 0,
                                  width: 2,
                                  child: AnimatedBuilder(
                                    animation: _lineAnimation,
                                    builder: (context, child) {
                                      return FractionallySizedBox(
                                        alignment: Alignment.topCenter,
                                        heightFactor: _lineAnimation.value,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.accentBlue,
                                                AppColors.accentBlue.withValues(alpha: 0.0),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                // Steps List
                                Column(
                                  children: timelineSteps.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final step = entry.value;

                                    return TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 0, end: 1),
                                      duration: Duration(milliseconds: 400 + (index * 200)),
                                      builder: (context, double value, child) {
                                        return Opacity(
                                          opacity: value,
                                          child: Transform.translate(
                                            offset: Offset(-20 * (1 - value), 0),
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: _buildTimelineStep(step),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom Action
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppColors.backgroundStart,
              AppColors.backgroundStart.withValues(alpha: 0.8),
              AppColors.backgroundStart.withValues(alpha: 0.0),
            ],
          ),
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: () {
              // Chat action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfacePrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.borderPrimary),
              ),
            ),
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            label: Text(
              'history.chat_support'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineStep(TimelineStepModel step) {
    Color iconBackgroundColor;
    IconData iconData;
    Color iconColor;

    if (step.status == 'completed') {
      iconBackgroundColor = AppColors.accentGreen;
      iconData = Icons.check_circle_outline;
      iconColor = AppColors.backgroundStart;
    } else if (step.status == 'active') {
      iconBackgroundColor = AppColors.accentBlueLight;
      iconData = Icons.local_shipping_outlined;
      iconColor = Colors.white;
    } else {
      iconBackgroundColor = AppColors.borderPrimary;
      iconData = Icons.access_time;
      iconColor = AppColors.textSecondary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.backgroundStart, width: 4),
            ),
            child: Center(
              child: step.status == 'active'
                  ? AnimatedBuilder(
                      animation: _rotateController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotateController.value * 2 * math.pi,
                          child: Icon(iconData, color: iconColor, size: 24),
                        );
                      },
                    )
                  : Icon(iconData, color: iconColor, size: 24),
            ),
          ),
          const SizedBox(width: 16),
          // Content Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: step.status == 'active' ? AppColors.accentBlueLight : AppColors.borderPrimary,
                  width: 1,
                ),
                boxShadow: step.status == 'active'
                    ? [
                        BoxShadow(
                          color: AppColors.accentBlueLight.withValues(alpha: 0.1),
                          blurRadius: 12,
                          spreadRadius: 2,
                        )
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          step.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        step.time,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  if (step.status == 'active') ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        AnimatedBuilder(
                          animation: _pulseScaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseScaleAnimation.value,
                              child: child,
                            );
                          },
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.accentBlueLight,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'history.in_progress'.tr(),
                          style: const TextStyle(
                            color: AppColors.accentBlueLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
