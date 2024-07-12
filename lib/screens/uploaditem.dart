import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadItemScreen extends StatefulWidget {
  @override
  _UploadItemScreenState createState() => _UploadItemScreenState();
}

class _UploadItemScreenState extends State<UploadItemScreen> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemDescriptionController =
      TextEditingController();
  File? _selectedImage;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Item',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      child: Icon(Icons.camera_alt),
                    ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _itemNameController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _itemDescriptionController,
              decoration: InputDecoration(labelText: 'Item Description'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _uploadItemAutomatically(context);
              },
              child: Text('Upload Item'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadItemAutomatically(BuildContext context) async {
    if (_selectedImage == null) {
      // Show an error message, image is required
      return;
    }

    // Upload image to Firebase Storage
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('item_images/${DateTime.now().millisecondsSinceEpoch}.png');

    final UploadTask uploadTask = storageReference.putFile(_selectedImage!);
    await uploadTask.whenComplete(() {});

    // Get the uploaded image URL
    final String imageUrl = await storageReference.getDownloadURL();

    // Automatically upload item details to Firestore
    await FirebaseFirestore.instance.collection('items').add({
      'itemName': _itemNameController.text,
      'itemDescription': _itemDescriptionController.text,
      'imageUrl': imageUrl,
      // Add other fields as needed
    });

    // Navigate back to the ExchangeItemDetailScreen
    Navigator.pop(context);
  }
}
