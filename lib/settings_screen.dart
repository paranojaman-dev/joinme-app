import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D3748),
      appBar: AppBar(
        title: Text('Ustawienia', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Sekcja PROFIL
          _buildSectionHeader('Profil'),
          _buildSettingsItem(
            icon: Icons.person,
            title: 'Edytuj profil',
            subtitle: 'Zmień dane, zdjęcie, zainteresowania',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Edycja profilu wkrótce dostępna! 📝'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),

          // Sekcja KONTO
          _buildSectionHeader('Konto'),
          _buildSettingsItem(
            icon: Icons.workspace_premium,
            title: 'JoinMe Premium',
            subtitle: 'Usuń reklamy, więcej funkcji',
            onTap: () => _showPremiumDialog(context),
          ),
          _buildSettingsItem(
            icon: Icons.no_accounts,
            title: 'Usuń konto',
            subtitle: 'Trwale usuń konto i dane',
            onTap: () => _deleteAccount(context),
            color: Colors.red,
          ),

          // Sekcja APLIKACJA
          _buildSectionHeader('Aplikacja'),
          _buildSettingsItem(
            icon: Icons.info,
            title: 'O aplikacji',
            subtitle: 'Wersja 1.0.0 • JoinMe Social',
            onTap: () => _showAboutDialog(context),
          ),
          _buildSettingsItem(
            icon: Icons.privacy_tip,
            title: 'Polityka prywatności',
            onTap: () => _showPrivacyPolicy(context),
          ),
          _buildSettingsItem(
            icon: Icons.description,
            title: 'Regulamin',
            onTap: () => _showTerms(context),
          ),

          // Sekcja SYSTEM
          _buildSectionHeader('System'),
          _buildSettingsItem(
            icon: Icons.notifications,
            title: 'Powiadomienia',
            subtitle: 'Zarządzaj powiadomieniami',
            onTap: () => _notificationSettings(context),
          ),
          _buildSettingsItem(
            icon: Icons.map,
            title: 'Precyzja lokalizacji',
            subtitle: 'Ustaw dokładność GPS',
            onTap: () => _locationSettings(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required Function onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: Colors.white)),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: Colors.grey[400]))
          : null,
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () => onTap(),
    );
  }

  // FUNKCJE DLA POSZCZEGÓLNYCH OPCJI:

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2D3748),
          title: Text('JoinMe Premium 🚀',
              style: TextStyle(color: Colors.orange, fontSize: 20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.workspace_premium, size: 60, color: Colors.orange),
              SizedBox(height: 16),
              _buildPremiumFeature('🎯 Brak reklam'),
              _buildPremiumFeature('📊 Zaawansowane statystyki'),
              _buildPremiumFeature('🎨 Nielimitowane eventy'),
              _buildPremiumFeature('👑 Ekskluzywne funkcje'),
              _buildPremiumFeature('💬 Nieograniczone czaty'),
              SizedBox(height: 16),
              Text('Tylko 9,99 zł / miesięcznie',
                  style: TextStyle(color: Colors.green, fontSize: 16)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('PÓŹNIEJ', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Dziękujemy za zainteresowanie Premium! 🎉'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: Text('KUP PREMIUM'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPremiumFeature(String feature) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 16),
          SizedBox(width: 8),
          Text(feature, style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  void _deleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2D3748),
          title: Text('Usunięcie konta ⚠️', style: TextStyle(color: Colors.red)),
          content: Text(
            'Czy na pewno chcesz usunąć konto? Ta operacja jest nieodwracalna i spowoduje utratę wszystkich danych.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ANULUJ', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Funkcja usuwania konta wkrótce dostępna'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: Text('USUŃ KONTO'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2D3748),
          title: Text('O aplikacji ℹ️', style: TextStyle(color: Colors.orange)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('JoinMe - Aplikacja społecznościowa',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Wersja: 1.0.0', style: TextStyle(color: Colors.grey)),
                Text('MoonRoom', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 16),
                Text('Łącz ludzi, twórz eventy, poznawaj nowych znajomych!',
                    style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ZAMKNIJ', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2D3748),
          title: Text('Polityka prywatności 📄', style: TextStyle(color: Colors.orange)),
          content: SingleChildScrollView(
            child: Text(
              'Twoja prywatność jest dla nas ważna. JoinMe chroni Twoje dane i używa ich tylko do zapewnienia funkcjonalności aplikacji.\n\n'
                  '• Zbieramy tylko niezbędne dane\n'
                  '• Nie udostępniamy danych stronom trzecim\n'
                  '• Możesz usunąć swoje dane w każdej chwili\n'
                  '• Szyfrujemy wszystkie połączenia',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ROZUMIEM', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }

  void _showTerms(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2D3748),
          title: Text('Regulamin 📝', style: TextStyle(color: Colors.orange)),
          content: SingleChildScrollView(
            child: Text(
              'Korzystając z JoinMe akceptujesz nasz regulamin:\n\n'
                  '1. Szanuj innych użytkowników\n'
                  '2. Nie publikuj nieodpowiednich treści\n'
                  '3. Korzystaj z aplikacji zgodnie z prawem\n'
                  '4. Jesteś odpowiedzialny za swoje eventy\n'
                  '5. Zgłaszaj niewłaściwe zachowania',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('AKCEPTUJĘ', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }

  void _notificationSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ustawienia powiadomień wkrótce dostępne! 🔔'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _locationSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ustawienia lokalizacji wkrótce dostępne! 📍'),
        backgroundColor: Colors.green,
      ),
    );
  }
}