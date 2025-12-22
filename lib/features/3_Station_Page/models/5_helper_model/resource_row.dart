import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/4_resource/resoucre_model.dart';

class ResourceRow {
  final String rowId;
  final String label;
  final List<StationResourceModel> resources;

  ResourceRow(this.rowId, this.label, this.resources);
}
