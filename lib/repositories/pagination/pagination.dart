import 'package:equatable/equatable.dart';

class Pagination extends Equatable {
  final int count;
  final int currentPage;
  final int perPage;
  final int total;
  final int totalPages;

  Pagination({
    this.count,
    this.currentPage,
    this.perPage,
    this.total,
    this.totalPages,

  }) : super([
    count, currentPage, perPage, total, totalPages
  ]);

  factory Pagination.empty() {
    return Pagination(
      count: 0,
      currentPage: 0,
      perPage: 0,
      total: 0,
      totalPages: 0,
    );
  }

  @override
  String toString() =>
    'Pagination { count: $count, currentPage: $currentPage, perPage: $perPage, total: $total, totalPages: $totalPages}';

  Pagination copyWith({int count, int currentPage, int perPage, int total, int totalPages,}) {
    return Pagination(
      count: count ?? this.count,
      currentPage: currentPage ?? this.currentPage,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  static Pagination fromJson(dynamic json) {
    return Pagination(
      count: json['count'],
      currentPage: json['current_page'],
      perPage: json['per_page'],
      total: json['total'],
      totalPages: json['total_pages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': this.count,
      'currentPage': this.currentPage,
      'perPage': this.perPage,
      'total': this.total,
      'totalPages': this.totalPages,
    };
  }
}
