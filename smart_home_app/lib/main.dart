import 'package:flutter/material.dart';
import 'package:smarthomeapp/screens/group.dart';
import 'package:smarthomeapp/screens/weather.dart';
import 'screens/home.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Smart Home App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Align(
      alignment: Alignment.center,
          child: Container(
            padding:  EdgeInsets.all(20.0),
            //alignment: Alignment.center,
            color: Colors.blueAccent,
            //height: 200,
            //margin: EdgeInsets.only(top: 300.0),
            child: new Column(
            children: <Widget>[
            Container(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("Weather"),
                    color: Colors.amberAccent,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> WeatherPage())
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("Home"),
                    color: Colors.deepOrangeAccent,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> HomePage())
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("Group"),
                    color: Colors.deepPurpleAccent,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> GroupPage())
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
      ),
    );
  }
}
