// --- 1. Stations ---
import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/1_station/station_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/3_space/space_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/3_space/station_space_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/4_area/area_list_model.dart';
import 'package:mobile_netpool_station_player/features/Common/data/city_controller/city_model.dart';

final List<ProvinceModel> kProvinces = [
  ProvinceModel(code: 79, name: 'TP. Hồ Chí Minh'),
  ProvinceModel(code: 1, name: 'Hà Nội'),
];

final Map<int, List<DistrictModel>> kDistrictsMock = {
  79: [
    DistrictModel(code: 760, name: 'Quận 1'),
    DistrictModel(code: 764, name: 'Q. Gò Vấp'),
    DistrictModel(code: 778, name: 'Quận 7'),
    DistrictModel(code: 770, name: 'Quận 3'),
  ],
  1: [
    DistrictModel(code: 5, name: 'Cầu Giấy'),
    DistrictModel(code: 2, name: 'Hoàn Kiếm'),
  ]
};

// Updated Stations (No space info initially)
final List<StationDetailModel> kStations = [
  StationDetailModel(
      stationId: 1,
      stationName: 'Way Station - Gò Vấp',
      address: '483 Thống Nhất, P.16',
      distance: 1.2,
      rating: 4.8,
      statusCode: 'ACTIVE'),
  StationDetailModel(
      stationId: 2,
      stationName: 'Gaming Center Q7',
      address: '123 Nguyễn Thị Thập',
      distance: 5.4,
      rating: 4.5,
      statusCode: 'ACTIVE'),
  StationDetailModel(
      stationId: 3,
      stationName: 'CyberCore Q3',
      address: '55 Võ Văn Tần',
      distance: 3.1,
      rating: 4.9,
      statusCode: 'ACTIVE'),
];

// Mock API Response for Spaces (Called separately by Station ID)
List<StationSpaceModel> getMockSpacesForStation(int stationId) {
  // Demo logic: Trả về các space khác nhau tùy station ID
  if (stationId == 1) {
    // Way Station: Net + PS
    return [
      StationSpaceModel(
          stationSpaceId: 101,
          spaceCode: 'NET',
          spaceName: 'NET (PC)',
          metadata: SpaceMetaDataModel(icon: 'desktop_windows')),
      StationSpaceModel(
          stationSpaceId: 102,
          spaceCode: 'PS',
          spaceName: 'PlayStation',
          metadata: SpaceMetaDataModel(icon: 'videogame_asset')),
    ];
  } else if (stationId == 2) {
    // GC Q7: Bida + PS
    return [
      StationSpaceModel(
          stationSpaceId: 103,
          spaceCode: 'BIDA',
          spaceName: 'Bida (Billiards)',
          metadata: SpaceMetaDataModel(icon: 'sports_baseball')),
      StationSpaceModel(
          stationSpaceId: 102,
          spaceCode: 'PS',
          spaceName: 'PlayStation',
          metadata: SpaceMetaDataModel(icon: 'videogame_asset')),
    ];
  } else {
    // CyberCore: All
    return [
      StationSpaceModel(
          stationSpaceId: 101,
          spaceCode: 'NET',
          spaceName: 'NET (PC)',
          metadata: SpaceMetaDataModel(icon: 'desktop_windows')),
      StationSpaceModel(
          stationSpaceId: 103,
          spaceCode: 'BIDA',
          spaceName: 'Bida (Billiards)',
          metadata: SpaceMetaDataModel(icon: 'sports_baseball')),
    ];
  }
}

final Map<String, List<AreaModel>> kAreasMock = {
  'NET': [
    AreaModel(areaId: 1, areaCode: 'STD', areaName: 'Standard', price: 12000),
    AreaModel(areaId: 2, areaCode: 'VIP', areaName: 'VIP Zone', price: 20000),
    AreaModel(areaId: 3, areaCode: 'FPS', areaName: 'FPS Zone', price: 15000),
  ],
  'PS': [
    AreaModel(
        areaId: 4, areaCode: 'PS5_STD', areaName: 'PS5 Standard', price: 30000),
    AreaModel(
        areaId: 5, areaCode: 'PS5_VIP', areaName: 'PS5 VIP Room', price: 50000),
  ],
  'BIDA': [
    AreaModel(
        areaId: 6, areaCode: 'POOL', areaName: 'Bàn Lỗ (Pool)', price: 40000),
    AreaModel(
        areaId: 7, areaCode: 'CAROM', areaName: 'Bàn Phăng', price: 35000),
  ],
};

final List<String> kStartTimes = [
  '08:00',
  '08:30',
  '09:00',
  '09:30',
  '10:00',
  '10:30',
  '11:00',
  '11:30',
  '12:00',
  '12:30',
  '13:00',
  '13:30',
  '14:00',
  '14:30',
  '15:00',
  '15:30',
  '16:00',
  '16:30'
];
