import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';

class LoadScanFail extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return Expanded(
        flex: 4,
        child: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        navigationBloc.dispatch(HomeNavigationEvent());
                      },
                    ),
                  ],
                ),
                Text(
                  'Tải quét mã thất bại',
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          ),
        )
    );
  }

}
