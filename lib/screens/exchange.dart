import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/screens/uploaditem.dart';

class ExchangeItemDetailScreen extends StatefulWidget {
  @override
  _ExchangeItemDetailScreenState createState() =>
      _ExchangeItemDetailScreenState();
}

class _ExchangeItemDetailScreenState extends State<ExchangeItemDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCity = '';
  String _selectedProductType = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TRADE HUB"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _openFilterOptions(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildItemGrid(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by item name...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search logic
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemGrid() {
    return Expanded(
      child: StreamBuilder(
        stream: _getFilteredItems(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              return _buildItemCard(snapshot.data!.docs[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildItemCard(QueryDocumentSnapshot<Map<String, dynamic>> item) {
    // Ensure that the 'imageUrl' field is present in the document
    final imageUrl = item['imageUrl'] as String?;

    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Placeholder(
                    fallbackHeight: 100, fallbackWidth: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['itemName'] as String),
                SizedBox(height: 4),
                Text(item['itemDescription'] as String),
                SizedBox(height: 4),
                Text("Interested in: ${item['InterestedItem']}"),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _sendRequest(item['uploaderId'] as String);
            },
            child: Text("Request"),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getFilteredItems() {
    Query query = FirebaseFirestore.instance.collection('items');

    if (_selectedCity.isNotEmpty) {
      query = query.where('city', isEqualTo: _selectedCity);
    }
    if (_selectedProductType.isNotEmpty) {
      query = query.where('productType', isEqualTo: _selectedProductType);
    }

    if (_searchController.text.isNotEmpty) {
      query = query.where('itemName',
          isGreaterThanOrEqualTo: _searchController.text); // Updated field name
    }

    return query.snapshots().cast(); // Explicitly cast to the correct type
  }

  void _openFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Options'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Filter by City:"),
              DropdownButton<String>(
                value: _selectedCity,
                items: [
                  "City 1",
                  "City 2",
                  "City 3"
                ] // Replace with your city list
                    .map((city) => DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              Text("Filter by Product Type:"),
              DropdownButton<String>(
                value: _selectedProductType,
                items: [
                  "Type 1",
                  "Type 2",
                  "Type 3"
                ] // Replace with your product type list
                    .map((productType) => DropdownMenuItem<String>(
                          value: productType,
                          child: Text(productType),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProductType = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Apply Filters'),
            ),
          ],
        );
      },
    );
  }

  void _sendRequest(String uploaderId) {
    // Implement sending request functionality
    // You can use Firebase Cloud Messaging or another notification system
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'User Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Upload Item',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          // Handle User Profile tap
        } else if (index == 1) {
          _navigateToUploadItem();
        } else if (index == 2) {
          Navigator.pop(context);
        }
      },
    );
  }

  void _navigateToUploadItem() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UploadItemScreen()),
    );
  }
}
