import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactInfo extends StatefulWidget {
  const ContactInfo(
      {super.key, required this.contactData, required this.totalCallDuration});
  final CallLogEntry contactData;
  final int totalCallDuration;
  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  bool showDistance = false;
  double distance = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setOpinion();
  }

  String opinion = '';

  setOpinion() async {
    final prefs = await SharedPreferences.getInstance();
    var nums = await prefs.getStringList('previouslySavedNumbers');
    var opinions = await prefs.getStringList('previouslySavedSelections');
    print(nums);
    nums?.asMap().forEach((ind, element) {
      if (element == widget.contactData.number) {
        opinion = opinions![ind].substring(8);
      }
    });
    setState(() {});
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedTime = '';

    if (hours > 0) {
      formattedTime += '${hours.toString().padLeft(2, '0')} hrs : ';
    }

    if (minutes > 0 || hours > 0) {
      formattedTime += '${minutes.toString().padLeft(2, '0')} mins : ';
    }

    formattedTime += '${remainingSeconds.toString().padLeft(2, '0')} seconds';

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    var contactData = widget.contactData;
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    contactData.name != null
                        ? ListTile(
                            leading: const Icon(Icons.person_2),
                            title: Text(
                              contactData.name.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
//               subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                          )
                        : SizedBox(),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(contactData.number.toString()),
//               subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                    ),
                    ListTile(
                      leading: const Icon(FontAwesomeIcons.clock),
                      title: Text(DateTime.fromMillisecondsSinceEpoch(
                              contactData.timestamp as int)
                          .toString()),
//               subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                    ),
                    ListTile(
                      leading: const Icon(FontAwesomeIcons.stopwatch),
                      title: Text(contactData.duration.toString() + ' Seconds'),
//               subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                    ),
                    ListTile(
                      leading: const Icon(FontAwesomeIcons.arrowRight),
                      title: Text(
                          'Call Type: ${contactData.callType.toString().substring(9)}'),
//               subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                    ),
                    opinion != ''
                        ? ListTile(
                            leading: const Icon(
                              FontAwesomeIcons.stopwatch,
                              color: Colors.green,
                            ),
                            title: Row(
                              children: [
                                Text(
                                    'Total Duration: ${formatTime(widget.totalCallDuration)} ')
                              ],
                            ),
//               subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                          )
                        : Text(''),
                    ListTile(
                      leading: const Icon(Icons.menu),
                      title: Text(opinion),
//               subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                    )
                  ],
                ),
                color: Colors.blue[100],
              ),

              // Text('Gender' + hospitalData?['gender']),
            ],
          ),
        ),
      ],
    );
  }
}
