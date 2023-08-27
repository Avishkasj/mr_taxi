import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Vehicaldata extends StatefulWidget {
  const Vehicaldata({Key? key}) : super(key: key);

  @override
  State<Vehicaldata> createState() => _VehicaldataState();
}

class _VehicaldataState extends State<Vehicaldata> {
  TextEditingController _nameController = TextEditingController();
  List<File?> _imageFiles = [null, null, null];

  Future<void> _selectAndPreviewImage(int index) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFiles[index] = File(pickedFile.path);
      });
    }
  }

  void _updateProfile() {
    String newName = _nameController.text;
    List<File?> newImageFiles = List.from(_imageFiles);
    // Update the user profile using newName and newImageFiles
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(254, 206, 12, 1.0),
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
                      // controller: customerEmailController,
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
                      // controller: customerEmailController,
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
                      // controller: customerEmailController,
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
                      // controller: textController,
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
                onPressed: _updateProfile,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
