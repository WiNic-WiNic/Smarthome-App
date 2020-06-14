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

  double space =20;
  double schriftG=30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:  Container(
            color: Colors.blueAccent,
            padding:  EdgeInsets.all(20.0),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

            Expanded(
                  child: RaisedButton(
                    child: Text("Weather",
                      style: TextStyle(fontSize: schriftG),
                    ),
                    color: Colors.amberAccent,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> WeatherPage())
                      );
                    },
                  ),
                ),
              SizedBox(height: space,
              ),
              Expanded(

                  child: RaisedButton(
                    child: Text("Home",
                      style: TextStyle(fontSize: schriftG),
                    ),
                    color: Colors.deepOrangeAccent,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> HomePage())
                      );
                    },
                  ),
                ),
              SizedBox(height: space,
              ),
              Expanded(

                  child: RaisedButton(
                    child: Text("Group",
                      style: TextStyle(fontSize: schriftG),
                    ),
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
      );

  }
}
