import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'welcome_screen.dart';
import 'profile_screen.dart';
import 'filters_screen.dart';
import 'chats_screen.dart';
import 'create_event_screen.dart';

void main() {
  runApp(JoinMeApp());
}

class JoinMeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JoinMe',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomeScreen(),
    );
  }
}

class MainMapScreen extends StatefulWidget {
  @override
  _MainMapScreenState createState() => _MainMapScreenState();
}

class _MainMapScreenState extends State<MainMapScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  bool isActive = true;
  String statusColor = 'green';
  bool showFriendsList = false;
  LatLng? _currentLocation;
  bool _isLoadingLocation = false;

  // Dane użytkownika
  String userName = "Maciej";
  String userInterest = "Technologie, Podróże";

  // Przykładowi użytkownicy na mapie
  final List<User> nearbyUsers = [
    User('Anna', 29, 'green', LatLng(52.2297, 21.0122), 'Podróże', 'anna.jpg', true),
    User('Michał', 32, 'red', LatLng(52.2298, 21.0130), 'Technologie', 'michal.jpg', false),
    User('Kasia', 27, 'green', LatLng(52.2300, 21.0115), 'Książki', 'kasia.jpg', true),
  ];

  // Lista znajomych
  final List<User> friends = [
    User('Anna', 29, 'green', LatLng(52.2297, 21.0122), 'Podróże', 'anna.jpg', true),
    User('Michał', 32, 'red', LatLng(52.2298, 21.0130), 'Technologie', 'michal.jpg', false),
    User('Kasia', 27, 'green', LatLng(52.2300, 21.0115), 'Książki', 'kasia.jpg', true),
    User('Tomek', 31, 'red', LatLng(52.2310, 21.0140), 'Sport', 'tomek.jpg', false),
    User('Ola', 26, 'green', LatLng(52.2280, 21.0100), 'Sztuka', 'ola.jpg', true),
  ];

  // Lista aktywnych eventów
  List<Event> _activeEvents = [];

  int unreadMessages = 3;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadMarkers();
  }

  // PRAWDZIWA FUNKCJA GPS
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Sprawdź uprawnienia
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationError('Usługa lokalizacji jest wyłączona. Włącz GPS.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationError('Brak uprawnień do lokalizacji');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationError('Uprawnienia do lokalizacji są trwale zablokowane. Włącz w ustawieniach.');
        return;
      }

      // Pobierz aktualną lokalizację
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });

      // Przesuń kamerę do aktualnej lokalizacji
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_currentLocation!, 15),
        );
      }

      // Przeładuj markery z nową lokalizacją
      _loadMarkers();

      print('🎯 Aktualna lokalizacja: ${position.latitude}, ${position.longitude}');

      // Pokazujemy sukces
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lokalizacja pobrana! Jesteś widoczny na mapie. 🗺️'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

    } catch (e) {
      print('❌ Błąd GPS: $e');
      _showLocationError('Nie udało się pobrać lokalizacji: $e');
      setState(() {
        _isLoadingLocation = false;
        // Ustaw domyślną lokalizację na Warszawę jeśli GPS nie działa
        _currentLocation = LatLng(52.2297, 21.0122);
      });
    }
  }

  void _showLocationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _showCreateEventSheet() async {
    final newEvent = await showModalBottomSheet<Event>(
      context: context,
      backgroundColor: Color(0xFF2D3748),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => CreateEventScreen(),
    );

    // Jeśli utworzono event, dodaj go do listy
    if (newEvent != null) {
      _addNewEvent(newEvent);
    }
  }

  void _setMapStyle(GoogleMapController controller) {
    controller.setMapStyle('''
      [
        {"elementType": "geometry", "stylers": [{"color": "#242f3e"}]},
        {"elementType": "labels.text.fill", "stylers": [{"color": "#746855"}]},
        {"elementType": "labels.text.stroke", "stylers": [{"color": "#242f3e"}]},
        {"featureType": "administrative.locality", "elementType": "labels.text.fill", "stylers": [{"color": "#d59563"}]},
        {"featureType": "poi", "elementType": "labels.text.fill", "stylers": [{"color": "#d59563"}]},
        {"featureType": "poi.park", "elementType": "geometry", "stylers": [{"color": "#263c3f"}]},
        {"featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [{"color": "#6b9a76"}]},
        {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#38414e"}]},
        {"featureType": "road", "elementType": "geometry.stroke", "stylers": [{"color": "#212a37"}]},
        {"featureType": "road", "elementType": "labels.text.fill", "stylers": [{"color": "#9ca5b3"}]},
        {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#746855"}]},
        {"featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [{"color": "#1f2835"}]},
        {"featureType": "road.highway", "elementType": "labels.text.fill", "stylers": [{"color": "#f3d19c"}]},
        {"featureType": "transit", "elementType": "geometry", "stylers": [{"color": "#2f3948"}]},
        {"featureType": "transit.station", "elementType": "labels.text.fill", "stylers": [{"color": "#d59563"}]},
        {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#17263c"}]},
        {"featureType": "water", "elementType": "labels.text.fill", "stylers": [{"color": "#515c6d"}]},
        {"featureType": "water", "elementType": "labels.text.stroke", "stylers": [{"color": "#17263c"}]}
      ]
    ''');
  }

  void _loadMarkers() {
    markers.clear();

    // Dodaj marker aktualnej lokalizacji użytkownika (jeśli GPS działa)
    if (_currentLocation != null) {
      markers.add(
        Marker(
          markerId: MarkerId('my_location'),
          position: _currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: 'Twoja lokalizacja 🎯',
            snippet: 'Jesteś tutaj! Kliknij przycisk GPS aby odświeżyć',
          ),
        ),
      );
    }

    // DODAJ MARKERY EVENTÓW
    for (var event in _activeEvents) {
      if (event.isActive) {
        markers.add(
          Marker(
            markerId: MarkerId('event_${event.id}'),
            position: event.location,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            infoWindow: InfoWindow(
              title: '${event.emoji} ${event.activity}',
              snippet: '${event.currentPeople}/${event.maxPeople} osób • ${event.time} • ${event.topic ?? "Brak tematu"}',
            ),
            onTap: () => _showEventDetails(event),
          ),
        );
      }
    }

    // Dodaj markery innych użytkowników
    for (var user in nearbyUsers) {
      if (user.isActive) {
        markers.add(
          Marker(
            markerId: MarkerId(user.name),
            position: user.location,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              _getColorHue(user.statusColor),
            ),
            infoWindow: InfoWindow(
              title: '${user.name} (${user.age})',
              snippet: user.conversationTopic ?? 'Otwarty na rozmowę',
            ),
            onTap: () => _showUserProfile(user),
          ),
        );
      }
    }
    setState(() {});
  }

  void _showEventDetails(Event event) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF2D3748),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emoji i nazwa eventu
            Text(
              '${event.emoji} ${event.activity}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),

            // Informacje o evencie
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, color: Colors.orange, size: 16),
                SizedBox(width: 6),
                Text(
                  '${event.currentPeople}/${event.maxPeople} osób',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(width: 20),
                Icon(Icons.access_time, color: Colors.orange, size: 16),
                SizedBox(width: 6),
                Text(
                  event.time,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Temat
            if (event.topic != null && event.topic!.isNotEmpty)
              Text(
                'Temat: ${event.topic}',
                style: TextStyle(color: Colors.blue[300], fontSize: 16),
                textAlign: TextAlign.center,
              ),

            SizedBox(height: 15),
            Text(
              'Stworzone przez: ${event.creatorName}',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            SizedBox(height: 20),

            // Przyciski akcji
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _joinEvent(event);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.group_add),
                  label: Text('Dołącz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Zamknij', style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey),
                  ),
                ),
              ],
            ),

            // Jeśli to mój event, pokaż przycisk zakończenia
            if (event.creatorName == userName) ...[
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  _endEvent(event);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.stop),
                label: Text('Zakończ Event'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _joinEvent(Event event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dołączyłeś do eventu "${event.activity}"! 🎉'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _endEvent(Event event) {
    setState(() {
      _activeEvents.removeWhere((e) => e.id == event.id);
    });

    _loadMarkers();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Event "${event.activity}" został zakończony'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _addNewEvent(Event newEvent) {
    setState(() {
      _activeEvents.add(newEvent);
    });

    _loadMarkers();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Event "${newEvent.activity}" utworzony! Widoczny na mapie 🗺️'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _showUserProfile(User user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF2D3748),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
            ),
            SizedBox(height: 15),
            Text('${user.name} (${user.age})',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: user.isActive ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  user.isActive ? 'Aktywny - dostępny' : 'Offline - niedostępny',
                  style: TextStyle(
                    color: user.isActive ? Colors.green : Colors.red,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Temat: ${user.conversationTopic}',
                style: TextStyle(fontSize: 16, color: Colors.blue[300])),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (user.isActive)
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _startChat(user);
                    },
                    icon: Icon(Icons.chat),
                    label: Text('Rozpocznij czat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(user.isActive ? 'Zamknij' : 'Niedostępny',
                      style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startChat(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatsScreen(user: user)),
    );
  }

  void _toggleActiveStatus() {
    setState(() {
      isActive = !isActive;
      statusColor = isActive ? 'green' : 'red';
    });
  }

  void _toggleFriendsList() {
    setState(() {
      showFriendsList = !showFriendsList;
    });
  }

  void _zoomToFriend(User friend) {
    if (friend.isActive) {
      mapController?.animateCamera(
        CameraUpdate.newLatLng(friend.location),
      );
    }
  }

  double _getColorHue(String color) {
    switch (color) {
      case 'green': return BitmapDescriptor.hueGreen;
      case 'yellow': return BitmapDescriptor.hueYellow;
      case 'red': return BitmapDescriptor.hueRed;
      default: return BitmapDescriptor.hueGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mapa
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
              _setMapStyle(controller);

              if (_currentLocation != null) {
                controller.animateCamera(
                  CameraUpdate.newLatLngZoom(_currentLocation!, 15),
                );
              }
            },
            initialCameraPosition: CameraPosition(
              target: _currentLocation ?? LatLng(52.2297, 21.0122),
              zoom: 15,
            ),
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),

          // GÓRNA NAKŁADKA - Logo i status
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFF2D3748),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Logo
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF1B5E20),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.map_outlined, size: 30, color: Color(0xFF4CAF50)),
                        Positioned(
                          bottom: 8,
                          child: Icon(Icons.chair, size: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),

                  // Status aktywności
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isActive ? 'Szukam ludzi do rozmowy' : 'Niewidoczny',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: isActive ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              isActive ? 'Aktywny' : 'Offline',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Ikona tworzenia eventu
                  IconButton(
                    onPressed: _showCreateEventSheet,
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.orange,
                      size: 30,
                    ),
                    tooltip: 'Stwórz event',
                  ),

                  // Przycisk zmiany statusu
                  IconButton(
                    onPressed: _toggleActiveStatus,
                    icon: Icon(
                      isActive ? Icons.visibility : Icons.visibility_off,
                      color: isActive ? Colors.green : Colors.red,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // PRZYCISK AKTUALIZACJI LOKALIZACJI GPS
          Positioned(
            top: 90,
            right: 16,
            child: FloatingActionButton(
              onPressed: _isLoadingLocation ? null : _getCurrentLocation,
              backgroundColor: Color(0xFF4CAF50),
              child: _isLoadingLocation
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              )
                  : Icon(Icons.gps_fixed, color: Colors.white),
              mini: true,
              tooltip: 'Aktualizuj moją lokalizację GPS',
            ),
          ),

          // DOLNA NAKŁADKA - Profil i znajomi
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: showFriendsList ? 180 : 100,
              decoration: BoxDecoration(
                color: Color(0xFF2D3748).withOpacity(0.95),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Górny pasek - mój profil i ikony
                  Container(
                    height: 80,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        // Mój profil
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfileScreen()),
                              );
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey[300],
                                  child: Icon(Icons.person, size: 25, color: Colors.grey[600]),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        userName,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        userInterest,
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Ikona znajomych
                        IconButton(
                          onPressed: _toggleFriendsList,
                          icon: Icon(
                            showFriendsList ? Icons.arrow_drop_down : Icons.people,
                            color: showFriendsList ? Colors.green : Colors.purple[300],
                            size: 30,
                          ),
                          tooltip: 'Znajomi',
                        ),

                        // Ikona ustawień widoczności
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FiltersScreen()),
                            );
                          },
                          icon: Icon(Icons.visibility, color: Colors.blue[300]),
                          tooltip: 'Kto może mnie zobaczyć',
                        ),

                        // Ikona czatów z licznikiem
                        Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ChatsScreen()),
                                );
                              },
                              icon: Icon(Icons.chat, color: Colors.orange[300]),
                              tooltip: 'Rozpoczęte czaty',
                            ),
                            if (unreadMessages > 0)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    unreadMessages.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Lista znajomych
                  if (showFriendsList)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: friends.map((friend) {
                            return GestureDetector(
                              onTap: () => _zoomToFriend(friend),
                              child: Container(
                                width: 80,
                                margin: EdgeInsets.only(right: 12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.grey[300],
                                          child: Icon(Icons.person, size: 25, color: Colors.grey[600]),
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                              color: friend.isActive ? Colors.green : Colors.red,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Color(0xFF2D3748), width: 2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      friend.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      friend.isActive ? 'Dostępny' : 'Offline',
                                      style: TextStyle(
                                        color: friend.isActive ? Colors.green : Colors.red,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class User {
  final String name;
  final int age;
  final String statusColor;
  final LatLng location;
  final String? conversationTopic;
  final String? avatar;
  final bool isActive;

  User(this.name, this.age, this.statusColor, this.location,
      this.conversationTopic, this.avatar, this.isActive);
}

// NOWA KLASA EVENT
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