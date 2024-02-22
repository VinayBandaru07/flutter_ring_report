import 'package:call_log/call_log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ring_report/screens/contact_info.dart';
import 'package:ring_report/screens/contact_log_history.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetails extends StatefulWidget {
  const ContactDetails(
      {super.key, required this.heroIndex, required this.contactData});
  final String heroIndex;
  final CallLogEntry contactData;
  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  Iterable<CallLogEntry> entries = [];
  int totalDuration = 0;
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
    entries = await CallLog.query(
      durationFrom: 0,
      durationTo: 60,
      // name: 'John Doe',
      number: widget.contactData.number,
      // type: CallType.incoming,
    );
    entries.toList().asMap().forEach((ind, element) {
      print(element.duration as int);
      totalDuration = totalDuration + (element.duration as int);
    });
    print(totalDuration);
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
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              pinned: false,
              snap: false,
              floating: true,
              onStretchTrigger: () async {
                // Triggers when stretching
              },

              // [stretchTriggerOffset] describes the amount of overscroll that must occur
              // to trigger [onStretchTrigger]
              //
              // Setting [stretchTriggerOffset] to a value of 300.0 will trigger
              // [onStretchTrigger] when the user has overscrolled by 300.0 pixels.
              stretchTriggerOffset: 300.0,
              expandedHeight: 280.0,

              flexibleSpace: FlexibleSpaceBar(
                // title: Row(
                //   mainAxisSize: MainAxisSize.max,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     FittedBox(
                //       child: widget.contactData.name != null
                //           ? Text(
                //               widget.contactData.name.toString(),
                //               style:
                //                   TextStyle(fontSize: 20, color: Colors.white),
                //             )
                //           : Text(
                //               widget.contactData.number.toString(),
                //               style:
                //                   TextStyle(fontSize: 25, color: Colors.white),
                //             ),
                //     ),
                //   ],
                // ),
                background: Hero(
                    tag: widget.heroIndex,
                    child: Material(
                      type: MaterialType.transparency,
                      child: widget.contactData.name != null
                          ? Center(
                              child: Text(
                              widget.contactData.name.toString()[0],
                              style: TextStyle(
                                  fontSize: 180,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w300),
                            ))
                          : Image.asset(
                              'assets/images/dp.png',
                              fit: kIsWeb ? BoxFit.cover : BoxFit.fill,
                              // fit: BoxFit.fitWidth,
                            ),
                    )),
              ),
            ),
            SliverFillRemaining(
              child: DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: Scaffold(
                  appBar: TabBar(
                    labelColor: Colors.blue,
                    indicatorColor: Colors.blue,
                    tabs: <Widget>[
                      Tab(
                        icon: Icon(
                          Icons.info_outline,
                        ),
                        text: 'Info',
                      ),
                      Tab(
                        icon: Icon(Icons.event_seat_outlined),
                        text: 'Call Log',
                      ),
                    ],
                  ),
                  body: TabBarView(
                    children: <Widget>[
                      //List of widgets
                      ContactInfo(
                        contactData: widget.contactData,
                        totalCallDuration: totalDuration,
                      ),
                      ContactLogHistory(contactLogs: entries)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[100],
        onPressed: () async {
          Uri sms = Uri.parse('tel://${widget.contactData.number}');
          if (await launchUrl(sms)) {
            //app opened
          } else {
            //app is not opened
          }
        },
        child: const Icon(Icons.dialpad),
      ),
    );
  }
}
