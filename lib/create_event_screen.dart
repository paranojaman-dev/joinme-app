import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  String _selectedActivity = 'Planszówki';
  int _maxPeople = 4;
  String _selectedTime = 'Za 30 minut';
  String _conversationTopic = '';
  LatLng _eventLocation = LatLng(52.2297, 21.0122);

  final List<String> _activities = [
    'Planszówki', 'Karaoke', 'Spacer', 'Kawiarnia',
    'Gry karciane', 'Koncert', 'Sport', 'Jedzenie',
    'Nauka', 'Muzyka', 'Sztuka', 'Piwo', 'Inne'
  ];

  final List<String> _timeOptions = [
    'Teraz!', 'Za 15 minut', 'Za 30 minut',
    'Za 1 godzinę', 'Za 2 godziny'
  ];

  final Map<String, String> _activityIcons = {
    'Planszówki': '🎲',
    'Karaoke': '🎤',
    'Spacer': '🚶',
    'Kawiarnia': '☕',
    'Gry karciane': '🃏',
    'Koncert': '🎵',
    'Sport': '⚽',
    'Jedzenie': '🍔',
    'Nauka': '📚',
    'Muzyka': '🎧',
    'Sztuka': '🎨',
    'Piwo': '🍻',
    'Inne': '🌟'
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nagłówek
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stwórz Event',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Aktywność
          Text('Co robimy?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _activities.map((activity) {
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_activityIcons[activity]!),
                    SizedBox(width: 6),
                    Text(activity, style: TextStyle(color: Colors.white)),
                  ],
                ),
                selected: _selectedActivity == activity,
                onSelected: (selected) {
                  setState(() {
                    _selectedActivity = activity;
                  });
                },
                selectedColor: Colors.orange,
                backgroundColor: Color(0xFF4A5568),
              );
            }).toList(),
          ),
          SizedBox(height: 20),

          // Liczba osób
          Text('Maksymalna liczba osób:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 10),
          Row(
            children: [
              Text('$_maxPeople osób', style: TextStyle(color: Colors.white)),
              Expanded(
                child: Slider(
                  value: _maxPeople.toDouble(),
                  min: 2,
                  max: 10,
                  divisions: 8,
                  onChanged: (value) {
                    setState(() {
                      _maxPeople = value.toInt();
                    });
                  },
                  activeColor: Colors.orange,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Czas
          Text('Kiedy się spotykamy?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _timeOptions.map((time) {
              return ChoiceChip(
                label: Text(time, style: TextStyle(color: Colors.white)),
                selected: _selectedTime == time,
                onSelected: (selected) {
                  setState(() {
                    _selectedTime = time;
                  });
                },
                selectedColor: Colors.orange,
                backgroundColor: Color(0xFF4A5568),
              );
            }).toList(),
          ),
          SizedBox(height: 20),

          // Temat rozmowy (opcjonalnie)
          TextField(
            decoration: InputDecoration(
              labelText: 'Temat rozmowy (opcjonalnie)',
              labelStyle: TextStyle(color: Colors.white),
              hintText: 'np. Gry strategiczne, Muzyka rockowa...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Color(0xFF4A5568),
            ),
            style: TextStyle(color: Colors.white),
            onChanged: (value) => _conversationTopic = value,
          ),
          SizedBox(height: 30),

          // Informacja o lokalizacji
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF4A5568),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Event będzie widoczny w Twojej aktualnej lokalizacji',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Przyciski
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Anuluj', style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    side: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _createEvent();
                  },
                  child: Text('Stwórz Event!', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _createEvent() {
    // Mapowanie aktywności na emoji
    final activityEmojis = {
      'Planszówki': '🎲',
      'Karaoke': '🎤',
      'Spacer': '🚶',
      'Kawiarnia': '☕',
      'Gry karciane': '🃏',
      'Koncert': '🎵',
      'Sport': '⚽',
      'Jedzenie': '🍔',
      'Nauka': '📚',
      'Muzyka': '🎧',
      'Sztuka': '🎨',
      'Piwo': '🍻',
      'Inne': '🌟'
    };

    // Tworzymy nowy event
    final newEvent = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      activity: _selectedActivity,
      emoji: activityEmojis[_selectedActivity] ?? '🌟',
      maxPeople: _maxPeople,
      currentPeople: 1,
      time: _selectedTime,
      topic: _conversationTopic.isNotEmpty ? _conversationTopic : null,
      location: _eventLocation,
      creatorName: 'Maciej',
      isActive: true,
    );

    // Zamykamy ekran i przekazujemy event do MainMapScreen
    Navigator.pop(context, newEvent);
  }
}

// KLASA EVENT (potrzebna dla tego pliku)
class Event {
  final String id;
  final String activity;
  final String emoji;
  final int maxPeople;
  final int currentPeople;
  final String time;
  final String? topic;
  final LatLng location;
  final String creatorName;
  final bool isActive;

  Event({
    required this.id,
    required this.activity,
    required this.emoji,
    required this.maxPeople,
    required this.currentPeople,
    required this.time,
    required this.topic,
    required this.location,
    required this.creatorName,
    this.isActive = true,
  });
}