
enum ReportStatus { pending, progress, resolved, urgent }

class ReportHistoryModel {
  final String id;
  final String title;
  final String category;
  final String date;
  final ReportStatus status;
  final String? thumbnail; // Accepts network URL or local asset path
  final bool isNetworkImage;

  ReportHistoryModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.status,
    this.thumbnail,
    this.isNetworkImage = true,
  });

  static List<ReportHistoryModel> get dummyReports => [
        ReportHistoryModel(
          id: 'SR-99821',
          title: 'Broken Street Light',
          category: 'Infrastructure',
          date: '2 hours ago',
          status: ReportStatus.progress,
          thumbnail: 'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=400',
        ),
        ReportHistoryModel(
          id: 'SR-99820',
          title: 'Pothole on Main Road',
          category: 'Infrastructure',
          date: 'Yesterday',
          status: ReportStatus.pending,
          thumbnail: 'https://images.unsplash.com/photo-1625935212146-a63f46cf12fc?w=400',
        ),
        ReportHistoryModel(
          id: 'SR-99819',
          title: 'Illegal Dumping',
          category: 'Environmental',
          date: '3 days ago',
          status: ReportStatus.resolved,
          thumbnail: 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=400',
        ),
      ];
}
