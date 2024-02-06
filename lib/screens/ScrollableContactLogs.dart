import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ring_report/screens/contact_details.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class ScrollableContactLogs extends StatefulWidget {
  ScrollableContactLogs({
    super.key,
    required this.contactLogs,
  });
  final contactLogs;
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

  double iconSize = 25.0;
  Color iconColor = Colors.green;
  List<Widget> makeListItems() {
    List<Widget> tempList = [];
    widget.contactLogs?.toList().asMap().forEach((index, element) {
      DateTime logTime = DateTime.fromMillisecondsSinceEpoch(element.timestamp);
      tempList.add(GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ContactDetails(
                heroIndex: '${index}contactLog', contactData: element);
          }));
        },
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Material(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
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
                          Hero(
                            tag: '${index}contactLog',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Container(
                                width: 80.5,
                                height: 79.5,
                                decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(50)),
                                child: element.name != null
                                    ? Center(
                                        child: Text(
                                        element.name.toString()[0],
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ))
                                    : Image.network(
                                        'https://i.ibb.co/VCsCNp2/blank-profile-picture-973460-640.png',
                                        // fit: BoxFit.fitWidth,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // margin: EdgeInsets.all(5),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    // width: 155,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          element.name != null
                              ? element.name.toString()
                              : element.number.toString(),
                          style: const TextStyle(
                              fontFamily: 'Gowun Batang',
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        SizedBox(
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
                            // TODO: Handle this case.
                            Object() => null,
                          },
                        ),
                        Text(
                          logTime.hour.toString() +
                              ':' +
                              logTime.minute.toString() +
                              ', ' +
                              logTime.day.toString() +
                              '/' +
                              logTime.month.toString() +
                              '/' +
                              logTime.year.toString(),
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Gowun Batang'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () async {
                              Uri sms = Uri.parse('sms:${element.number}');
                              if (await launchUrl(sms)) {
                                //app opened
                              } else {
                                //app is not opened
                              }
                            },
                            color: Colors.white54,
                            icon: Icon(Icons.message)),
                        IconButton(
                            onPressed: () async {
                              await FlutterPhoneDirectCaller.callNumber(
                                  element.number);
                            },
                            color: Colors.white54,
                            icon: Icon(Icons.call))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    });
    return tempList;
  }

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
