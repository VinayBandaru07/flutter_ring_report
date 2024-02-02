import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ring_report/screens/ScrollableContactLogs.dart';

class RingReport extends StatefulWidget {
  const RingReport({super.key});

  @override
  State<RingReport> createState() => _RingReportState();
}

class _RingReportState extends State<RingReport> {
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: ScrollableContactLogs(contactLogs: entries),
      ),
    );
  }
}
