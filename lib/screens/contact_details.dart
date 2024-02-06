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
      body: CustomScrollView(
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
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: FittedBox(
                child: widget.contactData.name != null
                    ? Text(
                        widget.contactData.name.toString()[0],
                        style: TextStyle(fontSize: 40),
                      )
                    : Text(
                        widget.contactData.number.toString(),
                        style: TextStyle(fontSize: 25),
                      ),
              ),
              background: Hero(
                  tag: widget.heroIndex,
                  child: widget.contactData.name != null
                      ? Center(
                          child: Text(
                          widget.contactData.name.toString()[0],
                          style: TextStyle(fontSize: 40),
                        ))
                      : Image.network(
                          'https://i.ibb.co/VCsCNp2/blank-profile-picture-973460-640.png',
                          fit: kIsWeb ? BoxFit.cover : BoxFit.fill,
                          // fit: BoxFit.fitWidth,
                        )),
            ),
          ),
          SliverFillRemaining(
            child: DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: Scaffold(
                appBar: TabBar(
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.info_outline),
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
                    ContactInfo(contactData: widget.contactData),
                    ContactLogHistory(contactLogs: entries)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
