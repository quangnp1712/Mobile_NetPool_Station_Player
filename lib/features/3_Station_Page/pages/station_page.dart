import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/features/3_Station_Page/widgets/list_station.dart';
import 'package:mobile_netpool_station_player/features/3_Station_Page/widgets/liststation_appbar.dart'; 

class StationPage extends StatefulWidget {
  final Function callback;

  const StationPage(this.callback, {super.key});

  @override
  State<StationPage> createState() => _StationPageState();
}

class _StationPageState extends State<StationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: const ListStationAppbar(), // dùng AppBar riêng
      body: const ListStation(), // gọi ListStation ở đây
    );
  }
}
