import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Barcamp Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        centerTitle: true,
      ),
      body: new FutureBuilder(
          future: http.get('https://reqres.in/api/users?per_page=12'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> dataResponse = json.decode(snapshot.data.body);
              return Container(
                child: ListView(
                  children: dataResponse['data'].map<Widget>((el) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ImageViewer(url: el['avatar'], tag: el['avatar'].toString(),)),
                          );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Hero(
                                    tag: el['avatar'].toString(),
                                    child: Image.network(
                                      el['avatar'],
                                      fit: BoxFit.cover,
                                    )),
                                Text(
                                  "${el['first_name']} ${el['last_name']}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }
}

class ImageViewer extends StatelessWidget {
  ImageViewer({@required this.url, @required this.tag});

  final url;
  final tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Visor de imagen'),
      ),
      body: Container(
        child: Center(
            child: Hero(
                tag: tag,
                child: Image.network(
                  url,
                ))),
      ),
    );
  }
}
