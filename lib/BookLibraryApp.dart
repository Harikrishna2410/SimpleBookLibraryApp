import 'package:flutter/material.dart';

import 'BookSearchPage.dart';

class BookLibraryApp extends StatefulWidget {
  const BookLibraryApp({super.key});

  @override
  State<BookLibraryApp> createState() => _BookLibraryAppState();
}

class _BookLibraryAppState extends State<BookLibraryApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Book Library App',
      home: BookSearchPage(),
    );
  }
}
