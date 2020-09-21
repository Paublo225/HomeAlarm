import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homealarm/events/tr_update.dart';
import 'bloc/bloc.dart';
import 'events/tr_delete.dart';
import 'events/tr_set.dart';
import 'model/trigger.dart';
import 'settime.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

// ignore: must_be_immutable
class PlatformChannels extends StatefulWidget {
  List<dynamic> tr = [];
  List<bool> boolShit = [];
  PlatformChannels({Key key, this.tr, this.boolShit}) : super(key: key);
  @override
  _PlatformChannelStates createState() => new _PlatformChannelStates();
}

class _PlatformChannelStates extends State<PlatformChannels> {
  MethodChannel _methodChannelHome = MethodChannel('com.channel.app/home');

  DateTime _time = DateTime.now();
  String _getHome = "Нет данных";

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

  List<dynamic> _getNameTrigger = ["Нет данных"];
  Future<List<dynamic>> _getNames() async {
    List<dynamic> _getName;
    try {
      _getName = await _methodChannelHome.invokeMethod('getNameTrigger');
    } on PlatformException catch (e) {
      _getName = ['Failed to get action list .'];
    }
    setState(() {
      _getNameTrigger = _getName;
    });

    print(_getNameTrigger);

    return _getNameTrigger;
  }

  @override
  void initState() {
    super.initState();
    _getHomes();
    //_getTriggerLists();
    // _getTimes();
    //  _getNames();

    DatabaseProvider.db.getTrig().then(
      (trList) {
        BlocProvider.of<TriggerBloc>(context).add(SetTriggers(trList));
      },
    );
  }

  bool switchstate = true;
  bool switchBitch;
  List<dynamic> listOfTriggers;
  String deleteName;
  String switchName;

  @override
  Widget build(BuildContext context) {
    return new CupertinoPageScaffold(
        backgroundColor: Color(0xFF2B2B2B),
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.black54,
          middle: Text(('$_getHome'), style: TextStyle(color: Colors.white)),
          leading: Row(children: <Widget>[
            GestureDetector(
              onTap: () {
                _deleteAll() async {
                  await this._methodChannelHome.invokeMethod("deleteAll");
                }

                // _deleteAll();
              },
              child: Icon(CupertinoIcons.pen, color: Colors.orange, size: 26),
            ),
          ]),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            GestureDetector(
              onTap: () => {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (BuildContext context) => AddAlarm()))
              },
              child: Icon(CupertinoIcons.add, color: Colors.orange, size: 30),
            ),
          ]),
        ),
        child: buildingShit());
  }

  DataTable db;

  DatabaseProvider dbprov;

  Widget buildingShit() {
    if (dbprov.hashCode == null) {
      return new CupertinoPageScaffold(
        backgroundColor: Color(0xFF2B2B2B),
        child: Center(child: Text("")),
      );
    } else
      return new Scaffold(
          backgroundColor: Color(0xFF2B2B2B),
          body: new Container(
              child: BlocConsumer<TriggerBloc, List<Trigger>>(
            builder: (context, trList) {
              return new ListView.builder(
                  itemCount: trList.length,
                  reverse: false,
                  itemBuilder: (context, index) {
                    Trigger tr = trList[index];

                    return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        // Provide a function that tells the app
                        // what to do after an item has been swiped away.
                        onDismissed: (direction) {
                          // Remove the item from the data source.
                          setState(() {
                            deleteName = tr.name;
                            // widget.tr.removeAt(index);

                            print(deleteName);
                          });

                          _deleteState() async {
                            await this
                                ._methodChannelHome
                                .invokeMethod("deleteTrigger", deleteName);
                          }

                          _deleteState();

                          DatabaseProvider.db.delete(tr.id).then((_) => {
                                BlocProvider.of<TriggerBloc>(context).add(
                                  DeleteTrigger(index),
                                )
                              });
                        },
                        child: buildList(tr.id, tr.name, tr.hour, tr.minute,
                            tr.isEnabled, index, tr),
                        background: Container(
                            color: Colors.red,
                            child: Container(
                              margin: EdgeInsets.only(right: 15),
                              child: IconButton(
                                icon: Icon(CupertinoIcons.delete_solid),
                                onPressed: () {},
                                color: Colors.white,
                                alignment: Alignment.centerRight,
                                iconSize: 32,
                              ),
                            )));
                  });
            },
            listener: (BuildContext context, trList) {},
          )));
  }

  Widget buildList(
      id, String name, hour, minute, bool _isOn, index, Trigger tr) {
    String min;
    if (minute < 10)
      min = "0$minute";
    else
      min = minute.toString();
    return Card(
      margin: EdgeInsets.only(left: 0.0, right: 0.0),
      color: Color(0xFF202020),
      child: Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text("$hour:$min",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 45.0,
                            fontFamily: 'SF Pro')),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          '$name',
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 18.0,
                              fontFamily: 'SF Pro'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              new CupertinoSwitch(
                value: _isOn,
                onChanged: (bool val) {
                  setState(() {
                    switchName = name;
                    tr.isEnabled = !_isOn;
                  });
                  DatabaseProvider.db.disorenable(tr);
                  print(switchName);

                  _switchState() async {
                    await this
                        ._methodChannelHome
                        .invokeMethod("switchTrigger", switchName);
                  }

                  _switchState();
                },
                activeColor: Color(0xFF15E230),
              ),
            ],
          ),
          new SizedBox(
            height: 10.0,
          ),
          new SizedBox(
            height: 0.5,
            child: Container(
              color: Colors.white12,
            ),
          )
        ],
      ),
    );
  }

  List<dynamic> _getTriggerList = ["faild"];

  Future<List<dynamic>> _getTriggerLists() async {
    List<dynamic> _getTrigger;

    _getTrigger = await _methodChannelHome.invokeMethod('getTriggers');

    setState(() {
      _getTriggerList = _getTrigger;
    });

    return _getTriggerList;
  }

  List<dynamic> _getTimeTrigger = ["Нет данных"];
  Future<List<dynamic>> _getTimes() async {
    List<dynamic> _getTime;
    _getTime = await _methodChannelHome.invokeMethod('getNameTrigger');
    setState(() {
      _getTimeTrigger = _getTime;
    });
    print(_getTimeTrigger);
    return _getTimeTrigger;
  }
}
