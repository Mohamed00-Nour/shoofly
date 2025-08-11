import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = '';
  String _userLocation = 'Finding your location...';
  bool _isLoadingLocation = false;
  List<Map<String, dynamic>> _recentRequests = [];
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _getCurrentLocation();
    _loadRecentRequests();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _userName = prefs.getString('userName') ?? 'User';
      });
    }
  }

  _getCurrentLocation() async {
    if (_isDisposed || !mounted) return;
    
    if (mounted && !_isDisposed) {
      setState(() {
        _isLoadingLocation = true;
      });
    }

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (_isDisposed || !mounted) return;
      
      if (!serviceEnabled) {
        if (mounted && !_isDisposed) {
          setState(() {
            _userLocation = 'Location services are disabled';
            _isLoadingLocation = false;
          });
        }
        return;
      }

      // Check and request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (_isDisposed || !mounted) return;
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (_isDisposed || !mounted) return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted && !_isDisposed) {
          setState(() {
            _userLocation = 'Location access permanently denied';
            _isLoadingLocation = false;
          });
        }
        return;
      }

      if (permission == LocationPermission.denied) {
        if (mounted && !_isDisposed) {
          setState(() {
            _userLocation = 'Location permission denied';
            _isLoadingLocation = false;
          });
        }
        return;
      }

      // Get current position with timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      if (_isDisposed || !mounted) return;

      // Get address from coordinates using reverse geocoding
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, 
          position.longitude
        );
        
        if (_isDisposed || !mounted) return;
        
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String address = '';
          
          // Build a readable address
          if (place.street != null && place.street!.isNotEmpty) {
            address += place.street!;
          }
          if (place.subLocality != null && place.subLocality!.isNotEmpty) {
            if (address.isNotEmpty) address += ', ';
            address += place.subLocality!;
          }
          if (place.locality != null && place.locality!.isNotEmpty) {
            if (address.isNotEmpty) address += ', ';
            address += place.locality!;
          }
          if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
            if (address.isNotEmpty) address += ', ';
            address += place.administrativeArea!;
          }
          if (place.country != null && place.country!.isNotEmpty) {
            if (address.isNotEmpty) address += ', ';
            address += place.country!;
          }
          
          if (mounted && !_isDisposed) {
            setState(() {
              _userLocation = address.isNotEmpty ? address : 'Location found';
              _isLoadingLocation = false;
            });
          }
        } else {
          // Fallback to coordinates if no placemark found
          if (mounted && !_isDisposed) {
            setState(() {
              _userLocation = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
              _isLoadingLocation = false;
            });
          }
        }
      } catch (geocodeError) {
        // Fallback to coordinates if geocoding fails
        if (mounted && !_isDisposed) {
          setState(() {
            _userLocation = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
            _isLoadingLocation = false;
          });
        }
      }
    } catch (e) {
      if (_isDisposed || !mounted) return;
      
      if (mounted && !_isDisposed) {
        setState(() {
          _userLocation = 'Unable to get location. Please check settings.';
          _isLoadingLocation = false;
        });
      }
      
      // Optionally show a snackbar with the error
      if (mounted && !_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location error: ${e.toString()}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _getCurrentLocation,
            ),
          ),
        );
      }
    }
  }

  _loadRecentRequests() {
    if (!mounted) return;
    
    // Simulate loading recent requests
    setState(() {
      _recentRequests = [
        {
          'id': '1',
          'partName': 'Brake Pads',
          'status': 'Completed',
          'date': '2024-08-05',
          'store': 'AutoParts Plus',
        },
        {
          'id': '2',
          'partName': 'Oil Filter',
          'status': 'In Progress',
          'date': '2024-08-04',
          'store': 'Pending',
        },
        {
          'id': '3',
          'partName': 'Headlight Bulb',
          'status': 'Completed',
          'date': '2024-08-03',
          'store': 'Car Care Center',
        },
      ];
    });
  }

  Future<void> _refreshData() async {
    if (!mounted) return;
    await _getCurrentLocation();
    if (mounted) {
      _loadRecentRequests();
    }
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2196F3),
              Color(0xFF1976D2),
            ],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.welcomeBack,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            _userName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/profile');
                            },
                            icon: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          IconButton(
                            onPressed: _logout,
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Location Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.currentLocation, // 🌍 LOCALIZED: Shows "Current Location" in English, "الموقع الحالي" in Arabic
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2196F3),
                              ),
                            ),
                            IconButton(
                              onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                              icon: _isLoadingLocation
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF2196F3),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.refresh,
                                      color: Color(0xFF2196F3),
                                    ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFFFF9800),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _userLocation,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      height: 1.4,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (_userLocation.contains('denied') || _userLocation.contains('disabled') || _userLocation.contains('Unable'))
                                    const SizedBox(height: 8),
                                  if (_userLocation.contains('denied') || _userLocation.contains('disabled') || _userLocation.contains('Unable'))
                                    TextButton(
                                      onPressed: () {
                                        if (mounted) {
                                          setState(() {
                                            _userLocation = 'New York, NY, United States';
                                          });
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        minimumSize: const Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text(
                                        'Use Default Location',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF2196F3),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Main Action Button
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF9800), Color(0xFFFF6F00)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF9800).withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.pushNamed(context, '/camera');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      l10n.findSpareParts, // 🌍 LOCALIZED: "Find Spare Parts" → "البحث عن قطع الغيار"
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      l10n.takePhotoOfPart, // 🌍 LOCALIZED: "Take a photo..." → "التقط صورة للقطعة..."
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Recent Requests
                  Text(
                    l10n.recentRequests, // 🌍 LOCALIZED: "Recent Requests" → "الطلبات الأخيرة"
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ..._recentRequests.map((request) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: request['status'] == 'Completed'
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                request['status'] == 'Completed'
                                    ? Icons.check_circle
                                    : Icons.access_time,
                                color: request['status'] == 'Completed'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request['partName'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Store: ${request['store']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    request['date'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: request['status'] == 'Completed'
                                    ? Colors.green
                                    : Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                request['status'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 20), // Add spacing at the bottom
                ],
              ),
            ),
          ),
        ),
      ),
      
    );
  }
}
