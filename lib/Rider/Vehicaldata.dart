import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class Vehicaldata extends StatefulWidget {
  const Vehicaldata({Key? key}) : super(key: key);

  @override
  State<Vehicaldata> createState() => _VehicaldataState();
}

class _VehicaldataState extends State<Vehicaldata> {
  TextEditingController _vehicleModelController = TextEditingController();
  TextEditingController _vehicleBrandController = TextEditingController();
  TextEditingController _chargesPerKmController = TextEditingController();
  TextEditingController _aboutVehicleController = TextEditingController();
  List<File?> _imageFiles = [null, null, null];

  Future<void> _selectAndPreviewImage(int index) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFiles[index] = File(pickedFile.path);
      });
    }
  }

  void _updateProfile() async {
    String vehicleModel = _vehicleModelController.text;
    String vehicleBrand = _vehicleBrandController.text;
    String chargesPerKm = _chargesPerKmController.text;
    String aboutVehicle = _aboutVehicleController.text;
    FirebaseAuth _auth = FirebaseAuth.instance;

    if (vehicleModel.isNotEmpty &&
        vehicleBrand.isNotEmpty &&
        vehicleBrand.isNotEmpty &&
        aboutVehicle.isNotEmpty &&
        vehicleBrand.isNotEmpty)  {



      // Replace 'your_collection_name' with the actual name of the collection in Firestore
      CollectionReference vehicleCollection = FirebaseFirestore.instance
          .collection('vehicle');
      User? user = _auth.currentUser;
      String? uid = user?.uid;

      try {
        await vehicleCollection.add({
          'vehicleModel': vehicleModel,
          'vehicleBrand': vehicleBrand,
          'chargesPerKm': chargesPerKm,
          'aboutVehicle': aboutVehicle,
          'userId': uid,
          // Replace with the actual user ID
          // You can also add image URLs if you upload the images to a storage service
        });

        // Clear the text fields and image files after saving
        _vehicleModelController.clear();
        _vehicleBrandController.clear();
        _chargesPerKmController.clear();
        _aboutVehicleController.clear();
        setState(() {
          _imageFiles = [null, null, null];
        });

        // Show a success message or navigate to another screen if needed
        // e.g., ScaffoldMessenger.of(context).showSnackBar(...)
      } catch (e) {
        // Handle any errors that occur during saving
        print('Error: $e');
      }
    }
    else{
      showDialog(
          context: context,
          builder: (BuildContext context)
      {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Please fill all the fields.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Vehicle Data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Background color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      controller: _vehicleModelController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Vehicle Model',
                        hintStyle: TextStyle(color: Colors.grey),
                        icon: Icon(Icons.directions_car, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),



              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Background color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                       controller: _vehicleBrandController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Vehicle Brand',
                        hintStyle: TextStyle(color: Colors.grey),
                        icon: Icon(Icons.branding_watermark, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Background color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                       controller: _chargesPerKmController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Charges Per KM',
                        hintStyle: TextStyle(color: Colors.grey),
                        icon: Icon(Icons.price_change, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Background color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                       controller:  _aboutVehicleController,
                      maxLines: 4, // Adjust the number of visible lines
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'About Vehicle',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),


              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < _imageFiles.length; i++)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => _selectAndPreviewImage(i),
                          child: Container(
                            height: 100,
                            color: Colors.grey[200],
                            child: Center(
                              child: _imageFiles[i] != null
                                  ? Image.file(
                                _imageFiles[i]!,
                                fit: BoxFit.cover,
                              )
                                  : Text('Image $i'),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Change the color as needed
                ),
                onPressed: _updateProfile,
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}