import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactInfo extends StatefulWidget {
  const ContactInfo({super.key, required this.contactData});
  final CallLogEntry contactData;
  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  bool showDistance = false;
  double distance = 0.0;

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
                      title: Text(contactData.callType.toString()),
//               subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                    ),
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
