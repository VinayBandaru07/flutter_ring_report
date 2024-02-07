import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ring_report/screens/ScrollableContactLogs.dart';
import 'package:ring_report/screens/search_screen.dart';
import 'package:toast/toast.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

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

class RingReport extends StatefulWidget {
  const RingReport({super.key});

  @override
  State<RingReport> createState() => _RingReportState();
}

class _RingReportState extends State<RingReport> {
  var entries;
  bool isSearched = false;
  bool isSorted = false;
  bool isPermanentlyDisabled = false;

  List searchedItems = [];

  List namesUnique = [];
  List numbersUnique = [];

  searchAndGetLog(String searchText, SearchType searchType) async {
    if (searchType == SearchType.Name) {
      entries = await CallLog.query(
        name: searchText,
      );
    } else {
      entries = await CallLog.query(
        number: searchText,
      );
    }
    setState(() {});
  }

  List<ListTile> getSearchSuggestionItems(SearchController controller) {
    List<ListTile> items = [];
    searchedItems = searchedItems.toSet().toList();
    for (var element in searchedItems) {
      items.add(ListTile(
        shape: Border.all(color: Colors.white),
        contentPadding: EdgeInsets.all(15),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            element.toString(),
            style: TextStyle(color: Colors.black87, fontSize: 20),
          ),
        ),
        onTap: () {
          if (element.isNotEmpty) {
            isSearched = true;
            searchAndGetLog(element, determineSearchType(element));
          }
          controller.closeView(element);
        },
        tileColor: Colors.blue[100],
      ));
    }
    return items;
  }

  sortWithDuration() {
    List<CallLogEntry> temp = entries.toList();
    temp.sort((b, a) => (a.duration)!.compareTo((b.duration!)));
    entries = temp;
    setState(() {});
  }

  sortWithTimeStampNew() {
    List<CallLogEntry> temp = entries.toList();
    print(temp.last.duration);
    temp.sort((b, a) => (a.timestamp)!.compareTo((b.timestamp!)));
    entries = temp;
    print(temp.last.duration);
    setState(() {});
  }

  sortWithTimeStampOld() {
    List<CallLogEntry> temp = entries.toList();
    print(temp.last.duration);
    temp.sort((a, b) => (a.timestamp)!.compareTo((b.timestamp!)));
    entries = temp;
    print(temp.last.duration);
    setState(() {});
  }

  void setToDefault() {
    getPermissionUser();
  }

  void getPermissionUser() async {
    var status = Permission.phone;
    if (await status.isGranted) {
      getLog();
    } else if (await status.isPermanentlyDenied) {
      isPermanentlyDisabled = true;
      Toast.show('Permissions Permanently Disabled',
          duration: 5, gravity: Toast.bottom);
      setState(() {});
    } else {
      await Permission.phone.request();
      getPermissionUser();
    }
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

  void makeSearchList() {
    entries.toList().asMap().forEach((ind, element) {
      if (element.name != null) {
        namesUnique.add(element.name);
      }
      numbersUnique.add(element.number);
    });
    namesUnique = namesUnique.toSet().toList();
    numbersUnique = numbersUnique.toSet().toList();
  }

  void getLog() async {
    entries = await CallLog.get();
    makeSearchList();
    setState(() {});
  }

  @override
  void initState() {
    getPermissionUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
        ),
        title: Text(
          'Ring Report',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // IconButton(
          //     color: Colors.white,
          //     onPressed: () async {
          //       try {
          //         SearchDetails result = await Navigator.push(context,
          //             MaterialPageRoute(builder: (context) {
          //           return SearchScreen(
          //             entries: entries,
          //           );
          //         }));
          //         if (result.searchText.isNotEmpty) {
          //           print(result.searchText);
          //           print(result.searchType);
          //           isSearched = true;
          //           searchAndGetLog(result.searchText, result.searchType);
          //         }
          //       } catch (e) {}
          //     },
          //     icon: Icon(
          //       Icons.search,
          //       size: 30,
          //     ))
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            isPermanentlyDisabled
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Text(
                          'Permissions diabled permanently, Kindly open App settings and allow permissions.'),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: ScrollableContactLogs(contactLogs: entries),
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SearchAnchor(
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
                      focusNode: AlwaysDisabledFocusNode(),
                      hintText: 'Search name or number',
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
            ),
          ],
        ),
      ),
      floatingActionButton: Wrap(
        //will break to another line on overflow
        direction: Axis.horizontal,
        crossAxisAlignment:
            WrapCrossAlignment.center, //use vertical to show  on vertical axis
        children: <Widget>[
          SpeedDial(
              icon: Icons.sort,
              iconTheme: IconThemeData(size: 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              backgroundColor: Colors.blue[200],
              children: [
                SpeedDialChild(
                  elevation: 0,
                  child: const Icon(Icons.timer, color: Colors.white),
                  label: 'Duration',
                  backgroundColor: Colors.blue[200],
                  onTap: () {
                    isSorted = true;
                    sortWithDuration();
                  },
                ),
                SpeedDialChild(
                  elevation: 0,
                  child: const Icon(FontAwesomeIcons.star, color: Colors.white),
                  label: 'Newest',
                  backgroundColor: Colors.blue[200],
                  onTap: () {
                    isSorted = true;
                    sortWithTimeStampNew();
                  },
                ),
                SpeedDialChild(
                  elevation: 0,
                  child:
                      const Icon(FontAwesomeIcons.clock, color: Colors.white),
                  label: 'Oldest',
                  backgroundColor: Colors.blue[200],
                  onTap: () {
                    isSorted = true;
                    sortWithTimeStampOld();
                  },
                ),
                SpeedDialChild(
                  elevation: 0,
                  visible: isSorted,
                  child: const Icon(Icons.clear, color: Colors.white),
                  label: 'Clear',
                  backgroundColor: Colors.redAccent,
                  onTap: () {
                    isSorted = false;
                    setToDefault();
                  },
                )
              ]), //button first

          Visibility(
            visible: isSearched,
            child: Container(
                margin: EdgeInsets.all(10),
                child: FloatingActionButton(
                  onPressed: () {
                    //action code for button 2
                    isSorted = false;
                    isSearched = false;
                    setToDefault();
                  },
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.search_off_sharp),
                )),
          ), // button second// button third

          // Add more buttons here
        ],
      ),
    );
  }
}
