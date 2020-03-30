import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PdaScanSection extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final NavigationEvent eventBack;
  final GlobalKey<PdaMainSectionState> pdaKey;

  PdaScanSection({Key key, ValueChanged<String> onChanged, NavigationEvent eventBack, GlobalKey pdaKey})
      : onChanged = onChanged,
        eventBack = eventBack != null ? eventBack : HomeNavigationEvent(),
        pdaKey = pdaKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PdaMainSection(onChanged: onChanged, eventBack: eventBack, key: pdaKey);
  }
}

class PdaMainSection extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final NavigationEvent eventBack;

  PdaMainSection({
    Key key,
    @required this.onChanged,
    @required this.eventBack,
  }) : assert(onChanged != null), assert(eventBack != null), super(key: key);

  @override
  State<PdaMainSection> createState() => PdaMainSectionState(onChanged: onChanged, eventBack: eventBack);
}

class PdaMainSectionState extends State<PdaMainSection> with WidgetsBindingObserver {
  ValueChanged<String> onChanged;
  NavigationEvent eventBack;
  NavigationBloc navigationBloc;
  TextEditingController scanController = TextEditingController();
  FocusNode myFocusNode;

  PdaMainSectionState({
    Key key,
    @required this.onChanged,
    @required this.eventBack,
  }) : assert(onChanged != null), assert(eventBack != null);

  @override
  void initState() {
    scanController.addListener(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
    super.initState();
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  void setFocus() {
    FocusScope.of(context).requestFocus(myFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 25,
          ),
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          color: Colors.white,
                          onPressed: () {
                            navigationBloc.dispatch(eventBack);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: TextField(
                          focusNode: myFocusNode,
                          controller: scanController,
                          autofocus: true,
                          onChanged: (code) {
                            scanController.text = '';
                            onChanged(code);
                            FocusScope.of(context).requestFocus(myFocusNode);
                          },
                          onTap: () {
                            SystemChannels.textInput.invokeMethod('TextInput.hide');
                          },
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 2.0)
                            ),
                            hasFloatingPlaceholder: false,
                            labelText: 'Quét mã',
                            labelStyle: TextStyle(color: Colors.white),
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2.0),
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
