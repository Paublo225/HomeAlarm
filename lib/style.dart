import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

abstract class Styles {
  static const TextStyle productRowItemName = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle productRowTotal = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle productRowItemPrice = TextStyle(
    color: Color(0xFF8E8E93),
    fontSize: 13,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle searchText = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 1),
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle deliveryTimeLabel = TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle deliveryTime = TextStyle(
      color: CupertinoColors.white, fontSize: 18, fontWeight: FontWeight.w600);

  static const Color productRowDivider = Color(0xFFD9D9D9);

  static const Color scaffoldBackground = Color(0xfff0f0f0);

  static const Color searchBackground = Color(0xffe0e0e0);

  static const Color searchCursorColor = Color.fromRGBO(0, 122, 255, 1);

  static const Color searchIconColor = Color.fromRGBO(128, 128, 128, 1);
}

/*
  void _change(BuildContext context,bool press) async{
  if(press == false){
    press = true;
  } else {
    press = false;
  }
}
   
Widget _circleDayOfWeek(){
   VoidCallback onPressed;
    bool _pressAt = false;
    List<bool> _press = new List(6);
    _press = [_pressAt,_pressAt,_pressAt,_pressAt,_pressAt,_pressAt,_pressAt];
  return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                
                children: <Widget>[
                  
                  circleDay('Пн', context, _pressAt),
                   circleDay('Вт', context,_press[1]),
                   circleDay('Ср', context,_press[2]),
                  circleDay('Чт', context, _press[3]),
                  circleDay('Пт', context, _press[4]),
                  circleDay('Сб', context, _press[5]),
                  circleDay('Вс', context,_press[6]),
                ],
              );
}


Widget circleDay(day, context, selected,){
     double screenSizew = MediaQuery.of(context).size.width;
      double screenSizeh = MediaQuery.of(context).size.height;
      Color color = Colors.orange;
      
    /*  setState(() {
              sideLength == 50 ? sideLength = 100 : sideLength = 50;
            });*/
      if(screenSizeh <=  568.0 && screenSizew <= 320){
  return Container(
    width: 30.0,
    height: 30.0,
    decoration: BoxDecoration(
      color: selected ? Colors.black12 : Colors.orange,
      borderRadius: BorderRadius.circular(200.0)
    ),
    child: Padding(
      padding: EdgeInsets.all(1.0),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0
          ),
        ),
      ),
    )
  );
}
else if(screenSizeh <=  667.0 && screenSizew <= 375.0){
   return Container(
    width: 35.0,
    height: 35.0,
    decoration: BoxDecoration(
      color: (selected)?Theme.of(context).accentColor:Colors.transparent,
      borderRadius: BorderRadius.circular(200.0)
    ),
    child: Padding(
      padding: EdgeInsets.all(1.0),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0
          ),
        ),
      ),
    )
  );
}
else if(screenSizeh <=  736.0 && screenSizew <= 414.0){
   return Container(
    width: 40.0,
    height: 40.0,
    decoration: BoxDecoration(
      color: (selected)?Theme.of(context).accentColor:Colors.transparent,
      borderRadius: BorderRadius.circular(200.0)
    ),
    child: Padding(
      padding: EdgeInsets.all(1.0),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0
          ),
        ),
      ),
    )
  );
}
else if(screenSizeh <=  896.0 && screenSizew <= 414.0){
  return new InkResponse(
    onTap: () => _change(context,selected),
   child: Container(
    width: 45.0,
    height: 45.0,
    decoration: BoxDecoration(
      color: (selected)?Theme.of(context).accentColor:Colors.transparent,
      borderRadius: BorderRadius.circular(200.0)
    ),
    child: Padding(
      padding: EdgeInsets.all(1.0),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0
          ),
        ),
      ),
    )
  ));
}
}

 Widget _daysOfWeek() {
 return  Material(
     color: Color(0xFF2B2B2B),
     child: Container(
    
       child: Row(
           children: <Widget> [ 
            
             Padding(
               padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 12),
             ),
              Padding(
               child: new CircleButton(
                onTap: () => print("Tue"), text: "Вт"
               ),
               padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 5),
             ),
            Padding(
               child: new CircleButton(onTap: () => print("Tue"), text: "Вт"),
               padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
             ),
             Padding(
               child: new CircleButton(onTap: () => print("Wed"), text:"Ср"),
               padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
             ),
             Padding(
               child: new CircleButton(onTap: () => print("Thu"), text: "Чт"),
               padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
             ),
             Padding(
               child: new CircleButton(onTap: () => print("Fri"), text: "Пт"),
               padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
             ),
             Padding(
               child: new CircleButton(onTap: () => print("Sat"), text: "Сб"),
               padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
             ),
             Padding(
               child: new CircleButton(onTap: () => print("Sun"), text: "Вс"),
               padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 5),
             )
           ]),



     )  
     );
   }

*/
