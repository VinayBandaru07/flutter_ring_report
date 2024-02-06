import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ring_report/screens/contact_details.dart';

class ContactLogHistory extends StatefulWidget {
  ContactLogHistory({
    super.key,
    required this.contactLogs,
  });
  final Iterable<CallLogEntry> contactLogs;
  @override
  State<ContactLogHistory> createState() => _CitizenHospitalDayBookingsState();
}

class _CitizenHospitalDayBookingsState extends State<ContactLogHistory> {
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
    double iconSize = 40.0;
    Color iconColor = Colors.green;
    for (final (index, element) in widget.contactLogs.indexed) {
      DateTime logTime =
          DateTime.fromMillisecondsSinceEpoch(element.timestamp as int);
      tempList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Material(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            // fit: BoxFit.cover,
            // width: 120,
            // height: 94,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 13,
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: switch (element.callType) {
                            // TODO: Handle this case.
                            null => null,
                            // TODO: Handle this case.
                            CallType.incoming => Icon(
                                Icons.call_received,
                                size: iconSize,
                                color: iconColor,
                              ),
                            // TODO: Handle this case.
                            CallType.outgoing => Icon(
                                Icons.call_made,
                                size: iconSize,
                                color: iconColor,
                              ),
                            // TODO: Handle this case.
                            CallType.missed => Icon(
                                Icons.call_missed,
                                size: iconSize,
                                color: Colors.yellowAccent,
                              ),
                            // TODO: Handle this case.
                            CallType.voiceMail => Icon(
                                Icons.voicemail,
                                size: iconSize,
                                color: Colors.green,
                              ),
                            // TODO: Handle this case.
                            CallType.rejected => Icon(
                                Icons.call_end,
                                size: iconSize,
                                color: Colors.red,
                              ),
                            // TODO: Handle this case.
                            CallType.blocked => Icon(
                                Icons.block,
                                size: iconSize,
                                color: Colors.red,
                              ),
                            // TODO: Handle this case.
                            CallType.answeredExternally => null,
                            // TODO: Handle this case.
                            CallType.unknown => Icon(
                                Icons.question_mark,
                                size: iconSize,
                                color: Colors.blue,
                              ),
                            // TODO: Handle this case.
                            CallType.wifiIncoming => Icon(
                                Icons.wifi_calling,
                                size: iconSize,
                                color: iconColor,
                              ),
                            // TODO: Handle this case.
                            CallType.wifiOutgoing => Icon(
                                Icons.wifi_calling,
                                size: iconSize,
                                color: iconColor,
                              ),
                          },
                        ),
                      ],
                    ),
                    // margin: EdgeInsets.all(5),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        logTime.day.toString() +
                            '/' +
                            logTime.month.toString() +
                            '/' +
                            logTime.year.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gowun Batang',
                            fontSize: 25),
                      ),
                      Text(
                          logTime.hour.toString() +
                              ':' +
                              logTime.minute.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Gowun Batang',
                              fontSize: 15)),
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
      ));
    }
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
