import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/post.dart';

void main() {
  runApp(const MyApp());
}

//Get Api Request
Future<Post> fetchPost() async {
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/1');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

//Post Api Request
Future<Post> createPost(String title, String body) async {
  Map<String, dynamic> request = {
    'title': title,
    'body': body,
    'userId': '111',
  };
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final response = await http.post(uri, body: request);

  if (response.statusCode == 201) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

//Update Api Request
Future<Post> updatePost(String title, String body) async {
  Map<String, dynamic> request = {
    'id': '101',
    'title': title,
    'body': body,
    'userId': '111',
  };
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
  final response = await http.put(uri, body: request);

  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

//Delete Api Request

Future<Post?>? deletePost() async {
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
  final response = await http.delete(uri);

  if (response.statusCode == 200) {
    return null;
  } else {
    throw Exception('Failed to load post');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'http package',
    theme: ThemeData(primarySwatch: Colors.amber, primaryColor: Colors.blue),
    home: const HomeWidget(),
  );
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  Future<Post?>? post;

  void clickGetButton() {
    setState(() {
      post = fetchPost();
    });
  }

  void clickDeleteButton() {
    setState(() {
      post = deletePost();
    });
  }

  void clickPostButton() {
    setState(() {
      post = createPost('Top Post', 'This is the example post');
    });
  }

  void clickUpdateButton() {
    setState(() {
      post = updatePost('Updated Post', 'New updated example post');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Center(child: Text('http package'))),
      body: SizedBox(
        height: 500,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FutureBuilder<Post?>(
              future: post,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Container();
                } else {
                  if (snapshot.hasData) {
                    return buildDataWidget(context, snapshot);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return Container();
                  }
                }
              },
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () => clickGetButton(),
                child: Text('GET'),
              ),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () => clickPostButton(),
                child: Text('POST'),
              ),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () => clickUpdateButton(),
                child: Text('UPDATE'),
              ),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () => clickDeleteButton(),
                child: Text('DELETE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildDataWidget(context, snapshot) => Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Padding(padding: EdgeInsets.all(15), child: Text(snapshot.data.title)),
    Padding(padding: EdgeInsets.all(8), child: Text(snapshot.data.description)),
  ],
);
