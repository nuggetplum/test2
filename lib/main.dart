import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<Album> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'userId': int userId, 'id': int id, 'title': String title} => Album(
          userId: userId,
          id: id,
          title: title,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 183, 108, 58),
        ),
      ),
      home: const MyHomePage(title: 'Personal Sports App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    //futureAlbum = fetchAlbum();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.sports_basketball), text: 'nba'),
            Tab(icon: Icon(Icons.sports_soccer), text: 'UEFA'),
            Tab(icon: Icon(Icons.sports_soccer), text: 'Premier League'),
            Tab(icon: Icon(Icons.sports_cricket), text: 'Cricket'),
            Tab(icon: Icon(Icons.api), text: 'API'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [NbaPage(), UefaPage(), PlPage(), CricketPage(), APIpage()],
      ),
    );
  }
}

class NbaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BigCard(),
          SizedBox(height: 20),
          BigCard(),
          SizedBox(height: 20),
          BigCard(),
        ],
      ),
    );
  }
}

class UefaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('UEFA Content'));
  }
}

class PlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Premier League Content'));
  }
}

class CricketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Cricket Content'));
  }
}

class APIpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Album>(
      future: fetchAlbum(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class BigCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [Text("team1 vs team2"), Text("score: 100-200")],
        ),
      ),
    );
  }
}
