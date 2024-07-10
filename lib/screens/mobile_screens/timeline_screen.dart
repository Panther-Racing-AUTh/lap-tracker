import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/drawer_model.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {


  final List<Map<String, dynamic>> timelineData = [
    {
      'duration': DateTime(2024, 1),
      'tasks': [
        '-Ευρεση αναβάτη\n-Μετρηση για βασικες διαστάσεις μηχανής (Μακέτα)'
      ],
      'icon': Icons.event_note // Planning and Measurements
    },
    {
      'duration': DateTime(2024, 2),
      'tasks': [
          '-Ευρεση αναβάτη\n-Μετρηση για βασικες διαστάσεις μηχανής (Μακέτα)',
          '-Βασικές διαστάσεις μηχανής',
          '-Αρχικά σχέδια μηχανής'
      ],
      'icon': Icons.event_note // Planning and Measurements
    },
    {
      'duration': DateTime(2024, 3),
      'tasks': [
        '-Αρχικά σχέδια μηχανής',
        '-Στατική ανάλυση στα structural κομμάτια της μηχανής'
      ],
      'icon': Icons.design_services // Design and Analysis
    },
    {
      'duration': DateTime(2024, 4),
      'tasks': [
        '-Στατική ανάλυση στα structural κομμάτια της μηχανής'
      ],
      'icon': Icons.design_services // Design and Analysis
    },
    {
      'duration': DateTime(2024, 5),
      'tasks': [
        '-Στατική ανάλυση στα structural κομμάτια της μηχανής'
      ],
      'icon': Icons.design_services // Design and Analysis
    },
    {
      'duration': DateTime(2024, 6),
      'tasks': [
        '-Στατική ανάλυση στα structural κομμάτια της μηχανής',
        '-Τελικά σχέδια μηχανής και πρώτη Assembly μηχανής',
        '-Δυναμικές αναλύσεις στην assembly & lap time simulation',
        '-Συγγραφή Chapter A & Παράδοση'
      ],
      'icon': Icons.design_services // Design and Analysis
    },
    {
      'duration': DateTime(2024, 7),
      'tasks': [
        '-Δυναμικές αναλύσεις στην assembly & lap time simulation',
        '-Συγγραφή Chapter A & Παράδοση'
      ],
      'icon': Icons.build // Assembly and Testing
    },
    {
      'duration': DateTime(2024, 8),
      'tasks': [
        '-Δυναμικές αναλύσεις στην assembly & lap time simulation',
        '-Συγγραφή Chapter A & Παράδοση'
      ],
      'icon': Icons.article // Writing and Documentation
    },
    {
      'duration': DateTime(2024, 9),
      'tasks': [
        '-Συγγραφή Chapter A & Παράδοση',
        '-Ευρεση μηχανουργείων & Υλικών για κατεργασια'
      ],
      'icon': Icons.shopping_cart // Procurement and Manufacturing
    },
    {
      'duration': DateTime(2024, 10),
      'tasks': [
        '-Ευρεση μηχανουργείων & Υλικών για κατεργασια',
        '-Συγγραφή Chapter Β & Παράδοση'
      ],
      'icon': Icons.article // Writing and Documentation
    },
    {
      'duration': DateTime(2024, 11),
      'tasks': [
        '-Συγγραφή Chapter Β & Παράδοση',
        '-Αρχή κατεργασιών & ετοιμα κομμάτια'
      ],
      'icon': Icons.shopping_cart // Procurement and Manufacturing
    },
    {
      'duration': DateTime(2024, 12),
      'tasks': [
        '-Συγγραφή Chapter Β & Παράδοση',
        '-Αρχή κατεργασιών & ετοιμα κομμάτια'
      ],
      'icon': Icons.shopping_cart // Procurement and Manufacturing
    },
    {
      'duration': DateTime(2025, 1),
      'tasks': [
        '-Συγγραφή Chapter Β & Παράδοση',
        '-Αρχή κατεργασιών & ετοιμα κομμάτια',
        'Παραλαβή κομματιών και πρώτη assembly μηχανής'
      ],
      'icon': Icons.build // Assembly and Testing
    },
    {
      'duration': DateTime(2025, 2),
      'tasks': [
        '-Παραλαβή κομματιών και πρώτη assembly μηχανής',
        '-Εργαστηριακά πειράματα'
      ],
      'icon': Icons.build // Assembly and Testing
    },
    {
      'duration': DateTime(2025, 3),
      'tasks': [
        '-Εργαστηριακά πειράματα',
        '-Συγγραφή Chapter C & Παράδοση'
      ],
      'icon': Icons.article // Writing and Documentation
    },
    {
      'duration': DateTime(2025, 4),
      'tasks': [
        '-Εργαστηριακά πειράματα',
        '-Συγγραφή Chapter C & Παράδοση',
        '-Track testing της μηχανης'
      ],
      'icon': Icons.article // Writing and Documentation
    },
    {
      'duration': DateTime(2025, 5),
      'tasks': [
        '-Εργαστηριακά πειράματα',
        '-Συγγραφή Chapter C & Παράδοση',
        '-Track testing της μηχανης'
      ],
      'icon': Icons.directions_bike // Assembly and Testing
    },
    {
      'duration': DateTime(2025, 6),
      'tasks': [
        '-Εργαστηριακά πειράματα',
        '-Συγγραφή Chapter C & Παράδοση',
        '-Track testing της μηχανης'
      ],
      'icon': Icons.directions_bike // Assembly and Testing
    },
    {
      'duration': DateTime(2025, 7),
      'tasks': [
        '-Track testing της μηχανης'
      ],
      'icon': Icons.directions_bike // Assembly and Testing
    },
    {
      'duration': DateTime(2025, 8),
      'tasks': [

        '-Track testing της μηχανης'
      ],
      'icon': Icons.directions_bike // Assembly and Testing
    },
    {
      'duration': DateTime(2025, 9),
      'tasks': [
        '-Track testing της μηχανης'
      ],
      'icon': Icons.directions_bike // Assembly and Testing
    },
    {
      'duration': DateTime(2025, 9),
      'tasks': [
        '-Track testing της μηχανης'
      ],
      'icon': Icons.directions_bike // Assembly and Testing
    },
  ];



  final DateTime now = DateTime.now().add(Duration(days: 23));
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Timeline'),
      ),
      drawer: DrawerModel(context, DrawerIndexValue.timeline.getInt()),
      body: SingleChildScrollView(
        child: Column(
          children: timelineData.asMap().entries.map((entry) {
            final index = entry.key;
            final event = entry.value;

            return _buildTimelineTile(
              index,
              duration: event['duration'] as DateTime,
              tasks: event['tasks'] as List<String>,
              isCurrentMonth: _isCurrentMonth(event['duration'] as DateTime),
              isBeforeMonth: _isBeforeToday(event['duration'] as DateTime),
              isFirst: index == 0,
              isLast: index == timelineData.length - 1,
              nextEventIsBeforeToday: _nextEventIsBeforeToday(event),
            );
          }).toList(),
        ),
      ),
    );
  }

  bool _isCurrentMonth(DateTime duration) {
    return duration.year == now.year && duration.month == now.month;
  }

  bool _isBeforeToday(DateTime duration) {
    DateTime today = DateTime(now.year, now.month);
    return duration.isBefore(today);
  }

  bool _nextEventIsBeforeToday(Map<String, dynamic> currentEvent) {
    int currentIndex = timelineData.indexOf(currentEvent);
    if (currentIndex < timelineData.length - 1) {
      DateTime nextEventDate = timelineData[currentIndex + 1]['duration'] as DateTime;
      return _isBeforeToday(nextEventDate);
    }
    return true;
  }

  String formatDate(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  Widget _buildTimelineTile(
      int index, {
        required DateTime duration,
        required List<String> tasks,
        required bool isCurrentMonth,
        required bool isBeforeMonth,
        bool isFirst = false,
        bool isLast = false,
        bool nextEventIsBeforeToday = false,
      }) {
    final isExpanded = index == _expandedIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedIndex = isExpanded ? null : index;
        });
      },
      child: TimelineTile(
        alignment: TimelineAlign.start,
        isFirst: isFirst,
        isLast: isLast,
        indicatorStyle: IndicatorStyle(
          width: 40,
          color: isBeforeMonth ? Colors.grey : Colors.blue,
          iconStyle: IconStyle(
            iconData: timelineData[index]['icon'],
            color: isBeforeMonth ? Colors.grey.shade700 : Colors.white,
          ),
        ),
        beforeLineStyle: LineStyle(
          color: isFirst ? Colors.transparent : (isBeforeMonth || isCurrentMonth ? Colors.grey : Colors.blue),
        ),
        afterLineStyle: LineStyle(
          color: isLast ? Colors.transparent : (isBeforeMonth ? Colors.grey : Colors.blue),
        ),

        endChild: Container(
          margin: EdgeInsets.all(20),
          constraints: BoxConstraints(
            minHeight: isCurrentMonth ? 50 : 20,
          ),
          decoration: BoxDecoration(
            color: isCurrentMonth ? Colors.amber : isBeforeMonth ? Colors.grey.shade500 : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                spreadRadius: 1,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatDate(duration),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 8),
                if (isExpanded)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: tasks.map((task) => Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Text(
                        task,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )).toList(),
                  ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Task{
  String name;
  DateTime startDate;
  DateTime endDate;
  Color color;


  Task({required this.name,required this.startDate,required this.endDate,required this.color});

}

