import 'package:call_log/call_log.dart';
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
  final Iterable<CallLogEntry> entries;

  const SearchScreen({super.key, required this.entries});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Initial values for the radio buttons and search text
  TextEditingController searchTextController = TextEditingController();

  List searchedItems = [];

  List namesUnique = [];
  List numbersUnique = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.entries.toList().asMap().forEach((ind, element) {
      if (element.name != null) {
        namesUnique.add(element.name);
      }
      numbersUnique.add(element.number);
    });
    namesUnique = namesUnique.toSet().toList();
    numbersUnique = numbersUnique.toSet().toList();
  }

  void filterSearchLog(SearchDetails searchDetails) {
    searchedItems.clear();
    if (searchDetails.searchType == SearchType.Name) {
      namesUnique.forEach((element) {
        if (element
            .toLowerCase()
            .contains(searchDetails.searchText.toLowerCase())) {
          searchedItems.add(element);
        }
      });
    } else {
      numbersUnique.asMap().forEach((ind, element) {
        if (element.contains(searchDetails.searchText.toLowerCase())) {
          searchedItems.add(element);
        }
      });
    }

    setState(() {});
  }

  List<ListTile> getSearchSuggestionItems(SearchController controller) {
    List<ListTile> items = [];
    searchedItems = searchedItems.toSet().toList();
    for (var element in searchedItems) {
      items.add(ListTile(
        title: Text(element.toString()),
        onTap: () {
          controller.closeView(element);
        },
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${namesUnique.length.toString()} + ${numbersUnique.length.toString()}'),
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
            SearchAnchor(
                isFullScreen: true,
                builder: (BuildContext context, SearchController controller) {
                  controller.addListener(() {
                    String searchText = controller.text;
                    SearchDetails searchDetails = SearchDetails(
                        searchText: searchText,
                        searchType: determineSearchType(searchText));
                    filterSearchLog(searchDetails);
                  });
                  return SearchBar(
                    controller: controller,
                    padding: const MaterialStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0)),
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_) {
                      controller.openView();
                    },
                    leading: const Icon(Icons.search),
                  );
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                  return getSearchSuggestionItems(controller);
                }),
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
