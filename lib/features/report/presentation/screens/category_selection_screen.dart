import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/category_model.dart';
import 'package:easy_localization/easy_localization.dart';

class CategorySelectionScreen extends StatefulWidget {
  final VoidCallback onBack;

  const CategorySelectionScreen({super.key, required this.onBack});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  String? _selectedCategoryId;

  void _handleSelect(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });

    // Visual feedback delay
    debugPrint('Selected Category: $categoryId');
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.pushNamed(context, '/add_evidence', arguments: categoryId);
      }
    });
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: widget.onBack,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'reporting.select_category'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'reporting.select_category_desc'.tr(),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // Categories Grid
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.85,
                            ),
                        itemCount: CategoryModel.dummyCategories.length,
                        itemBuilder: (context, index) {
                          return _CategoryCard(
                            category: CategoryModel.dummyCategories[index],
                            isSelected:
                                _selectedCategoryId ==
                                CategoryModel.dummyCategories[index].id,
                            onTap: () => _handleSelect(
                              CategoryModel.dummyCategories[index].id,
                            ),
                            delay: index,
                          );
                        },
                      ),

                      // Info Card
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        builder: (context, double value, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Opacity(opacity: value, child: child),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 24, bottom: 32),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfacePrimary.withValues(
                              alpha: 0.8,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.accentBlue.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.accentBlue.withValues(
                                    alpha: 0.2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(child: Text('💡')),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'reporting.quick_tip'.tr(),
                                      style: const TextStyle(
                                        color: AppColors.accentBlue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'reporting.category_tip_desc'.tr(),
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
                                        height: 1.4,
                                        fontSize: 13,
                                      ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;
  final int delay;
  final bool isWide; // To adjust internal layout if needed

  const _CategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
    required this.delay,
    this.isWide = false,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseScaleAnim;
  late Animation<double> _pulseOpacityAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseScaleAnim = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseOpacityAnim = Tween<double>(begin: 0.2, end: 0.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleController = AnimationController(
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _scaleController.reverse();

  void _onTapUp(TapUpDetails details) {
    _scaleController.forward();
    widget.onTap();
  }

  void _onTapCancel() => _scaleController.forward();

  @override
  Widget build(BuildContext context) {
    final isEmergency = widget.category.intensity == 'high';

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (widget.delay * 80)),
      curve: Curves.easeOutBack,
      builder: (context, double spawnValue, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - spawnValue)),
          child: Opacity(opacity: spawnValue.clamp(0.0, 1.0), child: child),
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: ScaleTransition(
          scale: _scaleController,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            // Remove padding here so the background pattern fills the whole card
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: widget.isSelected
                    ? widget.category.color
                    : AppColors.borderPrimary,
                width: 2,
              ),
              boxShadow: widget.isSelected
                  ? [
                      BoxShadow(
                        color: widget.category.color.withValues(alpha: 0.4),
                        blurRadius: 32,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : isEmergency
                  ? [
                      BoxShadow(
                        color: widget.category.color.withValues(alpha: 0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Emergency Pulse Effect Background (Before overlay to avoid blocking)
                  if (isEmergency && !widget.isSelected)
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseScaleAnim.value,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  center: const Alignment(-0.5, -0.5),
                                  radius: 1.0,
                                  colors: [
                                    widget.category.color.withValues(
                                      alpha: _pulseOpacityAnim.value,
                                    ),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  // Background Pattern
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.4,
                      child: CustomPaint(
                        painter: _CategoryPatternPainter(
                          pattern: widget.category.pattern,
                          color: widget.category.color,
                        ),
                      ),
                    ),
                  ),

                  // Gradient Overlay
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.7,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: widget.category.gradientColors,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: widget.category.color.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: widget.category.color.withValues(
                                alpha: 0.5,
                              ),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: widget.category.color.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              widget.category.icon,
                              color: widget.category.color,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.category.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                softWrap: true,
                              ),
                            ),
                            if (widget.isSelected)
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  start: 8.0,
                                  top: 4.0,
                                ),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: widget.category.color,
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.category.description,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 11,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  if (isEmergency)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: widget.category.color.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: widget.category.color.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          'URGENT',
                          style: TextStyle(
                            color: widget.category.color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryPatternPainter extends CustomPainter {
  final String pattern;
  final Color color;

  _CategoryPatternPainter({required this.pattern, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    switch (pattern) {
      case 'diagonal-lines':
        _paintDiagonalLines(canvas, size, color.withValues(alpha: 0.15));
        break;
      case 'flames':
        _paintFlames(canvas, size, color.withValues(alpha: 0.12));
        break;
      case 'leaves':
        _paintLeaves(canvas, size, color.withValues(alpha: 0.1));
        break;
      case 'medical':
        _paintMedical(canvas, size, color.withValues(alpha: 0.15));
        break;
      case 'abstract':
      default:
        _paintAbstract(canvas, size, color.withValues(alpha: 0.08));
        break;
    }
  }

  void _paintDiagonalLines(Canvas canvas, Size size, Color c) {
    final paint = Paint()
      ..color = c
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    double spacing = 20;
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  void _paintFlames(Canvas canvas, Size size, Color c) {
    final paint = Paint()
      ..color = c
      ..style = PaintingStyle.fill;

    double spacingX = 40;
    double spacingY = 40;

    for (double y = 0; y < size.height + spacingY; y += spacingY) {
      for (double x = 0; x < size.width + spacingX; x += spacingX) {
        Path path = Path();
        path.moveTo(x + 10, y + 20);
        path.quadraticBezierTo(x + 15, y + 10, x + 20, y + 20);
        path.quadraticBezierTo(x + 25, y + 30, x + 10, y + 20);
        canvas.drawPath(path, paint);
      }
    }
  }

  void _paintLeaves(Canvas canvas, Size size, Color c) {
    final paint = Paint()
      ..color = c
      ..style = PaintingStyle.fill;

    double spacing = 40;
    for (double y = 0; y < size.height + spacing; y += spacing) {
      for (double x = 0; x < size.width + spacing; x += spacing) {
        canvas.save();
        canvas.translate(x + 15, y + 15);
        canvas.rotate(30 * math.pi / 180);
        canvas.drawOval(
          Rect.fromCenter(center: Offset.zero, width: 16, height: 24),
          paint,
        );
        canvas.restore();
      }
    }
  }

  void _paintMedical(Canvas canvas, Size size, Color c) {
    final paint = Paint()
      ..color = c
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = c.withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    double spacing = 40;
    for (double y = 0; y < size.height + spacing; y += spacing) {
      for (double x = 0; x < size.width + spacing; x += spacing) {
        canvas.drawCircle(Offset(x + 10, y + 10), 3, paint);
        canvas.drawLine(
          Offset(x + 20, y + 15),
          Offset(x + 20, y + 25),
          strokePaint,
        );
        canvas.drawLine(
          Offset(x + 15, y + 20),
          Offset(x + 25, y + 20),
          strokePaint,
        );
      }
    }
  }

  void _paintAbstract(Canvas canvas, Size size, Color c) {
    final paint = Paint()
      ..color = c
      ..style = PaintingStyle.fill;

    double spacing = 40;
    for (double y = 0; y < size.height + spacing; y += spacing) {
      for (double x = 0; x < size.width + spacing; x += spacing) {
        canvas.drawCircle(Offset(x + 10, y + 10), 6, paint);
        canvas.drawCircle(
          Offset(x + 25, y + 25),
          4,
          Paint()..color = c.withValues(alpha: c.a * 0.7),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
