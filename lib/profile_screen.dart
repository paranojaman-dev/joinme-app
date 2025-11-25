import 'package:flutter/material.dart';
import 'main.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = '';
  int _age = 25;
  String _selectedGender = 'Mężczyzna';
  List<String> _selectedHobbies = [];
  String _conversationTopic = '';
  String _alcoholPreference = 'Obojętne';
  String _minAge = '20';
  String _maxAge = '35';

  final List<String> _hobbies = [
    'Podróże', 'Technologie', 'Książki', 'Sport', 'Muzyka',
    'Sztuka', 'Gotowanie', 'Gry', 'Filmy', 'Natura'
  ];

  final List<String> _genders = ['Mężczyzna', 'Kobieta', 'Inna'];
  final List<String> _alcoholOptions = ['Pije', 'Nie pije', 'Obojętne'];

  void _toggleHobby(String hobby) {
    setState(() {
      if (_selectedHobbies.contains(hobby)) {
        _selectedHobbies.remove(hobby);
      } else {
        _selectedHobbies.add(hobby);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A202C),
      appBar: AppBar(
        title: Text('Twój Profil'),
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
              // Zdjęcie profilowe
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                ),
              ),
              SizedBox(height: 20),

              // Imię
              TextField(
                decoration: InputDecoration(
                  labelText: 'Imię',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFF2D3748),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) => _name = value,
              ),
              SizedBox(height: 15),

              // Wiek
              Row(
                children: [
                  Text('Wiek: $_age', style: TextStyle(color: Colors.white)),
                  Expanded(
                    child: Slider(
                      value: _age.toDouble(),
                      min: 18,
                      max: 80,
                      divisions: 62,
                      onChanged: (value) {
                        setState(() {
                          _age = value.toInt();
                        });
                      },
                      activeColor: Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),

              // Płeć
              DropdownButtonFormField(
                value: _selectedGender,
                items: _genders.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value.toString();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Płeć',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFF2D3748),
                ),
                dropdownColor: Color(0xFF2D3748),
              ),
              SizedBox(height: 20),

              // Hobby
              Text('Hobby/Zainteresowania:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _hobbies.map((hobby) {
                  return FilterChip(
                    label: Text(hobby, style: TextStyle(color: Colors.white)),
                    selected: _selectedHobbies.contains(hobby),
                    onSelected: (selected) => _toggleHobby(hobby),
                    selectedColor: Color(0xFF4CAF50),
                    checkmarkColor: Colors.white,
                    backgroundColor: Color(0xFF4A5568),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),

              // Temat rozmowy
              TextField(
                decoration: InputDecoration(
                  labelText: 'Temat rozmowy (opcjonalnie)',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  hintText: 'np. Podróże, Technologie, Książki...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Color(0xFF2D3748),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) => _conversationTopic = value,
              ),
              SizedBox(height: 20),

              // Preferencje alkoholowe
              Text('Stosunek do alkoholu:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: _alcoholOptions.map((option) {
                  return ChoiceChip(
                    label: Text(option, style: TextStyle(color: Colors.white)),
                    selected: _alcoholPreference == option,
                    onSelected: (selected) {
                      setState(() {
                        _alcoholPreference = option;
                      });
                    },
                    selectedColor: Color(0xFF4CAF50),
                    backgroundColor: Color(0xFF4A5568),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),

              // Przedział wiekowy innych
              Text('Preferowany przedział wiekowy innych:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton(
                      value: _minAge,
                      items: List.generate(60, (index) => (18 + index).toString())
                          .map((age) => DropdownMenuItem(
                          value: age,
                          child: Text(age, style: TextStyle(color: Colors.white))
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _minAge = value.toString();
                        });
                      },
                      dropdownColor: Color(0xFF2D3748),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Text(' - ', style: TextStyle(color: Colors.white)),
                  Expanded(
                    child: DropdownButton(
                      value: _maxAge,
                      items: List.generate(60, (index) => (18 + index).toString())
                          .map((age) => DropdownMenuItem(
                          value: age,
                          child: Text(age, style: TextStyle(color: Colors.white))
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _maxAge = value.toString();
                        });
                      },
                      dropdownColor: Color(0xFF2D3748),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Przycisk zapisz
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainMapScreen()),
                          (route) => false,
                    );
                  },
                  child: Text('Zapisz Profil i Przejdź do Mapy',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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