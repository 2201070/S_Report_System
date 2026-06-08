import 'dart:io' show Platform, File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:s_report_system/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_report_system/features/report/presentation/cubit/report_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:s_report_system/core/utils/permission_service.dart';

// الإضافات الجديدة لتسجيل الصوت
import 'package:record/record.dart';
import 'package:path/path.dart' as p;

class AddEvidenceScreen extends StatefulWidget {
  final String categoryId;
  final VoidCallback onBack;

  const AddEvidenceScreen({
    super.key,
    required this.categoryId,
    required this.onBack,
  });

  @override
  State<AddEvidenceScreen> createState() => _AddEvidenceScreenState();
}

class _AddEvidenceScreenState extends State<AddEvidenceScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _images = [];
  String _description = '';
  bool _isRecording = false;
  bool _hasVoiceNote = false;
  String? _voicePath;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  // تهيئة مسجل الصوت
  final AudioRecorder _audioRecorder = AudioRecorder();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _audioRecorder.dispose(); // إغلاق مسجل الصوت لتنظيف الذاكرة
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    bool isGranted = false;
    try {
      if (source == ImageSource.camera) {
        isGranted = await PermissionService.requestCameraPermission();
      } else {
        isGranted = await PermissionService.requestGalleryPermission();
      }
    } on UnsupportedError catch (_) {
      isGranted = true; // Fallback for Web UnsupportedError
    } catch (e) {
      debugPrint('Permission exception: $e');
      isGranted = true; // Fallback for platforms where permission_handler crashes
    }

    if (!isGranted) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('reporting.permission_denied'.tr()),
            content: Text('reporting.permission_denied_desc'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('reporting.ok'.tr()),
              ),
            ],
          ),
        );
      }
      return;
    }

    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      String finalPath = pickedFile.path;
      if (!kIsWeb) {
        final directory = await getApplicationDocumentsDirectory();
        final savedImage = await File(
          pickedFile.path,
        ).copy('${directory.path}/${pickedFile.name}');
        finalPath = savedImage.path;
      }
      setState(() {
        _images.add(finalPath);
      });
    }
  }

  void _handleImageUpload() {
    if (kIsWeb) {
      _pickImage(ImageSource.gallery);
      return;
    }

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: Text('reporting.add_evidence'.tr()),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
              child: Text('reporting.take_photo'.tr()),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
              child: Text('reporting.choose_library'.tr()),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
            child: Text('reporting.cancel'.tr()),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.surfacePrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: Text(
                  'reporting.take_photo'.tr(),
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: Text(
                  'reporting.choose_library'.tr(),
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return CachedNetworkImageProvider(path);
    } else if (kIsWeb) {
      return NetworkImage(path);
    } else {
      return FileImage(File(path));
    }
  }

  // الدالة المحدثة لتسجيل الصوت الفعلي
  Future<void> _toggleRecording() async {
    if (_isRecording) {
      // إيقاف التسجيل والحصول على المسار الفعلي للملف
      final path = await _audioRecorder.stop();
      
      setState(() {
        _isRecording = false;
        if (path != null) {
          _hasVoiceNote = true;
          _voicePath = path; // مسار حقيقي على الهاتف
          debugPrint('Recorded file path: $_voicePath');
        }
      });
    } else {
      // التحقق من صلاحية المايكروفون أولاً
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        // إنشاء اسم فريد للملف باستخدام الوقت الحالي
        final String fileName = 'voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';
        final String filePath = p.join(directory.path, fileName);

        // بدء التسجيل الفعلي
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc), 
          path: filePath,
        );

        setState(() {
          _isRecording = true;
        });
      } else {
        debugPrint('Microphone permission denied');
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('reporting.permission_denied'.tr()),
              content: const Text('يرجى منح صلاحية الوصول للمايكروفون من إعدادات الهاتف لتتمكن من تسجيل الصوت.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('reporting.ok'.tr()),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  void _handleSubmit() {
    context.read<ReportCubit>().updateCategory(widget.categoryId);
    context.read<ReportCubit>().addImages(_images);
    context.read<ReportCubit>().updateDescription(_description);
    
    // تم تفعيل تمرير مسار الصوت بما أنه أصبح ملفاً حقيقياً الآن
    if (_hasVoiceNote && _voicePath != null) {
      context.read<ReportCubit>().updateVoicePath(_voicePath!);
    }
    
    Navigator.pushNamed(context, '/location_picker');
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
                  border: Border(
                    bottom: BorderSide(color: AppColors.borderPrimary),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: widget.onBack,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'reporting.add_evidence'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'reporting.step_1'.tr(),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.accentBlue,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 32,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.borderPrimary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 32,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.borderPrimary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Upload Photo/Video
                      Text(
                        'reporting.photo_video'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: _handleImageUpload,
                        borderRadius: BorderRadius.circular(24),
                        child: CustomPaint(
                          painter: _DashedBorderPainter(
                            color: AppColors.borderPrimary,
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: AppColors.surfacePrimary.withValues(
                                alpha: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.upload_rounded,
                                  color: AppColors.textSecondary,
                                  size: 48,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'reporting.tap_upload'.tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'reporting.drag_drop'.tr(),
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Preview Images
                      if (_images.isNotEmpty)
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: List.generate(_images.length, (index) {
                            return TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0.8, end: 1),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutBack,
                              builder: (context, double value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: child,
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 96,
                                    height: 96,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      image: DecorationImage(
                                        image: _getImageProvider(
                                          _images[index],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: InkWell(
                                      onTap: () => _removeImage(index),
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: const BoxDecoration(
                                          color: AppColors.accentRed,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      if (_images.isNotEmpty) const SizedBox(height: 24),

                      // Voice Note
                      Text(
                        'reporting.voice_note'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: _toggleRecording,
                        borderRadius: BorderRadius.circular(24),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: _isRecording
                                ? AppColors.accentRed.withValues(alpha: 0.1)
                                : _hasVoiceNote
                                ? AppColors.accentGreen.withValues(alpha: 0.1)
                                : AppColors.surfacePrimary.withValues(
                                    alpha: 0.5,
                                  ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: _isRecording
                                  ? AppColors.accentRed
                                  : _hasVoiceNote
                                  ? AppColors.accentGreen
                                  : AppColors.borderPrimary,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.mic,
                                color: _isRecording
                                    ? AppColors.accentRed
                                    : _hasVoiceNote
                                    ? AppColors.accentGreen
                                    : AppColors.textSecondary,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _isRecording
                                    ? 'reporting.stop_recording'.tr()
                                    : _hasVoiceNote
                                    ? 'reporting.voice_note_recorded'.tr()
                                    : 'reporting.record_voice_note'.tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_isRecording)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: AppColors.accentRed,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'reporting.recording'.tr(),
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Detailed Description
                      Text(
                        'reporting.description'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        onChanged: (value) =>
                            setState(() => _description = value),
                        maxLines: 5,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'reporting.description_hint'.tr(),
                          hintStyle: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                          filled: true,
                          fillColor: AppColors.surfacePrimary,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.borderPrimary,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.borderPrimary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.accentBlue,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32), // bottom spacing
                    ],
                  ),
                ),
              ),

              // Fixed Bottom Button
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.borderPrimary),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        (_images.isNotEmpty ||
                            _hasVoiceNote ||
                            _description.trim().isNotEmpty)
                        ? _handleSubmit
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentBlue,
                      disabledBackgroundColor: AppColors.borderPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'reporting.continue_location'.tr(),
                      style: const TextStyle(
                        color: AppColors.backgroundStart,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
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

class _DashedBorderPainter extends CustomPainter {
  final Color color;

  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(24),
      ),
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}