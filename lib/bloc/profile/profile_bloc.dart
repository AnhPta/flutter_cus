import 'dart:async';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/repositories/user/user.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:app_customer/repositories/user/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:app_customer/bloc/authentication/bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;
  final NotifyBloc notifyBloc;
  final NavigationBloc navigationBloc;

  @override
  ProfileState get initialState => InitialProfileState();

  ProfileBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
    @required this.notifyBloc,
    @required this.navigationBloc,
  })  : assert(userRepository != null),
        assert(notifyBloc != null),
        assert(navigationBloc != null),
        assert(authenticationBloc != null);

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is FetchProfileEvent) {
      yield* _mapFetchProfileEventToState();
    }
    if (event is ChangePassEvent) {
      yield* _changePassEventToState(event);
    }
    if (event is ChangeProfileEvent) {
      yield* _changeProfileEventToState(event);
    }
    if (event is ShowDiaLogChangePassEvent) {
      yield* _showDiaLogChangePassEvent();
    }
    if (event is CloseDiaLogChangePassEvent) {
      yield* _closeDiaLogChangePassEvent();
    }
    if (event is ChangePassSuccessEvent) {
      yield* _changePassSuccessEvent();
    }
    if (event is ChangeAvatarEvent) {
      yield* _changeAvatarEventToState(event);
    }
  }

  Stream<ProfileState> _mapFetchProfileEventToState() async* {
    yield LoadingProfileState();
    try {
      final user = await userRepository.getProfile();
      yield LoadedProfileState(user: user);
    } on DioError catch (e) {
      if (e.response != null && e.response.statusCode == 401) {
        authenticationBloc.dispatch(LoggedOutAuthenticationEvent());
      }
      yield FailureProfileState(error: e.toString());
    } catch (error) {
      yield FailureProfileState(error: error.toString());
    }
  }

  Stream<ProfileState> _changePassEventToState(ChangePassEvent event) async* {
    if (currentState is LoadedProfileState  && !(currentState as LoadedProfileState).isLoading) {
      try {
        yield(currentState as LoadedProfileState).copyWith(isLoading: true);
        await userRepository.changePass(
            event.oldPass, event.newPass, event.confirmPass);
        await Future.delayed(Duration(seconds: 1));
        yield(currentState as LoadedProfileState).copyWith(isSuccess: true);
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.SUCCESS,
          message: 'Đổi mật khẩu thành công')
        );
        yield(currentState as LoadedProfileState).copyWith(isSuccess: false, isLoading: false);

      } on DioError catch (e) {
        yield* handlerDioError(e);
        yield(currentState as LoadedProfileState).copyWith(isSuccess: false, isLoading: false);
      } catch (error) {
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.ERROR,
          message: error.toString())
        );
      }
    }
  }

  Stream<ProfileState> handlerDioError (e) async* {
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

  Stream<ProfileState> _changeProfileEventToState(
      ChangeProfileEvent event) async* {
    if (currentState is LoadedProfileState && !(currentState as LoadedProfileState).isLoading) {
      try {
        yield(currentState as LoadedProfileState).copyWith(isLoading: true);
        final response = await userRepository.changeProfile(event.name, event.phone,
            event.birthday, event.email, event.address);
        User newUser = (currentState as LoadedProfileState)
            .user
            .copyWith(name: response['name'], phone: response['phone'],
              birthday: response['birthday'], email: response['email'], address: response['address']);
        await userRepository.updateProfile(newUser);
        await Future.delayed(Duration(seconds: 1));
        final user = await userRepository.getProfile();
        yield LoadedProfileState(user: user);
         notifyBloc.dispatch(ShowNotifyEvent(
           type: NotifyEvent.SUCCESS,
           message: 'Đổi thông tin thành công')
         );
        yield(currentState as LoadedProfileState).copyWith(isLoading: false);
      } on DioError catch (e) {
        yield* _processDioError(e);
        yield(currentState as LoadedProfileState).copyWith(isLoading: false);
        return;
      } catch (error) {
        yield (currentState as LoadedProfileState).copyWith(
            isFailure: true, messageFailure: 'Cập nhật thông tin thất bại');
      }
    }
  }

  Stream<ProfileState> _showDiaLogChangePassEvent() async* {
    if (currentState is LoadedProfileState) {
      yield (currentState as LoadedProfileState).copyWith(showDialog: true);
    }
  }

  Stream<ProfileState> _closeDiaLogChangePassEvent() async* {
    if (currentState is LoadedProfileState) {
      yield (currentState as LoadedProfileState).copyWith(showDialog: false);
    }
  }

  Stream<ProfileState> _changePassSuccessEvent() async* {
    if (currentState is LoadedProfileState) {
      yield (currentState as LoadedProfileState)
          .copyWith(isSuccess: false, isFailure: false);
    }
  }

  Stream<ProfileState> _changeAvatarEventToState(
      ChangeAvatarEvent event) async* {
    if (currentState is LoadedProfileState) {
      try {
        final response = await userRepository.changeAvatar(event.file);
        User newUser = (currentState as LoadedProfileState)
            .user
            .copyWith(avatar: response['name'], avatarPath: response['path']);
        await userRepository.updateProfile(newUser);
        yield (currentState as LoadedProfileState).copyWith(
            isSuccess: true,
            messageSuccess: 'Đổi ảnh đại diện thành công',
            user: newUser);
      } on DioError catch (e) {
        yield* _processDioError(e);
        return;
      } catch (error) {
        yield (currentState as LoadedProfileState).copyWith(
            isFailure: true, messageFailure: 'Đổi ảnh đại diện thất bại');
      }
    }
  }

  Stream<ProfileState> _processDioError(e) async* {
    Map response = {};
    Map errors = {};
    String errorMessage = "Không xác định";
    if (e.response == null) {
      yield (currentState as LoadedProfileState).copyWith(
          isFailure: true,
          messageFailure: 'Lỗi kết nối mạng hoặc hệ thống gặp sự cố');
    }
    if (e.response != null) {
      switch (e.response.statusCode) {
        case 401:
          authenticationBloc.dispatch(LoggedOutAuthenticationEvent());
          yield (currentState as LoadedProfileState).copyWith(
              isFailure: true,
              messageFailure: 'Phiên làm việc của bạn đã hết hạn');
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
          yield (currentState as LoadedProfileState).copyWith(
              isFailure: true,
              messageFailure: errorMessage is String ? errorMessage : '');
          break;
        case 403:
          yield (currentState as LoadedProfileState).copyWith(
              isFailure: true,
              messageFailure: 'Bạn không có quyền thực hiện tác vụ này');
          break;
        case 404:
          errorMessage = 'Dữ liệu không tồn tại';
          yield (currentState as LoadedProfileState)
              .copyWith(isFailure: true, messageFailure: errorMessage);
          break;
        default:
          yield (currentState as LoadedProfileState)
              .copyWith(isFailure: true, messageFailure: e.toString());
          break;
      }
    }
  }
}
