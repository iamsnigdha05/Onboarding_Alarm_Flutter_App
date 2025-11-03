class Alarm {
  final int id;
  final DateTime scheduledAt;
  final String title;


  Alarm({required this.id, required this.scheduledAt, required this.title});


  Map<String, dynamic> toJson() => {'id': id, 'scheduledAt': scheduledAt.toIso8601String(), 'title': title};
  factory Alarm.fromJson(Map<String, dynamic> j) => Alarm(id: j['id'], scheduledAt: DateTime.parse(j['scheduledAt']), title: j['title']);
}