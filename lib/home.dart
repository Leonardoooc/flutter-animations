// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

const List<String> cities = <String>['Guarapuava', 'Prudentópolis', 'São Paulo'];

const requestG = "https://api.openweathermap.org/data/2.5/weather?lat=-25.407561&lon=-51.468791&appid=f17047134f597370f8f6d018a0a6715b";
const requestP = "https://api.openweathermap.org/data/2.5/weather?lat=-25.211840&lon=-50.977508&appid=f17047134f597370f8f6d018a0a6715b";
const requestS = "https://api.openweathermap.org/data/2.5/weather?lat=-23.563477&lon=-46.639659&appid=f17047134f597370f8f6d018a0a6715b";

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  bool _enabled = true;
  String tempguarapuava = "0";
  String tempprude = "0";
  String tempsp = "0";

  void getData() async {
    http.Response respostaG = await http.get(Uri.parse(requestG));
    var data = await json.decode(respostaG.body);
    double tempguarapuava_ = (data['main']['temp']?.toDouble() - 273.15); 
    tempguarapuava = "${tempguarapuava_.toStringAsFixed(0)}°C";

    http.Response respostaP = await http.get(Uri.parse(requestP));
    var dataP = await json.decode(respostaP.body);
    double tempprude_ = (dataP['main']['temp']?.toDouble() - 273.15); 
    tempprude = "${tempprude_.toStringAsFixed(0)}°C";

    http.Response respostaS = await http.get(Uri.parse(requestS));
    var dataS = await json.decode(respostaS.body);
    double tempsp_ = (dataS['main']['temp']?.toDouble() - 273.15); 
    tempsp = "${tempsp_.toStringAsFixed(0)}°C";

    setState(() {
      _enabled = !_enabled;
    });

  }

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animations'),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        items: <Widget>[
          Icon(Icons.sunny, size: 30, color: Colors.blueAccent, ),
          Icon(Icons.cloud, size: 30, color: Colors.blueAccent),
          Icon(Icons.snowing, size: 30, color: Colors.blueAccent),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        color: Colors.grey.shade800,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeInCubic,
        letIndexChange: (index) => true,
      ),
      
      body: Skeletonizer(
        enabled: _enabled,
        child: ListView(
          children: [
            Card(
              child: ListTile(
                title: Text("Guarapuava"),
                subtitle: Text(tempguarapuava),
                trailing: const Icon(
                  Icons.sunny, color: Colors.orange,
                  size: 32,
                ),
              ),
            ),
            
            
            Card(
              child: ListTile(
                title: Text("Prudentópolis"),
                subtitle: Text(tempprude),
                trailing: const Icon(
                  Icons.sunny, color: Colors.orange,
                  size: 32,
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("São Paulo"),
                subtitle: Text(tempsp),
                trailing: const Icon(
                  Icons.sunny, color: Colors.orange,
                  size: 32,
                ),
              ),
            ),
            ElevatedButton(
              child: Text('Ir para página 1'),
              onPressed: () {
                final CurvedNavigationBarState? navBarState =
                    _bottomNavigationKey.currentState;
                navBarState?.setPage(0);
              },
            ),
            ElevatedButton(
              child: Text('Ir para página 2'),
              onPressed: () {
                final CurvedNavigationBarState? navBarState =
                    _bottomNavigationKey.currentState;
                navBarState?.setPage(1);
              },
            ),
            ElevatedButton(
              child: Text('Ir para página 3'),
              onPressed: () {
                final CurvedNavigationBarState? navBarState =
                    _bottomNavigationKey.currentState;
                navBarState?.setPage(2);
              },
            ),

            Center(
              child: Text("Página atual: ${(_page + 1).toString()}", textScaleFactor: 1.5),
            )
          ],
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}