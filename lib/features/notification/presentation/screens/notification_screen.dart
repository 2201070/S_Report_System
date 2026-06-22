import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:s_report_system/core/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  Set<String> _deletedIds = {};

  @override
  void initState() {
    super.initState();
    _loadDeletedIds().then((_) => _loadNotifications());
  }

  Future<void> _loadDeletedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final deleted = prefs.getStringList('deleted_notifications') ?? [];
    setState(() => _deletedIds = deleted.toSet());
  }

  Future<void> _saveDeletedId(String id) async {
    _deletedIds.add(id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('deleted_notifications', _deletedIds.toList());
  }

Future<void> _loadNotifications() async {
  setState(() => _isLoading = true);
  try {
    // ✅ جيب الـ cityId بتاع اليوزر
    final prefs = await SharedPreferences.getInstance();
    final myCityId = prefs.getInt('cityId') ?? 0;

    final r1 = await ApiClient.get('/api/Notification/MyNotifications');
    final r2 = await ApiClient.get('/api/Notification/city');

    List<Map<String, dynamic>> all = [];
    if (r1.statusCode == 200) {
      final list = jsonDecode(r1.body) as List;
      all.addAll(list.map((e) => Map<String, dynamic>.from(e)));
    }
    if (r2.statusCode == 200) {
      final list = jsonDecode(r2.body) as List;
      all.addAll(list.map((e) => Map<String, dynamic>.from(e)));
    }

    // ✅ فلتر يدوي: امسح أي إشعار من cityId مختلف عن مدينة اليوزر
    all = all.where((n) {
      // لو الإشعار مفيهوش cityId خالص، سيبه (لأنه شخصي من MyNotifications)
      if (!n.containsKey('cityId')) return true;
      final notifCityId = n['cityId'];
      return notifCityId == null || notifCityId == myCityId;
    }).toList();

    // شيل الإشعارات المحذوفة
    all.removeWhere((n) {
      final id = '${n['title']}_${n['date']}';
      return _deletedIds.contains(id);
    });

    // رتب حسب الأحدث
    all.sort((a, b) {
      final da = DateTime.tryParse(a['date'] ?? '') ?? DateTime(2000);
      final db = DateTime.tryParse(b['date'] ?? '') ?? DateTime(2000);
      return db.compareTo(da);
    });

    setState(() => _notifications = all);
  } catch (e) {
    debugPrint('❌ Error: $e');
  } finally {
    setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff1565C0), Color(0xff42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "مركز الإشعارات",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "تابع آخر التنبيهات الخاصة بك",
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // LIST
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _notifications.isEmpty
                  ? _emptyState()
                  : RefreshIndicator(
                      onRefresh: _loadNotifications,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          final notif = _notifications[index];
                          return Dismissible(
                            key: Key('${notif['title']}_${notif['date']}'),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) async {
                              final id = '${notif['title']}_${notif['date']}';
                              await _saveDeletedId(id); // ✅ احفظ في الذاكرة
                              setState(() => _notifications.removeAt(index));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم حذف الإشعار'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 25),
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            child: _notificationCard(notif),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationCard(Map<String, dynamic> notif) {
  String dateStr = '';
  try {
    
    final date = DateTime.parse(notif['date']).toLocal(); // ✅ أضف toLocal()
    dateStr =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} - ${date.day}/${date.month}';
  } catch (_) {}


    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blue.withOpacity(.1),
            child: const Icon(
              Icons.notifications_active,
              color: Colors.blue,
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notif['title'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  notif['body'] ?? '',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  dateStr,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 120,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Text(
            "لا توجد إشعارات",
            style: TextStyle(
              fontSize: 22,
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "سيتم عرض الإشعارات الجديدة هنا",
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
