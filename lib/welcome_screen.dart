import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'filters_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A202C),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // NOWE LOGO - mapa z krzesłem
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Color(0xFF2D3748),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Mapa w tle
                    Icon(
                      Icons.map_outlined,
                      size: 80,
                      color: Color(0xFF4CAF50),
                    ),
                    // Krzesło na mapie
                    Positioned(
                      bottom: 20,
                      child: Icon(
                        Icons.chair,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text(
                'JoinMe',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Znajdź towarzystwo w Twojej okolicy',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFA0AEC0),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),

              // Przyciski akcji - NOWE KOLORY
              Column(
                children: [
                  // Przycisk rejestracji
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileScreen()),
                        );
                      },
                      child: Text(
                        'Zacznijmy!',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Przycisk "Kto może mnie znaleźć"
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FiltersScreen()),
                        );
                      },
                      child: Text(
                        'Kto może mnie znaleźć?',
                        style: TextStyle(fontSize: 18, color: Color(0xFF4CAF50)),
                      ),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        side: BorderSide(color: Color(0xFF4CAF50), width: 2),
                        backgroundColor: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Informacje o aplikacji
              Text(
                'Bezpieczne spotkania • Rzeczywiste osoby • Spontaniczne rozmowy',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}