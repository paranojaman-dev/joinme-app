import 'package:flutter/material.dart';
import 'main_map_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
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
      backgroundColor: const Color(0xFF1A202C),
      appBar: AppBar(
        title: const Text('Twój Profil'),
        backgroundColor: const Color(0xFF2D3748),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo zamiast zdjęcia
            Center(
              child: Text(
                'JOINME',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade400,
                  letterSpacing: 4,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Imię
            TextField(
              decoration: InputDecoration(
                labelText: 'Imię',
                labelStyle: const TextStyle(color: Colors.white),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: const Color(0xFF2D3748),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) => _name = value,
            ),
            const SizedBox(height: 15),

            // Wiek
            Row(
              children: [
                Text('Wiek: $_age', style: const TextStyle(color: Colors.white)),
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
                    activeColor: const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Płeć
            DropdownButtonFormField(
              value: _selectedGender,
              items: _genders.map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value.toString();
                });
              },
              decoration: InputDecoration(
                labelText: 'Płeć',
                labelStyle: const TextStyle(color: Colors.white),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: const Color(0xFF2D3748),
              ),
              dropdownColor: const Color(0xFF2D3748),
            ),
            const SizedBox(height: 20),

            // Hobby
            const Text(
              'Hobby/Zainteresowania:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _hobbies.map((hobby) {
                return FilterChip(
                  label: Text(hobby, style: const TextStyle(color: Colors.white)),
                  selected: _selectedHobbies.contains(hobby),
                  onSelected: (_) => _toggleHobby(hobby),
                  selectedColor: const Color(0xFF4CAF50),
                  checkmarkColor: Colors.white,
                  backgroundColor: const Color(0xFF4A5568),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Temat rozmowy
            TextField(
              decoration: InputDecoration(
                labelText: 'Temat rozmowy (opcjonalnie)',
                labelStyle: const TextStyle(color: Colors.white),
                border: const OutlineInputBorder(),
                hintText: 'np. Podróże, Technologie, Książki...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: const Color(0xFF2D3748),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) => _conversationTopic = value,
            ),
            const SizedBox(height: 20),

            // Preferencje alkoholowe
            const Text(
              'Stosunek do alkoholu:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _alcoholOptions.map((option) {
                return ChoiceChip(
                  label: Text(option, style: const TextStyle(color: Colors.white)),
                  selected: _alcoholPreference == option,
                  onSelected: (_) {
                    setState(() {
                      _alcoholPreference = option;
                    });
                  },
                  selectedColor: const Color(0xFF4CAF50),
                  backgroundColor: const Color(0xFF4A5568),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Przedział wiekowy
            const Text(
              'Preferowany przedział wiekowy innych:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButton(
                    value: _minAge,
                    items: List.generate(60, (index) => (18 + index).toString())
                        .map((age) => DropdownMenuItem(
                      value: age,
                      child: Text(age, style: const TextStyle(color: Colors.white)),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _minAge = value.toString();
                      });
                    },
                    dropdownColor: const Color(0xFF2D3748),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Text(' - ', style: TextStyle(color: Colors.white)),
                Expanded(
                  child: DropdownButton(
                    value: _maxAge,
                    items: List.generate(60, (index) => (18 + index).toString())
                        .map((age) => DropdownMenuItem(
                      value: age,
                      child: Text(age, style: const TextStyle(color: Colors.white)),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _maxAge = value.toString();
                      });
                    },
                    dropdownColor: const Color(0xFF2D3748),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Zapisz
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainMapScreen()),
                        (route) => false,
                  );
                },
                child: const Text('Zapisz Profil i Przejdź do Mapy',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
