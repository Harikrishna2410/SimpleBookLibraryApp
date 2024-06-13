import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookSearchPage extends StatefulWidget {
  const BookSearchPage({super.key});

  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  final _textEditingController = TextEditingController();
  String _error = '';
  List<dynamic> _books = [];

  void _searchBook() async {
    String _query = _textEditingController.text;
    if (_query.isEmpty) {
      setState(() {
        _error = 'Please enter book name of author name';
      });
      return;
    }

    final url = 'https://openlibrary.org/search.json?q=$_query?top=10';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _books = data['docs'];
          print("data fetched "+data);
          if (_books.isEmpty) {
            _error = 'No Books';
          } else {
            _error = '';
          }
        });
      } else {
        setState(() {
          _error = 'Error fetching data.';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Book Library App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                    labelText: 'Enter book title or author'),
                onSubmitted: (value) => _searchBook(),
              ),
              ElevatedButton(onPressed: _searchBook, child: const Text('Search')),
              _error.isNotEmpty
                  ? Text(_error)
                  : Expanded(
                child: ListView.builder(
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    final title = book['title'] ?? 'No title';
                    final author = book['author_name'] != null
                        ? (book['author_name'] as List<dynamic>).join(', ')
                        : 'No author';
                    final coverId = book['cover_i'];
                    final coverUrl = coverId != null
                        ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
                        : null;

                    return ListTile(
                      leading: coverUrl != null
                          ? Image.network(coverUrl, width: 50, fit: BoxFit.cover)
                          : null,
                      title: Text(title),
                      subtitle: Text(author),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
