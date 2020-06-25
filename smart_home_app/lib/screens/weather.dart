import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../autoClassgenerator.dart';
import 'home.dart';
//import 'package:xml_parser/xml_parser.dart';
import 'package:xml/xml.dart' as xml;

class WeatherPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: (){ }
          ),
      appBar: AppBar(
        title: Text("Weather Page"),
      ),
      body: Column(
        children: <Widget>[
         Center(
           child: Row(
             mainAxisSize: MainAxisSize.min,
          children: <Widget>[
          Text("Actual Temperature right now: "),

            FutureBuilder(
              future: getTemperature(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                ConnectionState cs=snapshot.connectionState;
                if(cs==ConnectionState.active || cs==ConnectionState.waiting) {
                  return Container(
                    child: Text("Loading XML..."),
                  );
                }
                else{
                  return
                    Container(
                      child: Text(snapshot.data+"°"),
                    );
                }
              },
            ),
        ],
      )


         ),

                  FutureBuilder(
                    future: getWind(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      ConnectionState cs=snapshot.connectionState;
                      if(cs==ConnectionState.active || cs==ConnectionState.waiting) {
                        return Container(
                          child: Text("Loading XML..."),
                        );
                      }
                      else{
                        return
                          Container(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                  title: Text(snapshot.data[index]),
                                );
                            },
                          ),

                          );
                      }
                    },
                  ),

          FutureBuilder(
            future: getForecast(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              ConnectionState cs=snapshot.connectionState;
              if(cs==ConnectionState.active || cs==ConnectionState.waiting) {
                return Container(
                  child: Text("Loading XML..."),
                );
              }
              else{
                return
                  Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text("Forecast of Day "+index.toString()+": "+snapshot.data[index]+"°"),
                        );
                      },
                    ),

                  );
              }
            },
          ),


        ],
      ),
    );
  }

  Future<String> getTemperature() async {
    String xmlBody="""<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soap="http://soap">
   <soapenv:Header/>
   <soapenv:Body>
      <soap:getTemp/>
   </soapenv:Body>
</soapenv:Envelope>""";

    String url="https://azuresoap.azurewebsites.net/services/SoapMethods";

    final xmlResponse = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'text/xml; charset=UTF-8',
          'soapaction': url
        },
        body: xmlBody
    );
//getTempReturn
xml.XmlDocument document = xml.parse(xmlResponse.body);
    print(xmlResponse.body);

    String result = parseElement(document,"getTempReturn");

    return result;
  }

  Future<List<String>> getWind() async {
    String xmlBody="""<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soap="http://soap">
   <soapenv:Header/>
   <soapenv:Body>
      <soap:getWind/>
   </soapenv:Body>
</soapenv:Envelope>""";

    String url="https://azuresoap.azurewebsites.net/services/SoapMethods";

    final xmlResponse = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'text/xml; charset=UTF-8',
          'soapaction': url
        },
        body: xmlBody
    );
//getTempReturn
    xml.XmlDocument document = xml.parse(xmlResponse.body);
    print(xmlResponse.body);

    String result = parseElement(document,"getWindReturn");

       List<String> wind = result.split(",");


    return wind;
  }

  Future<List<String>> getForecast() async {
    String xmlBody="""<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soap="http://soap">
   <soapenv:Header/>
   <soapenv:Body>
      <soap:getForecast/>
   </soapenv:Body>
</soapenv:Envelope>""";

    String url="https://azuresoap.azurewebsites.net/services/SoapMethods";

    final xmlResponse = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'text/xml; charset=UTF-8',
          'soapaction': url
        },
        body: xmlBody
    );
//getTempReturn
    xml.XmlDocument document = xml.parse(xmlResponse.body);
    print(xmlResponse.body);

    String result = parseElement(document,"getForecastReturn");

    List<String> wind = result.split(",");


    return wind;
  }


  String parseElement(xml.XmlDocument doc,String stringer){
    var parsedElements = doc.findAllElements(stringer);
    String myString = parsedElements.map((node) => node.text).toString();
    return delBr(myString);
  }

  String delBr(String stringer){
   return stringer.substring(1,stringer.length-1);
  }
  
  



}
