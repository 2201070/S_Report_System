
enum AlertType { urgent, warning, info }

class AlertModel {
  final String id;
  final AlertType type;
  final String title;
  final String location;
  final String time;
  final String affectedPeople;

  AlertModel({
    required this.id,
    required this.type,
    required this.title,
    required this.location,
    required this.time,
    required this.affectedPeople,
  });

  static List<AlertModel> get dummyAlerts => [
        AlertModel(
          id: '1',
          type: AlertType.urgent,
          title: 'Power Outage in Maadi',
          location: 'Maadi District',
          time: '15 min ago',
          affectedPeople: '5,000+',
        ),
        AlertModel(
          id: '2',
          type: AlertType.warning,
          title: 'Road Closure: Ring Road',
          location: 'Ring Road, Exit 12',
          time: '1 hour ago',
          affectedPeople: '2,000+',
        ),
        AlertModel(
          id: '3',
          type: AlertType.info,
          title: 'Water Supply Maintenance',
          location: 'Heliopolis',
          time: '3 hours ago',
          affectedPeople: '1,500+',
        ),
      ];
}
