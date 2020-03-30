import 'package:app_customer/bloc/cancel_reason/bloc.dart';
import 'package:app_customer/bloc/cancel_reason/cancel_reason_bloc.dart';
import 'package:app_customer/bloc/city/bloc.dart';
import 'package:app_customer/bloc/config/bloc.dart';
import 'package:app_customer/bloc/contact_place/bloc.dart';
import 'package:app_customer/bloc/create_shipment/bloc.dart';
import 'package:app_customer/bloc/detail_shipment/detail_shipment_bloc.dart';
import 'package:app_customer/bloc/detail_shipment/detail_shipment_event.dart';
import 'package:app_customer/bloc/district/bloc.dart';
import 'package:app_customer/bloc/list_status/bloc.dart';
import 'package:app_customer/bloc/wallet/wallet_bloc.dart';
import 'package:app_customer/bloc/wallet/wallet_event.dart';
import 'package:app_customer/bloc/ward/bloc.dart';
import 'package:app_customer/repositories/cancel_reason/cancel_reason_repository.dart';
import 'package:app_customer/repositories/city/city_repository.dart';
import 'package:app_customer/repositories/config/config_repository.dart';
import 'package:app_customer/repositories/contact_place/contact_place_repository.dart';
import 'package:app_customer/bloc/shipment/bloc.dart';
import 'package:app_customer/repositories/detail_shipment/detail_shipment_repository.dart';
import 'package:app_customer/repositories/district/district_repository.dart';
import 'package:app_customer/repositories/list_status/list_status_repository.dart';
import 'package:app_customer/repositories/shipment/shipment_repository.dart';
import 'package:app_customer/repositories/wallet/wallet_repository.dart';
import 'package:app_customer/repositories/ward/ward_repository.dart';
import 'package:app_customer/screens/navigation/detail_shipment.dart';
import 'package:app_customer/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//blocs
import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/bloc/profile/bloc.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:app_customer/bloc/logout/bloc.dart';

//repositories
import 'package:app_customer/repositories/user/user_repository.dart';

//screens
import 'package:app_customer/screens/splash.dart';
import 'package:app_customer/screens/login/login.dart';
import 'package:app_customer/screens/home.dart';
import 'package:app_customer/screens/pack/pack.dart';
import 'package:app_customer/screens/create_shipment/create_shipment.dart';
import 'registry/registry.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final UserRepository userRepository = UserRepository();
  final WalletRepository walletRepository = WalletRepository();
  final ContactPlaceRepository contactPlaceRepository = ContactPlaceRepository();
  final ShipmentRepository shipmentRepository = ShipmentRepository();
  final DetailShipmentRepository detailShipmentRepository = DetailShipmentRepository();
  final ListStatusRepository listStatusRepository = ListStatusRepository();
  final CityRepository cityRepository = CityRepository();
  final DistrictRepository districtRepository = DistrictRepository();
  final WardRepository wardRepository = WardRepository();
  final CancelReasonRepository cancelReasonRepository = CancelReasonRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
          builder: (BuildContext context) => NavigationBloc()..dispatch(ChangeIndexPageEvent(index: 0)),
        ),
        BlocProvider<NotifyBloc>(
          builder: (BuildContext context) => NotifyBloc(),
        ),
        BlocProvider<AuthenticationBloc>(
          builder: (BuildContext context) => AuthenticationBloc(
            userRepository: userRepository
          )..dispatch(StartAuthenticationEvent()),
        ),
        BlocProvider<ProfileBloc>(
          builder: (BuildContext context) => ProfileBloc(
            navigationBloc: BlocProvider.of<NavigationBloc>(context),
            userRepository: userRepository,
            notifyBloc: BlocProvider.of<NotifyBloc>(context),
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
        ),
        BlocProvider<LogoutBloc>(
          builder: (BuildContext context) => LogoutBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            navigationBloc:  BlocProvider.of<NavigationBloc>(context),
            userRepository: userRepository),
        ),
        BlocProvider<WalletBloc>(
          builder: (BuildContext context) => WalletBloc(
            walletRepository: walletRepository,
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
        ),
        BlocProvider<ConfigBloc>(
          builder: (BuildContext context) => ConfigBloc(
            configRepository: ConfigRepository(),
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
        ),
        BlocProvider<ContactPlaceBloc>(
          builder: (BuildContext context) => ContactPlaceBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            contactPlaceRepository: contactPlaceRepository,
            notifyBloc: BlocProvider.of<NotifyBloc>(context),
          )..dispatch(SetLoadedContactPlaceEvent()),
        ),
        BlocProvider<ShipmentBloc>(
          builder: (BuildContext context) => ShipmentBloc(
            shipmentRepository: shipmentRepository,
            notifyBloc: BlocProvider.of<NotifyBloc>(context),
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)
          )..dispatch(SetLoadedShipmentEvent()),
        ),
        BlocProvider<CreateShipmentBloc>(
          builder: (BuildContext context) => CreateShipmentBloc(
            shipmentRepository: new ShipmentRepository(),
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            notifyBloc: BlocProvider.of<NotifyBloc>(context),
            navigationBloc: BlocProvider.of<NavigationBloc>(context)
          )..dispatch(SetLoadedCreateShipmentEvent()),
        ),
        BlocProvider<CityBloc>(
          builder: (BuildContext context) => CityBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            cityRepository: cityRepository),
        ),
        BlocProvider<DistrictBloc>(
          builder: (BuildContext context) => DistrictBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            districtRepository: districtRepository),
        ),
        BlocProvider<WardBloc>(
          builder: (BuildContext context) => WardBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            wardRepository: wardRepository),
        ),
        BlocProvider<ListStatusBloc>(
          builder: (BuildContext context) => ListStatusBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            listStatusRepository: listStatusRepository),
        ),
        BlocProvider<DetailShipmentBloc>(
          builder: (BuildContext context) => DetailShipmentBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            detailShipmentRepository: detailShipmentRepository
          )..dispatch(SetLoadedDetailShipmentEvent())
        ),
        BlocProvider<CancelReasonBloc>(
          builder: (BuildContext context) => CancelReasonBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            cancelReasonRepository: cancelReasonRepository
          )..dispatch(FetchCancelReasonEvent()),
        )
      ],
      child: MaterialApp(
        title: 'FUTA CUSTOMER',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MultiBlocListener(
          listeners: [
            new BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state is AuthenticatedAuthentication) {
                  BlocProvider.of<ProfileBloc>(context)
                    .dispatch(FetchProfileEvent());
                  BlocProvider.of<WalletBloc>(context)
                    .dispatch(FetchWalletEvent());
                  BlocProvider.of<ConfigBloc>(context)
                    .dispatch(FetchConfigEvent());
                  BlocProvider.of<ShipmentBloc>(context)
                    .dispatch(FetchShipmentEvent());
                }
              },
            ),
            new BlocListener<CityBloc, CityState>(
              listener: (context, state) {
                if (state is FailureCityState) {
                  BlocProvider.of<NotifyBloc>(context).dispatch(LoadingNotifyEvent(isLoading: false));
                  BlocProvider.of<NotifyBloc>(context).dispatch(
                    ShowNotifyEvent(type: NotifyEvent.ERROR, message: state.error));
                }
                if (state is LoadedCityState) {
                  BlocProvider.of<NotifyBloc>(context).dispatch(LoadingNotifyEvent(isLoading: false));
                }
              }),
            new BlocListener<DistrictBloc, DistrictState>(
              listener: (context, state) {
                if (state is FailureDistrictState) {
                  BlocProvider.of<NotifyBloc>(context).dispatch(LoadingNotifyEvent(isLoading: false));
                  BlocProvider.of<NotifyBloc>(context).dispatch(ShowNotifyEvent(type: NotifyEvent.ERROR, message: state.error));
                }
                if (state is LoadedDistrictState) {
                  BlocProvider.of<NotifyBloc>(context).dispatch(LoadingNotifyEvent(isLoading: false));
                }
              }),
            new BlocListener<WardBloc, WardState>(
              listener: (context, state) {
                if (state is FailureWardState) {
                  BlocProvider.of<NotifyBloc>(context).dispatch(LoadingNotifyEvent(isLoading: false));
                  BlocProvider.of<NotifyBloc>(context).dispatch(ShowNotifyEvent(type: NotifyEvent.ERROR, message: state.error));
                }
                if (state is LoadedWardState) {
                  BlocProvider.of<NotifyBloc>(context).dispatch(LoadingNotifyEvent(isLoading: false));
                }
              }),
            new BlocListener<NotifyBloc, NotifyState>(listener: (context, state) {
              Helper.notifyListen(state, context);
            }),
          ],
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (content, state) {
              if (state is AuthenticatedAuthentication) {
                return BlocBuilder<NavigationBloc, NavigationState>(
                  builder: (context, state) {
                    if (state is PackNavigationState) {
                      return PackPage();
                    }
                    if (state is CreateShipmentNavigationState) {
                      return CreateShipmentPage(
                        shipment: state.shipment,
                        type: state.type,
                        redirectDetail: state.redirectDetail,
                      );
                    }
                    if (state is DetailShipmentNavigationState) {
                      return DetailShipmentPage(
                        eventBack: state.eventBack
                      );
                    }
                    return HomePage();
                  }
                );
              }
              if (state is UnauthenticatedAuthentication) {
                return BlocBuilder<NavigationBloc, NavigationState>(
                  builder: (context, state) {
                    if (state is RegistryNavigationState) {
                      return RegistryPage(userRepository: userRepository);
                    }
                    return LoginPage(userRepository: userRepository);
                  }
                );
              }
              return SplashScreen();
            },
          )
        )
      ),
    );
  }
}
