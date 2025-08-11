import 'package:flutter/material.dart';

class StoreSelectionScreen extends StatefulWidget {
  const StoreSelectionScreen({super.key});

  @override
  State<StoreSelectionScreen> createState() => _StoreSelectionScreenState();
}

class _StoreSelectionScreenState extends State<StoreSelectionScreen> {
  List<Map<String, dynamic>> _stores = [];
  String? _selectedStoreId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadStores();
  }

  _loadStores() {
    // Simulate loading stores from API
    setState(() {
      _stores = [
        {
          'id': '1',
          'name': 'AutoParts Plus',
          'rating': 4.8,
          'distance': '2.3 km',
          'price': 85,
          'deliveryTime': '2-3 hours',
          'image': 'https://via.placeholder.com/60',
          'verified': true,
          'inStock': true,
        },
        {
          'id': '2',
          'name': 'Car Care Center',
          'rating': 4.6,
          'distance': '4.1 km',
          'price': 78,
          'deliveryTime': '1-2 hours',
          'image': 'https://via.placeholder.com/60',
          'verified': true,
          'inStock': true,
        },
        {
          'id': '3',
          'name': 'Speedy Auto Parts',
          'rating': 4.4,
          'distance': '6.7 km',
          'price': 92,
          'deliveryTime': '3-4 hours',
          'image': 'https://via.placeholder.com/60',
          'verified': false,
          'inStock': true,
        },
      ];
    });
  }

  _selectStore() {
    if (_selectedStoreId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a store'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final selectedStore = _stores.firstWhere((store) => store['id'] == _selectedStoreId);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Selection'),
          content: Text(
            'Do you want to order from ${selectedStore['name']} for \$${selectedStore['price']}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processOrder(selectedStore);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  _processOrder(Map<String, dynamic> store) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('Order Placed!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your order has been placed with ${store['name']}.'),
              const SizedBox(height: 10),
              Text('Estimated delivery: ${store['deliveryTime']}'),
              const SizedBox(height: 10),
              Text('Total: \$${store['price']}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Store'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
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
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.store,
                      size: 50,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Choose Your Store',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_stores.length} stores have your part in stock',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // Stores List
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Available Stores',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      Expanded(
                        child: ListView.builder(
                          itemCount: _stores.length,
                          itemBuilder: (context, index) {
                            final store = _stores[index];
                            final isSelected = _selectedStoreId == store['id'];
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF2196F3)
                                      : Colors.grey[300]!,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                color: isSelected
                                    ? const Color(0xFF2196F3).withOpacity(0.1)
                                    : Colors.white,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: () {
                                    setState(() {
                                      _selectedStoreId = store['id'];
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            // Store Image
                                            Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF2196F3).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Icon(
                                                Icons.store,
                                                color: Color(0xFF2196F3),
                                                size: 30,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            
                                            // Store Info
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          store['name'],
                                                          style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      if (store['verified'])
                                                        const Icon(
                                                          Icons.verified,
                                                          color: Colors.blue,
                                                          size: 20,
                                                        ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                        size: 16,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        store['rating'].toString(),
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 15),
                                                      const Icon(
                                                        Icons.location_on,
                                                        color: Colors.grey,
                                                        size: 16,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        store['distance'],
                                                        style: TextStyle(
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            
                                            // Price
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '\$${store['price']}',
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFFFF9800),
                                                  ),
                                                ),
                                                Text(
                                                  store['deliveryTime'],
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        
                                        if (store['inStock'])
                                          Container(
                                            margin: const EdgeInsets.only(top: 10),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 16,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  'In Stock',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Select Button
              Container(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedStoreId != null ? _selectStore : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9800),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('ORDER FROM SELECTED STORE'),
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
