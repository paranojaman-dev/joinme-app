import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  List<String> _selectedGenders = ['Mężczyźni', 'Kobiety'];
  int _minAge = 20;
  int _maxAge = 35;
  List<String> _selectedInterests = [];

  final List<String> _allInterests = [
    'Podróże', 'Technologie', 'Książki', 'Sport', 'Muzyka',
    'Sztuka', 'Gotowanie', 'Gry', 'Filmy', 'Natura', 'Moda',
    'Zwierzaki', 'Samorozwój', 'Biznes', 'Nauka'
  ];

  void _toggleGender(String gender) {
    setState(() {
      if (_selectedGenders.contains(gender)) {
        _selectedGenders.remove(gender);
      } else {
        _selectedGenders.add(gender);
      }
    });
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A202C),
      appBar: AppBar(
        title: Text('Kto może mnie znaleźć?'),
        backgroundColor: Color(0xFF2D3748),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFF1A202C),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Płeć
              Text(
                'Pokazuj mnie:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 15),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ['Mężczyźni', 'Kobiety'].map((gender) {
                  return FilterChip(
                    label: Text(gender, style: TextStyle(color: Colors.white)),
                    selected: _selectedGenders.contains(gender),
                    onSelected: (selected) => _toggleGender(gender),
                    selectedColor: Color(0xFF4CAF50),
                    checkmarkColor: Colors.white,
                    backgroundColor: Color(0xFF4A5568),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),

              // Przedział wiekowy
              Text(
                'Przedział wiekowy:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text('Od: $_minAge', style: TextStyle(fontSize: 16, color: Colors.white)),
                  Expanded(
                    child: Slider(
                      value: _minAge.toDouble(),
                      min: 18,
                      max: _maxAge.toDouble(),
                      divisions: (_maxAge - 18),
                      onChanged: (value) {
                        setState(() {
                          _minAge = value.toInt();
                        });
                      },
                      activeColor: Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Do: $_maxAge', style: TextStyle(fontSize: 16, color: Colors.white)),
                  Expanded(
                    child: Slider(
                      value: _maxAge.toDouble(),
                      min: _minAge.toDouble(),
                      max: 80,
                      divisions: (80 - _minAge),
                      onChanged: (value) {
                        setState(() {
                          _maxAge = value.toInt();
                        });
                      },
                      activeColor: Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Zainteresowania
              Text(
                'Wspólne zainteresowania:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'Pokazuj tylko osoby z tymi zainteresowaniami:',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
              SizedBox(height: 15),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _allInterests.map((interest) {
                  return FilterChip(
                    label: Text(interest, style: TextStyle(color: Colors.white)),
                    selected: _selectedInterests.contains(interest),
                    onSelected: (selected) => _toggleInterest(interest),
                    selectedColor: Color(0xFF4CAF50),
                    checkmarkColor: Colors.white,
                    backgroundColor: Color(0xFF4A5568),
                  );
                }).toList(),
              ),
              SizedBox(height: 40),

              // Przyciski
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
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
                      onPressed: () {
                        print('Zapisano filtry:');
                        print('Płeć: $_selectedGenders');
                        print('Wiek: $_minAge - $_maxAge');
                        print('Zainteresowania: $_selectedInterests');
                        Navigator.pop(context);
                      },
                      child: Text('Zapisz', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}