import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;

  CustomTextFormField({required this.controller});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  var uuid = Uuid();
  String _sessionToken = '11223344';
  List<dynamic> _placesList = [];

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }

    getSuggestion(widget.controller.text);
  }

  void getSuggestion(String input) async {
    if (mounted) {
      String apiKey = "AIzaSyDV7MPDpFXHRrSqvqAEg2JHSTHby60Wnig";
      String baseURL =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      String components = "country:JP";
      String request =
          "$baseURL?input=$input&key=$apiKey&sessiontoken=$_sessionToken&components=$components";

      var response = await http.get(Uri.parse(request));
      var data = response.body.toString();


      print(data);

      if (mounted) {
        if (response.statusCode == 200) {
          setState(() {
            _placesList = jsonDecode(response.body.toString())['predictions'];
          });
        } else {
          throw Exception('Failed to load data');
        }
      }
    }
  }

  void onPredictionItemClick(String prediction) {
    FocusScope.of(context).unfocus();
    widget.controller.text = prediction;
    setState(() {
      _placesList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
  controller: widget.controller,
  decoration: InputDecoration(
    hintText: 'Search',
    hintStyle: TextStyle(color: Colors.grey), // Optional: Adjust hint text style
    labelStyle: TextStyle(color: Colors.white),
    border: InputBorder.none, // This removes the underline
    // If you have a filled TextField and want to define a color
    filled: true, // Optional: Set to true if you want a fill color
    fillColor: Colors.transparent, // Optional: Set fill color
  ),
),

        ListView.builder(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _placesList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_placesList[index]['description']),
              onTap: () {
                onPredictionItemClick(_placesList[index]['description']);
              },
            );
          },
        ),
      ],
    );
  }
}