import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'model/trigger.dart';
import 'style.dart';
import 'package:flutter/services.dart';
import 'settime.dart';

class DaysOfWeek {
  final int id;
  final String title;
  final String short;
  bool selected;
  DaysOfWeek(this.id, this.title, this.short, this.selected);
}

class SceneList extends StatefulWidget {
  SceneList();
  @override
  _SceneListState createState() => _SceneListState();
}

class _SceneListState extends State<SceneList> {
  List<DaysOfWeek> daysWeek = <DaysOfWeek>[
    DaysOfWeek(2, 'Понeдельник', "Пн", false),
    DaysOfWeek(3, 'Вторник', "Вт", false),
    DaysOfWeek(4, 'Среда', "Ср", false),
    DaysOfWeek(5, 'Четверг', "Чт", false),
    DaysOfWeek(6, 'Пятница', "Пт", false),
    DaysOfWeek(7, 'Суббота', "Сб", false),
    DaysOfWeek(1, 'Воскресенье', "Вс", false),
  ];
  bool selectingmode = true;
  List<int> listOfWeeks;
  Trigger tr;

  getCheckboxItems() {
    List<int> tmpArray = [];
    daysWeek.forEach((key) {
      if (key.selected == true) {
        tmpArray.add(key.id);
      }
      if (key.selected == false) {
        tmpArray.remove(key);
      }
    });
    // Printing all selected items on Terminal screen.

    // Here you will get all your selected Checkbox items.
    return tmpArray;
    // Clear array after use.
  }

  getShortItems() {
    List<String> tmpArray = [];
    daysWeek.forEach((key) {
      if (key.selected == true) {
        tmpArray.add(key.short);
      }
      if (key.selected == false) {
        tmpArray.remove(key);
      }
    });
    // Printing all selected items on Terminal screen.

    // Here you will get all your selected Checkbox items.
    return tmpArray;
    // Clear array after use.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          accentColor: Colors.transparent,
          focusColor: Colors.transparent,
          brightness: Brightness.dark,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        home: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: Colors.black45,
            middle: Text('Повтор', style: TextStyle(color: Colors.white)),
            leading: Row(children: <Widget>[
              GestureDetector(
                onTap: () => {Navigator.pop(context)},
                child:
                    Icon(CupertinoIcons.back, color: Colors.orange, size: 25),
              )
            ]),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              GestureDetector(
                onTap: () {
                  listOfWeeks = getCheckboxItems();
                  print("$listOfWeeks f");
                  Navigator.push(
                      context,
                      new CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              new AddAlarm(weeks: listOfWeeks)));
                },
                child: Text("Сохранить",
                    style: TextStyle(color: Colors.orange, fontSize: 16)),
              )
            ]),
          ),
          child: Scaffold(
            backgroundColor: Color(0xFF2B2B2B),
            body: ListView(
              children: List.generate(daysWeek.length, (index) {
                return new CheckboxListTile(
                  onChanged: (bool value) {
                    setState(() {
                      daysWeek[index].selected = value;
                    });
                    listOfWeeks = getCheckboxItems();

                    print(listOfWeeks);
                  },
                  activeColor: Colors.orange,
                  checkColor: Colors.white,
                  title: Text(daysWeek[index].title,
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  value: daysWeek[index].selected,
                );
              }).toList(),
            ),
          ),
        ));
  }
}
