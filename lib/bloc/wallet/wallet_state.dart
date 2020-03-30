import 'package:app_customer/repositories/wallet/wallet.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class WalletState extends Equatable {
  WalletState([List props = const []]) : super(props);
}

class InitialWalletState extends WalletState {
  @override
  String toString() {
    return 'InitialWalletState';
  }
}

class LoadingWalletState extends WalletState {
  @override
  String toString() {
    return 'LoadingWalletState';
  }
}

class LoadedWalletState extends WalletState {
  final List<Wallet> wallet;
  final bool showDialog;
  final bool isSuccess;
  final bool isFailure;
  final String messageSuccess;
  final String messageFailure;
  LoadedWalletState({@required this.wallet, this.isFailure = false, this.isSuccess = false,
    this.messageSuccess = '', this.messageFailure = '', this.showDialog = false})
      : super([wallet, isFailure, isSuccess, messageSuccess, messageFailure, showDialog]);

  @override
  String toString() {
    return 'LoadedWalletState {wallet: $wallet, isSuccess: $isSuccess, isFailure: $isFailure, showDialog: $showDialog, messageSuccess: $messageSuccess, messageFailure: $messageFailure, }';
  }
  LoadedWalletState copyWith({
    String messageSuccess,
    String messageFailure,
    List<Wallet> wallet,
    bool isSuccess,
    bool isFailure,
    bool showDialog,
  })
  {
    return LoadedWalletState(
      messageSuccess: messageSuccess ?? this.messageSuccess,
      messageFailure: messageFailure ?? this.messageFailure,
      wallet: wallet ?? this.wallet,
      isSuccess: isSuccess ?? this.isSuccess,
      showDialog: showDialog ?? this.showDialog,
      isFailure: isFailure ?? this.isFailure,
    );
  }
  static LoadedWalletState initialFromJson(dynamic json) {
    return LoadedWalletState(
      wallet: json['data'],
    );
  }
}

class FailureWalletState extends WalletState {
  final String error;
  FailureWalletState({@required this.error}) : super([error]);

  @override
  String toString() {
    return 'LoadedWalletState {error: $error}';
  }
}
