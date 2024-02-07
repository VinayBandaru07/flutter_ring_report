import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ring_report/screens/ScrollableContactLogs.dart';
import 'package:ring_report/screens/search_screen.dart';

class RingReport extends StatefulWidget {
  const RingReport({super.key});

  @override
  State<RingReport> createState() => _RingReportState();
}

class _RingReportState extends State<RingReport> {
  var entries;
  bool isSearched = false;
  bool isSorted = false;

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
    } else {
      await Permission.phone.request();
      getPermissionUser();
    }
  }

  void getLog() async {
    entries = await CallLog.get();
    setState(() {});
  }

  @override
  void initState() {
    getPermissionUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Ring Report',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              color: Colors.white,
              onPressed: () async {
                try {
                  SearchDetails result = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return SearchScreen(
                      entries: entries,
                    );
                  }));
                  if (result.searchText.isNotEmpty) {
                    print(result.searchText);
                    print(result.searchType);
                    isSearched = true;
                    searchAndGetLog(result.searchText, result.searchType);
                  }
                } catch (e) {}
              },
              icon: Icon(
                Icons.search,
                size: 30,
              ))
        ],
      ),
      body: SafeArea(
        child: ScrollableContactLogs(contactLogs: entries),
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
                  child: const Icon(Icons.timer, color: Colors.white),
                  label: 'Duration',
                  backgroundColor: Colors.blueAccent,
                  onTap: () {
                    isSorted = true;
                    sortWithDuration();
                  },
                ),
                SpeedDialChild(
                  child: const Icon(FontAwesomeIcons.star, color: Colors.white),
                  label: 'Newest',
                  backgroundColor: Colors.blueAccent,
                  onTap: () {
                    isSorted = true;
                    sortWithTimeStampNew();
                  },
                ),
                SpeedDialChild(
                  child:
                      const Icon(FontAwesomeIcons.clock, color: Colors.white),
                  label: 'Oldest',
                  backgroundColor: Colors.blueAccent,
                  onTap: () {
                    isSorted = true;
                    sortWithTimeStampOld();
                  },
                ),
                SpeedDialChild(
                  visible: isSorted,
                  child: const Icon(Icons.clear, color: Colors.white),
                  label: 'Clear',
                  backgroundColor: Colors.blueAccent,
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
                  backgroundColor: Colors.deepPurpleAccent,
                  child: Icon(Icons.search_off_sharp),
                )),
          ), // button second// button third

          // Add more buttons here
        ],
      ),
    );
  }
}
