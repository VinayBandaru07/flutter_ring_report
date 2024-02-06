import 'package:flutter/material.dart';

// Create a class to hold search details
class SearchDetails {
  final String searchText;
  final SearchType searchType;

  SearchDetails({required this.searchText, required this.searchType});
}

enum SearchType {
  Name,
  PhoneNumber,
}

SearchType determineSearchType(String searchQuery) {
  // Check if the search query is a valid phone number
  bool isPhoneNumber(String input) {
    final RegExp phoneNumberRegex = RegExp(
        r'^\+?(\d{1,4})?[-.\s]?\(?(?:\d{1,4})?\)?[-.\s]?\d{1,6}[-.\s]?\d{1,6}[-.\s]?\d{1,9}$');
    return phoneNumberRegex.hasMatch(input);
  }

  // Remove leading and trailing whitespaces
  final cleanedQuery = searchQuery.trim();

  // Check if the search query is a valid phone number
  if (isPhoneNumber(cleanedQuery)) {
    return SearchType.PhoneNumber;
  }

  // If not a valid phone number, consider it as a name search
  return SearchType.Name;
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Initial values for the radio buttons and search text
  TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Call Log'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search text field
            TextField(
              controller: searchTextController,
              decoration: InputDecoration(labelText: 'Search name or phone'),
            ),
            SizedBox(height: 16.0),
            // Search button
            ElevatedButton(
              onPressed: () {
                // Perform search logic and pass the result back to the home screen
                String searchText = searchTextController.text;
                SearchDetails searchDetails = SearchDetails(
                    searchText: searchText,
                    searchType: determineSearchType(searchText));
                Navigator.pop(context, searchDetails);
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
