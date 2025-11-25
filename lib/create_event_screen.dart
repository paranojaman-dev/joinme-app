import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'models/event.dart'; // 🆕 DODAJ TEN IMPORT

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _topicController = TextEditingController();

  String _selectedActivity = 'Planszówki';
  int _maxPeople = 4;
  String _selectedTime = 'Za 30 minut';
  LatLng? _selectedLocation;

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

  String _getEmojiForActivity(String activity) {
    return _activityIcons[activity] ?? '🌟';
  }

  void _createEvent() {
    try {
      // Prosta walidacja
      if (_selectedActivity.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wybierz rodzaj aktywności!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Utwórz event
      final newEvent = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        activity: _selectedActivity,
        emoji: _getEmojiForActivity(_selectedActivity),
        maxPeople: _maxPeople,
        currentPeople: 1,
        time: _selectedTime,
        topic: _topicController.text.isEmpty ? null : _topicController.text,
        location: _selectedLocation ?? LatLng(52.2297, 21.0122),
        creatorName: 'Maciej',
        isActive: true,
      );

      // Bezpieczne zamknięcie
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(newEvent);
        }
      });

    } catch (e) {
      print('Błąd tworzenia eventu: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
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
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
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
            TextFormField(
              controller: _topicController,
              decoration: InputDecoration(
                labelText: 'Temat rozmowy (opcjonalnie)',
                labelStyle: TextStyle(color: Colors.white),
                hintText: 'np. Gry strategiczne, Muzyka rockowa...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
                filled: true,
                fillColor: Color(0xFF4A5568),
              ),
              style: TextStyle(color: Colors.white),
              maxLines: 2,
            ),
            SizedBox(height: 30),

            // Informacja o lokalizacji
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF4A5568),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lokalizacja eventu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _selectedLocation != null
                              ? '${_selectedLocation!.latitude.toStringAsFixed(4)}, ${_selectedLocation!.longitude.toStringAsFixed(4)}'
                              : 'Użyj Twojej aktualnej lokalizacji',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Używamy Twojej aktualnej lokalizacji 📍'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                    icon: Icon(Icons.edit_location, color: Colors.orange, size: 20),
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
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
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
                    onPressed: _createEvent,
                    child: Text('Stwórz Event!', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }
}