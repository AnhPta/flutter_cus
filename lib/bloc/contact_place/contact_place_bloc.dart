import 'dart:async';
import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/repositories/contact_place/contact_place.dart';
import 'package:app_customer/repositories/contact_place/contact_place_filter.dart';
import 'package:app_customer/repositories/contact_place/contact_place_repository.dart';
import 'package:app_customer/repositories/pagination/pagination.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:dio/dio.dart';

class ContactPlaceBloc extends Bloc<ContactPlaceEvent, ContactPlaceState> {
  final ContactPlaceRepository contactPlaceRepository;
  final AuthenticationBloc authenticationBloc;
  final NotifyBloc notifyBloc;

  @override
  ContactPlaceState get initialState => InitialContactPlaceState();
  ContactPlaceBloc({
    @required this.authenticationBloc,
    @required this.notifyBloc,
    @required this.contactPlaceRepository,
  }) :
    assert(contactPlaceRepository != null),
    assert(notifyBloc != null),
    assert(authenticationBloc != null);

  @override
  Stream<ContactPlaceState> mapEventToState(
    ContactPlaceEvent event,
  ) async* {
    if (event is SetLoadedContactPlaceEvent) {
      yield* _mapSetLoadedContactPlaceEventToState();
    }
    if (event is RefreshContactPlaceEvent) {
      yield* _mapRefreshContactPlaceEventToState();
    }
    if (event is UpdateCityContactPlaceEvent) {
      yield* _mapUpdateCityContactPlaceEventToState(event);
    }
    if (event is UpdateDistrictContactPlaceEvent) {
      yield* _mapUpdateDistrictContactPlaceEventToState(event);
    }
    if (event is UpdateWardContactPlaceEvent) {
      yield* _mapUpdateWardContactPlaceEventToState(event);
    }
    if (event is CreateContactPlaceEvent) {
      yield* _mapCreateContactPlaceEventToState(event);
    }

    if (event is UpdateContactPlaceEvent) {
      yield* _mapUpdateContactPlaceEventToState(event);
    }
    if (event is FetchContactPlaceEvent) {
      yield* _mapFetchContactPlaceEventToState();
    }
    if (event is LoadMoreContactPlaceEvent) {
      yield* _mapLoadMoreContactPlaceEventToState(event);
    }
    if (event is ClearStateCreateContactPlaceEvent) {
      yield* _mapClearStateCreateContactPlaceEventToState();
    }
    if (event is FilterContactPlaceEvent) {
      yield* _mapFilterContactPlaceEventToState(event);
    }
    if (event is UpdateFormContactPlaceEvent) {
      yield* _mapUpdateFormContactPlaceEventToState(event);
    }
  }

  Stream<ContactPlaceState> _mapFilterContactPlaceEventToState(FilterContactPlaceEvent event) async* {
    if (event is FilterContactPlaceEvent) {
      try {
        if (currentState is LoadedContactPlaceState) {
          ContactPlaceFilter contactPlaceFilter = (currentState as LoadedContactPlaceState).contactPlaceFilter ;
          contactPlaceFilter = contactPlaceFilter.copyWith(q: event.q, page: 1);

          ContactPlace contactPlace = (currentState as LoadedContactPlaceState).contactPlace;
          contactPlace = contactPlace.copyWith(
            cityName: '',
            districtName: '',
            wardName: '',
            cityCode: '',
            districtCode: '',
            wardCode: '',
          );

          final response = await contactPlaceRepository.getContactPlace(
            contactPlaceFilter.toJson());
          yield LoadedContactPlaceState(
            contactPlaces: response['data'],
            contactPlace: contactPlace,
            contactPlaceFilter: contactPlaceFilter,
            pagination: response['pagination'],
          );
        }
      } on DioError catch (e) {
        yield* handlerDioError(e);
      } catch (error) {
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.ERROR,
          message: error.toString())
        );
      }
    }
  }

  Stream<ContactPlaceState> _mapClearStateCreateContactPlaceEventToState() async* {
    if (currentState is LoadedContactPlaceState) {
      ContactPlace contactPlace = (currentState as LoadedContactPlaceState).contactPlace;
      contactPlace = contactPlace.copyWith(
        cityName: '',
        districtName: '',
        wardName: '',
        cityCode: '',
        districtCode: '',
        wardCode: '',
      );
      yield (currentState as LoadedContactPlaceState).copyWith(
        contactPlace: contactPlace,
        enableSelectDistrict: false,
        enableSelectWard: false
      );
    }
  }

  Stream<ContactPlaceState> _mapLoadMoreContactPlaceEventToState(LoadMoreContactPlaceEvent event) async* {
    if (event is LoadMoreContactPlaceEvent) {
      try {
        if (currentState is LoadedContactPlaceState) {
          Pagination pagination = (currentState as LoadedContactPlaceState).pagination;
          List<ContactPlace> contactPlaces = (currentState as LoadedContactPlaceState).contactPlaces;
          if (pagination.currentPage < pagination.totalPages) {
            final response = await contactPlaceRepository.getContactPlace({ 'page': pagination.currentPage + 1 });
            if (response['data'].isNotEmpty) {
              contactPlaces = contactPlaces + response['data'];
              pagination = response['pagination'];
            }

            yield (currentState as LoadedContactPlaceState).copyWith(
              contactPlaces: contactPlaces,
              pagination: pagination,
            );
          }
        }
      } on DioError catch (e) {
        yield* processDioError(e);
      } catch (error) {
        yield FailureContactPlaceState(error: error.toString());
      }
    }
  }

  Stream<ContactPlaceState> _mapSetLoadedContactPlaceEventToState() async* {
    yield LoadedContactPlaceState.empty();
  }

  Stream<ContactPlaceState> _mapUpdateFormContactPlaceEventToState(UpdateFormContactPlaceEvent event) async* {
    ContactPlace contactPlace = (currentState as LoadedContactPlaceState).contactPlace;
    contactPlace = contactPlace.copyWith(
      cityName: event.cityName,
      cityCode: event.cityCode,
      districtName: event.districtName,
      districtCode: event.districtCode,
      wardName: event.wardName,
      wardCode: event.wardCode,
    );
    yield (currentState as LoadedContactPlaceState).copyWith(
      contactPlace: contactPlace,
      enableSelectDistrict: true,
      enableSelectWard: true,
    );
  }

  Stream<ContactPlaceState> _mapRefreshContactPlaceEventToState() async* {
    try {
      yield LoadingContactPlaceState();
      final response = await contactPlaceRepository.getContactPlace({ 'page': 1 });
      yield LoadedContactPlaceState.empty().copyWith(
        contactPlaces: response['data'],
        pagination: response['pagination'],
      );
    } on DioError catch (e) {
      yield* processDioError(e);
    } catch (error) {
      yield FailureContactPlaceState(error: error.toString());
    }
  }

  Stream<ContactPlaceState> _mapUpdateCityContactPlaceEventToState(UpdateCityContactPlaceEvent event) async* {
    if (currentState is LoadedContactPlaceState) {
      ContactPlace contactPlace = (currentState as LoadedContactPlaceState).contactPlace;
      contactPlace = contactPlace.copyWith(
        wardName: '',
        districtName: '',
        cityCode: event.selectedCityCode,
        cityName: event.selectedCityName,
        districtCode: '',
        wardCode: '',
      );
      yield (currentState as LoadedContactPlaceState).copyWith(
        contactPlace: contactPlace,
        enableSelectDistrict: true,
        enableSelectWard: false
      );
    }
  }

  Stream<ContactPlaceState> _mapUpdateDistrictContactPlaceEventToState(UpdateDistrictContactPlaceEvent event) async* {
    if (currentState is LoadedContactPlaceState) {
      ContactPlace contactPlace = (currentState as LoadedContactPlaceState).contactPlace;
      contactPlace = contactPlace.copyWith(
        districtCode: event.selectedDistrictCode,
        wardCode: '',
        districtName: event.selectedDistrictName,
        wardName: '',
      );
      yield (currentState as LoadedContactPlaceState).copyWith(
        contactPlace: contactPlace,
        enableSelectWard: event.enableSelectWard
      );
    }
  }

  Stream<ContactPlaceState> _mapUpdateWardContactPlaceEventToState(UpdateWardContactPlaceEvent event) async* {
    if (currentState is LoadedContactPlaceState) {
      ContactPlace contactPlace = (currentState as LoadedContactPlaceState).contactPlace;
      contactPlace = contactPlace.copyWith(
        wardCode: event.selectedWardCode,
        wardName: event.selectedWardName,
      );
      yield (currentState as LoadedContactPlaceState).copyWith(
        contactPlace: contactPlace,
      );
    }
  }

  Stream<ContactPlaceState> _mapCreateContactPlaceEventToState(CreateContactPlaceEvent event) async* {
    if (currentState is LoadedContactPlaceState) {
      try {
        List<ContactPlace> contactPlaces = (currentState as LoadedContactPlaceState).contactPlaces;
        ContactPlace contactPlace = (currentState as LoadedContactPlaceState).contactPlace;
        contactPlace = contactPlace.copyWith(
          name: event.name,
          phone: event.phone,
          address: event.address,
          isMain: event.isMain,
        );

        final response = await contactPlaceRepository.createContactPlace(contactPlace);
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.SUCCESS,
          message: 'Tạo mới thành công')
        );
        contactPlace = ContactPlace.fromJson(response);
        List<ContactPlace> contactPlaces1 = contactPlaces;
        if (contactPlace.isMain) {
           contactPlaces1 = contactPlaces.map((item) {
            return item.copyWith(isMain: false);
          }).toList();
        }

        contactPlaces1 = List.from(contactPlaces1
          ..insert(0, ContactPlace.fromJson(response)));

        yield (currentState as LoadedContactPlaceState).copyWith(
          contactPlaces: contactPlaces1,
          isSuccess: true,
          contactPlace: contactPlace
        );
      } on DioError catch (e) {
        yield* handlerDioError(e);
      } catch (error) {
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.ERROR,
          message: error.toString())
        );
      }
    }
  }

  Stream<ContactPlaceState> _mapUpdateContactPlaceEventToState(UpdateContactPlaceEvent event) async* {
    if (currentState is LoadedContactPlaceState) {
      try {
        ContactPlace contactPlace = (currentState as LoadedContactPlaceState).contactPlace;
        contactPlace = contactPlace.copyWith(
          id: event.id,
          name: event.name,
          phone: event.phone,
          address: event.address,
          cityCode: event.cityCode,
          districtCode: event.districtCode,
          wardCode: event.wardCode,
          isMain: event.isMain,
          isActive: event.isActive
        );

        await contactPlaceRepository.updateContactPlace(contactPlace);
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.SUCCESS,
          message: 'Cập nhật thành công')
        );
      } on DioError catch (e) {
        yield* handlerDioError(e);
      } catch (error) {
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.ERROR,
          message: error.toString())
        );
      }
    }
  }

  Stream<ContactPlaceState> handlerDioError (e) async* {
    try {
      Map response = {};
      Map errors = {};
      String errorMessage = "Không xác định";
      if (e.response == null) {
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.ERROR,
          message: 'Lỗi kết nối mạng hoặc hệ thống gặp sự cố')
        );
      }
      if (e.response != null) {
        switch (e.response.statusCode) {
          case 401:
            authenticationBloc.dispatch(LoggedOutAuthenticationEvent());
            notifyBloc.dispatch(ShowNotifyEvent(
              type: NotifyEvent.ERROR,
              message: 'Phiên làm việc của bạn đã hết hạn')
            );
            break;
          case 403:
            notifyBloc.dispatch(ShowNotifyEvent(
              type: NotifyEvent.ERROR,
              message: 'Bạn không có quyền thực hiện tác vụ này')
            );
            break;
          case 404:
            notifyBloc.dispatch(ShowNotifyEvent(
              type: NotifyEvent.ERROR,
              message: 'Dữ liệu không tồn tại')
            );
            break;
          case 422:
            response = e.response.data;
            if (response.containsKey('data') && response['data'] is Map && response['data'].containsKey('errors')) {
              errors = response['data']['errors'];
              errorMessage = errors.values.first[0];
            } else {
              errorMessage = response['message'];
            }
            notifyBloc.dispatch(ShowNotifyEvent(
              type: NotifyEvent.ERROR,
              message: errorMessage is String ? errorMessage : '')
            );
            break;
          case 500:
            notifyBloc.dispatch(ShowNotifyEvent(
              type: NotifyEvent.ERROR,
              message: 'Server gặp sự cố, vui lòng thử lại sau')
            );
            break;
          default:
            notifyBloc.dispatch(ShowNotifyEvent(
              type: NotifyEvent.ERROR,
              message: e.toString())
            );
            break;
        }
      }
    } catch (error) {
      notifyBloc.dispatch(ShowNotifyEvent(
        type: NotifyEvent.ERROR,
        message: error.toString())
      );
      return;
    }
  }

  Stream<ContactPlaceState> _mapFetchContactPlaceEventToState() async* {
    try {
      if (currentState is LoadedContactPlaceState && (currentState as LoadedContactPlaceState).contactPlaces.length > 0) {
        return;
      }
      yield LoadingContactPlaceState();
      final response = await contactPlaceRepository.getContactPlace({ 'page': 1 });
      yield LoadedContactPlaceState.empty().copyWith(
        contactPlaces: response['data'],
        pagination: response['pagination'],
      );
    } on DioError catch (e) {
      yield* processDioError(e);
    } catch (error) {
      yield FailureContactPlaceState(error: error.toString());
    }
  }

  Stream<ContactPlaceState> processDioError (e) async* {
    Map response = {};
    Map errors = {};
    String errorMessage = "Không xác định";
    if (e.response == null) {
      yield FailureContactPlaceState(error: 'Lỗi kết nối mạng hoặc hệ thống gặp sự cố');
    }
    if (e.response != null) {
      switch (e.response.statusCode) {
        case 401:
          yield FailureContactPlaceState(error: 'Phiên làm việc của bạn đã hết hạn');
          authenticationBloc.dispatch(LoggedOutAuthenticationEvent());
          break;
        case 403:
          yield FailureContactPlaceState(error: 'Bạn không có quyền thực hiện chức năng này');
          break;
        case 404:
          yield FailureContactPlaceState(
            error: 'Tính năng đang hoàn thiện, vui lòng chờ phiên bản sau');
          break;
        case 422:
          response = e.response.data;
          if (response.containsKey('data') &&
            response['data'] is Map &&
            response['data'].containsKey('errors')) {
            errors = response['data']['errors'];
            errorMessage = errors.values.first[0];
          } else {
            errorMessage = response['message'];
          }
          yield FailureContactPlaceState(error: errorMessage);
          break;
        case 500:
          yield FailureContactPlaceState(
            error: 'Server gặp sự cố, vui lòng thử lại sau');
          break;
        default:
          yield FailureContactPlaceState(error: e.toString());
          break;
      }
    }
  }
}
