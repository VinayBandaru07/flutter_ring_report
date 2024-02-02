import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScrollableContactLogs extends StatefulWidget {
  ScrollableContactLogs({
    super.key,
    required this.contactLogs,
  });
  final Iterable<CallLogEntry> contactLogs;
  @override
  State<ScrollableContactLogs> createState() =>
      _CitizenHospitalDayBookingsState();
}

class _CitizenHospitalDayBookingsState extends State<ScrollableContactLogs> {
  List<Icon> getDayProfileIcons(String day) {
    List<IconData> icons = [
      FontAwesomeIcons.zero,
      FontAwesomeIcons.one,
      FontAwesomeIcons.two,
      FontAwesomeIcons.three,
      FontAwesomeIcons.four,
      FontAwesomeIcons.five,
      FontAwesomeIcons.six,
      FontAwesomeIcons.seven,
      FontAwesomeIcons.eight,
      FontAwesomeIcons.nine,
    ];
    List<Icon> iconsList = [];
    if (day.length == 1) {
      iconsList.add(Icon(icons[0]));
      iconsList.add(Icon(icons[int.parse(day)]));
    } else {
      iconsList.add(Icon(icons[int.parse(day.toString()[0])]));
      iconsList.add(Icon(icons[int.parse(day.toString()[1])]));
    }
    return iconsList;
  }

  List<Widget> makeListItems() {
    List<Widget> tempList = [];
    widget.contactLogs.forEach((element) {
      tempList.add(Padding(
        padding: const EdgeInsets.all(10),
        child: Material(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
          child: GestureDetector(
            onTap: () {},
            child: FittedBox(
              fit: BoxFit.cover,
              // width: 120,
              // height: 94,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 80.5,
                            height: 79.5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50)),
                            child: element.name != null
                                ? Center(
                                    child: Text(element.name.toString()[0]))
                                : Image.network(
                                    'https://i.ibb.co/VCsCNp2/blank-profile-picture-973460-640.png',
                                    // fit: BoxFit.fitWidth,
                                  ),
                          ),
                        ],
                      ),
                      // margin: EdgeInsets.all(5),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          element.name != null
                              ? element.name.toString()
                              : element.number.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          element.timestamp.toString(),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                        Text('HMM'),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  )
                ],
              ),
            ),
          ),
        ),
      ));
    });
    return tempList;
  }

  Widget noResultsWidget = const Center(
    child: Text(
      'Bookings not opened',
      style: TextStyle(
        fontSize: 30,
      ),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    makeListItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: makeListItems(),
    );
  }
}
