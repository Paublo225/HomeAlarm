import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'bloc/bloc.dart';

import 'db.dart';
import 'events/tr_add.dart';
import 'model/trigger.dart';

import 'package:flutter/services.dart';
import 'weekdays.dart';

// ignore: must_be_immutable
class AddAlarm extends StatefulWidget {
  List<int> weeks;
  AddAlarm({
    Key key,
    this.weeks,
  }) : super(key: key);

  @override
  _AddAlarmState createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name;
  DateTime _dateTimes = DateTime.now();
  TimeOfDay time;

  MethodChannel _methodChannelTrigger = MethodChannel('com.channel.app/home');

  String namus;
  List<int> weekdays;
  static int hour;
  static int minute;
  static String selectedScenus;
  static bool isEnabled = true;

  static List<dynamic> tr = new List();
  List<dynamic> getTriggerList = new List();
  List<bool> boolShit = new List();
  int countdb;

  void showDialogView() {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text("Сценарий"),
        content: new Text("Выберите сцениарий."),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenSizew = MediaQuery.of(context).size.width;
    double screenSizeh = MediaQuery.of(context).size.height;

    return MaterialApp(
        theme: ThemeData(
          accentColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          cupertinoOverrideTheme: CupertinoThemeData(
              brightness: Brightness.dark,
              textTheme: CupertinoTextThemeData(
                  textStyle: TextStyle(color: Colors.black))),
        ),
        home: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              backgroundColor: Colors.black54,
              middle: const Text('Добавление',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              leading: Row(children: <Widget>[
                GestureDetector(
                  onTap: () => {
                    Navigator.pop(
                        context,
                        CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                PlatformChannel()))
                  },
                  child: Text("Отменить",
                      style: TextStyle(color: Colors.orange, fontSize: 16)),
                )
              ]),
              trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (selectedScenus == null) {
                          showDialogView();
                        } else {
                          weekdays = widget.weeks;
                          if (namus == null) {
                            namus = "Триггер ${countdb + 1}";
                            print("length: $countdb");
                          }
                          if (hour == null) hour = _dateTimes.hour;
                          if (minute == null) minute = _dateTimes.minute;
                          if (weekdays == null) {
                            weekdays = [1, 2, 3, 4, 5, 6, 7];
                          }
                          if (isEnabled == null) isEnabled = true;

                          getTriggerList = [
                            namus,
                            weekdays,
                            hour,
                            minute,
                            selectedScenus,
                            isEnabled
                          ];

                          tr.insert(tr.length, getTriggerList);

                          Trigger trig = Trigger(
                              name: namus,
                              hour: hour,
                              minute: minute,
                              isEnabled: isEnabled);

                          DatabaseProvider.db.insert(trig).then(
                                (storedTrig) =>
                                    BlocProvider.of<TriggerBloc>(context).add(
                                  AddTrigger(storedTrig),
                                ),
                              );
                          var route = new CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                new PlatformChannel(
                              tr: tr,
                            ),
                          );

                          Navigator.of(context).push(route);

                          _getTrigger() async {
                            await this
                                ._methodChannelTrigger
                                .invokeMethod("createTrigger", getTriggerList);
                          }

                          _getTrigger();

                          print(getTriggerList);

                          namus = null;
                          hour = null;
                          minute = null;
                          selectedScenus = null;
                        }
                      },
                      child: Text("Сохранить",
                          style: TextStyle(color: Colors.orange, fontSize: 16)),
                    )
                  ]),
            ),
            child: Scaffold(
                backgroundColor: Color(0xFF2B2B2B),
                body: CustomScrollView(
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverPadding(
                        padding: const EdgeInsets.all(1.0),
                        sliver: SliverList(
                            delegate: SliverChildListDelegate(<Widget>[
                          Column(
                            children: <Widget>[
                              SizedBox(
                                  key: _formKey,
                                  height: 350,
                                  child: CupertinoDatePicker(
                                      use24hFormat: true,
                                      backgroundColor: Color(0xFF2B2B2B),
                                      initialDateTime: _dateTimes,
                                      mode: CupertinoDatePickerMode.time,
                                      onDateTimeChanged: (_dateTime) {
                                        setState(() {
                                          _dateTimes = _dateTime;
                                          hour = _dateTimes.hour;
                                          minute = _dateTimes.minute;
                                        });
                                      })),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                child: _buildNameField(),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 7),
                                child: RaisedButton(
                                  color: Colors.orange,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 8),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                SceneList()));
                                  },
                                  child: Text("Дни недели",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      )),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 220, 7),
                                child: Text("Сценарии",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              ),
                              Column(
                                children: radioScenesList(),
                              ),
                            ],
                          ),
                        ])))
                  ],
                ))));
  }

  Widget _buildNameField() {
    return CupertinoTextField(
      style: TextStyle(fontSize: 18, color: Color(0xFFDACECE)),
      padding: const EdgeInsets.symmetric(vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      textCapitalization: TextCapitalization.words,
      autocorrect: false,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 0,
            color: CupertinoColors.white,
          ),
          bottom: BorderSide(
            width: 0,
            color: CupertinoColors.white,
          ),
        ),
      ),
      placeholder: 'Название',
      placeholderStyle: TextStyle(color: Color(0xFFDACECE), fontSize: 18),
      onChanged: (_newName) {
        setState(() {
          name = _newName;
          namus = _newName;
        });
      },
    );
  }

  static const MethodChannel _methodChannelHome =
      MethodChannel('com.channel.app/home');

  List<dynamic> _getActionList = ["faild"];
  String _getHome = "Unknown";

  Future<List<dynamic>> _getActionLists() async {
    List<dynamic> _getAction;

    try {
      _getAction = await _methodChannelHome.invokeMethod('getActions');
    } on PlatformException catch (e) {
      _getAction = ['Failed to get action list .'];
    }
    setState(() {
      _getActionList = _getAction;
    });

    print(_getActionList);
    return _getActionList;
  }

  void _awaitReturnValue(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlatformChannel(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      // text = result;
    });
  }

  Future<int> _countRaws() async {
    int result;
    Database db = await DatabaseProvider.db.database;
    try {
      List<Map<String, dynamic>> x = await db
          .rawQuery('SELECT COUNT (*) from ${DatabaseProvider.TRIG_TABLE}');
      result = Sqflite.firstIntValue(x);
    } on PlatformException {
      result = 000;
    }
    setState(() {
      countdb = result;
    });
    return countdb;
  }

  Future<String> _getHomes() async {
    String getHome;
    try {
      getHome = await _methodChannelHome.invokeMethod('getHome');
    } on PlatformException {
      getHome = "faild";
    }
    setState(() {
      _getHome = getHome;
    });
    return _getHome;
  }

  initState() {
    super.initState();
    _getHomes();
    _getActionLists();
    selectedRadio = 0;
    _countRaws();
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  setSelectedUser(dynamic _scene) {
    setState(() {
      _selectedScene = _scene;
    });
  }

  int selectedRadioTile;

  int selectedRadio;
  String _selectedScene;

  List<Widget> radioScenesList() {
    List<Widget> widgets = [];
    for (int _i = 0; _i < _getActionList.length; _i++) {
      widgets.add(
        RadioListTile(
          value: _getActionList[_i],
          groupValue: _selectedScene,
          title:
              Text(_getActionList[_i], style: TextStyle(color: Colors.white)),
          onChanged: (_currentUser) {
            print("Selected scene $_currentUser");
            setSelectedUser(_currentUser);
            setSelectedRadio(_i);
            if (_selectedScene == _getActionList[_i])
              print(true);
            else
              print(false);
            //nomer = selectedRadio;
            //nazvanie = _selectedScene;
            setState(() {
              selectedScenus = _currentUser;
            });

            print(selectedRadio);
            print(_selectedScene);
          },
          selected: _selectedScene == _getActionList[_i],
          activeColor: Colors.orange,
        ),
      );
    }
    return widgets;
  }
}
