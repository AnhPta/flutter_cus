import 'dart:ui';

import 'package:flutter/material.dart';

class ShipmentHelper {
  static Color getColorStatus(status) {
    Map colorByStatus = {
      'draft': Colors.lightBlue,
      'new': Color(0xff000000),
      'pickup': Color(0xff6c757d),
      'picking_up': Color(0xff17a2b8),
      'picked_up': Color(0xff28a745),
      'delivering': Color(0xff17a2b8),
      'delivered': Color(0xff28a745),
      'failed': Color(0xffffc107),
      'returning': Color(0xffffc107),
      'returned': Color(0xffffc107),
      'cancel': Color(0xffdc3545),
      'part_delivered': Color(0xffffc107),
      'lost': Color(0xffffc107),
      'damaged': Color(0xffffc107),
      'compare': Color(0xff28a745),
      'done': Color(0xff7c7bad),
    };
    return colorByStatus[status];
  }
}
