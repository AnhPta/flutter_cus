import 'package:equatable/equatable.dart';

class SearchShipment extends Equatable {
  final String q;
  final int page;
  String ignoreDraft;

  SearchShipment({
    this.q = '',
    this.page = 1,
    this.ignoreDraft,
  }) : super([
    q,
    page,
    ignoreDraft
  ]);

  @override
  String toString() {
    return ''' SearchShipment
      {
        q: $q,
        page: $page,
        ignoreDraft: $ignoreDraft,
      }
    ''';
  }

  factory SearchShipment.empty() {
    return SearchShipment(
      q: '',
      page: 0,
      ignoreDraft: 'draft'
    );
  }

  SearchShipment copyWith({
    String q,
    int page,
    String ignoreDraft
  }) {
    return SearchShipment(
      q: q ?? this.q,
      page: page ?? this.page,
      ignoreDraft: ignoreDraft ?? this.ignoreDraft,
    );
  }

  static SearchShipment fromJson(dynamic json) {
    return SearchShipment(
      q: json['q'] is String ? json['q'] : '',
      page: json['page'] is int ? json['page'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'q': this.q,
      'page': this.page,
      'ignore_statuses[]': this.ignoreDraft,
    };
  }
}
