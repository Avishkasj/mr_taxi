import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Riderprofile extends StatefulWidget {
  const Riderprofile({Key? key}) : super(key: key);

  @override
  State<Riderprofile> createState() => _RiderprofileState();
}

class _RiderprofileState extends State<Riderprofile> {
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
        title: Text('Update Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [




            SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white30,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    // controller: customerEmailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'E-mail',
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
                    color: Colors.white30,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    // controller: customerMobileController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Mobile No',
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
                          color: Colors.grey,
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
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
