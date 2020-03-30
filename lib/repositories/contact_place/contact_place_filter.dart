import 'package:equatable/equatable.dart';

class ContactPlaceFilter extends Equatable {
  final String q;
  final int page;

  ContactPlaceFilter({
    this.q = '',
    this.page = 1,
  }) : super([
    q,
    page
  ]);

  @override
  String toString() {
    return ''' ContactPlaceFilter
      {
        q: $q,
        page: $page,
      }
    ''';
  }

  factory ContactPlaceFilter.empty() {
    return ContactPlaceFilter(
      q: '',
      page: 0,
    );
  }

  ContactPlaceFilter copyWith({
    String q,
    int page
  }) {
    return ContactPlaceFilter(
      q: q ?? this.q,
      page: page ?? this.page,
    );
  }

  static ContactPlaceFilter fromJson(dynamic json) {
    return ContactPlaceFilter(
      q: json['q'] is String ? json['q'] : '',
      page: json['page'] is int ? json['page'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'q': this.q,
      'page': this.page,
    };
  }
}
