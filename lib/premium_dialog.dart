import 'package:flutter/material.dart';
import 'package:flutter/material.dart';


class PremiumDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFF2D3748),
      title: Text('JoinMe Premium', style: TextStyle(color: Colors.orange)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium, size: 60, color: Colors.orange),
          SizedBox(height: 16),
          Text('Odblokuj pełnię możliwości!',
              style: TextStyle(color: Colors.white)),
          SizedBox(height: 16),
          _buildFeature('🎯 Brak reklam'),
          _buildFeature('📊 Zaawansowane statystyki'),
          _buildFeature('🎨 Nielimitowane eventy'),
          _buildFeature('👑 Ekskluzywne funkcje'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('PÓŹNIEJ', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () => _buyPremium(context),
          child: Text('KUP PREMIUM 9,99 zł'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        ),
      ],
    );
  }

  Widget _buildFeature(String feature) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check, color: Colors.green, size: 16),
          SizedBox(width: 8),
          Text(feature, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  void _buyPremium(BuildContext context) {
    // TODO: Integracja z płatnościami
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Funkcja premium wkrótce dostępna! 🎉')),
    );
  }
}