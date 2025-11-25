import 'package:flutter/material.dart';
import 'main.dart';

class ChatsScreen extends StatelessWidget {
  final User? user;

  ChatsScreen({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A202C), // NOWY: Ciemne tło
      appBar: AppBar(
        title: Text(user != null ? 'Czat z ${user!.name}' : 'Twoje rozmowy'),
        backgroundColor: Color(0xFF2D3748), // NOWY: Grafitowy
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFF1A202C), // Ciemne tło
        child: user != null ? _buildChatScreen() : _buildChatsList(),
      ),
    );
  }

  Widget _buildChatScreen() {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Color(0xFF1A202C), // Ciemne tło czatu
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildMessage('Cześć! Chcesz porozmawiać?', true),
                _buildMessage('Hej! Jasne, o czym chcesz pogadać?', false),
                _buildMessage('Widzę, że interesują Cię technologie!', true),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF2D3748), // Grafitowe tło inputa
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Napisz wiadomość...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color(0xFF4A5568), // Ciemniejsze tło inputa
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: Color(0xFF4CAF50),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatsList() {
    return Container(
      color: Color(0xFF1A202C), // Ciemne tło listy
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildChatItem('Anna', 'Ostatnia wiadomość...', '2 min temu', 1),
          _buildChatItem('Michał', 'Super się rozmawiało!', '1 godz. temu', 0),
          _buildChatItem('Kasia', 'Do zobaczenia!', '2 godz. temu', 2),
        ],
      ),
    );
  }

  Widget _buildChatItem(String name, String lastMessage, String time, int unread) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Color(0xFF2D3748), // Grafitowe tło itemu
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(0xFF4A5568),
          child: Icon(Icons.person, color: Colors.grey[400]),
        ),
        title: Text(name,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text(lastMessage, style: TextStyle(color: Colors.grey[400])),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            if (unread > 0)
              Container(
                margin: EdgeInsets.only(top: 4),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unread.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
          ],
        ),
        onTap: () {
          // Przejdź do konkretnego czatu
        },
      ),
    );
  }

  Widget _buildMessage(String text, bool isMe) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? Color(0xFF4CAF50) : Color(0xFF4A5568), // Grafitowe dla innych
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}