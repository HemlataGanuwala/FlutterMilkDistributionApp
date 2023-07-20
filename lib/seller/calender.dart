import 'dart:collection';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/CalenderModel/green_circle_model.dart';
import 'package:milkdistributionflutter/model/CustomerModel.dart';
import 'package:milkdistributionflutter/model/DeliveryStatusModel.dart';
import 'package:milkdistributionflutter/model/ProductModel.dart';
import 'package:milkdistributionflutter/model/ProductNameModel.dart';
import 'package:milkdistributionflutter/model/ProductStatusModel.dart';
import 'package:milkdistributionflutter/seller/change_milk_quantity.dart';
import 'package:milkdistributionflutter/seller/evenodd.dart';
import 'package:milkdistributionflutter/seller/plan_vaccation.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

import '../MyServices.dart';

class CalenderPage extends StatefulWidget {
  int? custid;
  CalenderPage(this.custid);

  @override
  State<StatefulWidget> createState() {
    return CalenderPageState(custid);
  }
}

class CalenderPageState extends State<CalenderPage> {
  int? custid;
  //CalendarController _controller;
  MyServices _myServices = new MyServices();
  Future<List<DeliveryStatusModel>>? deliverystatusfuture;
  Future<List<ProductStatusModel>>? productfuture;
  List<DeliveryStatusModel>? deliverystatusList;
  List<ProductStatusModel>? productList;
  DateTime? selectedDate = DateTime.now();
  String? cmonth, cday, cyear, milkstatus;
  double? ch = 0, cf = 0, bh = 0, bf = 0;
  bool? milkS = true;

  List? _selectedEvents;
  Map<DateTime, List>? _events;
  Future? eventfuture;

  CalenderPageState(this.custid);
  String? sday, smonth, syear, sdate, cowmilk, buffmilk;
  int? coneqty, boneqty, chalfqty, bhalfqty;
  double? ctotamt, btotamt, crate, brate;
  String? dropdownValue = 'Select';
  List<String> spinnerItems = ['Select', 'No Milk', 'Min/Max', 'Add Product'];
  CalendarFormat? _calendarFormat = CalendarFormat.month;
  DateTime? _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List>? _eventsList = {};

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    _selectedEvents = [];
    //_controller = CalendarController();
    cmonth = selectedDate!.month.toString();
    cyear = selectedDate!.year.toString();
    _events = Map<DateTime, List>();
    deliverystatusfuture = getDeliveryStatusData();
    productfuture = getProductDeliveryStatusData();
    getTask1().then((val) => setState(() {
          _eventsList = val;
        }));
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Future<Map<DateTime, List>> getTask1() async {
    var dateTime1;
    Map<DateTime, List> mapFetch = {};
    List<DeliveryStatusModel> eventmn = await deliverystatusfuture!;

    List<ProductStatusModel> event = await productfuture!;
    if (event.length != 0) {
      for (int i = 0; i < event.length; i++) {
        // var parsedDate = DateTime.parse(event[i].delvryCustcdate);
        if (event[i].Product_cdate == "") {
          dateTime1 = DateFormat('d/M/yyyy').parse(event[i].DelvryCustcdate!);
        } else {
          dateTime1 = DateFormat('d/M/yyyy').parse(event[i].Product_cdate!);
        }

        var createTime =
            DateTime(dateTime1.year, dateTime1.month, dateTime1.day);
        var original = mapFetch[createTime];
        if (original == null) {
          print("null");
          if (event[i].Product_status == "") {
            mapFetch[createTime] = [event[i].DelvryCustmilkstatus];
          } else {
            mapFetch[createTime] = [event[i].Product_status];
          }
        } else {
          // print(event[i].delvryCustmilkstatus);
          if (event[i].Product_status == "") {
            mapFetch[createTime] = List.from(original)
              ..addAll([event[i].DelvryCustmilkstatus]);
          } else {
            mapFetch[createTime] = List.from(original)
              ..addAll([event[i].Product_status]);
          }
        }
      }
    } else {
      for (int i = 0; i < eventmn.length; i++) {
        // var parsedDate = DateTime.parse(event[i].delvryCustcdate);
        dateTime1 = DateFormat('d/M/yyyy').parse(eventmn[i].delvryCustcdate!);

        var createTime =
            DateTime(dateTime1.year, dateTime1.month, dateTime1.day);
        var original = mapFetch[createTime];
        if (original == null) {
          print("null");
          mapFetch[createTime] = [eventmn[i].delvryCustmilkstatus];
        } else {
          // print(event[i].delvryCustmilkstatus);
          mapFetch[createTime] = List.from(original)
            ..addAll([eventmn[i].delvryCustmilkstatus]);
        }
      }
    }
    return mapFetch;
  }

  void _onDaySelected(DateTime day, DateTime events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedDay = day;
    });
  }

  Future<List<ProductStatusModel>> getProductStatusData() async {
    Map<String, String> JsonBody = {
      'CompanyId': _myServices.myCompanyId!,
      'CustId': custid.toString(),
      'Cmonth': cmonth!,
      'Cyear': cyear!,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl! + "DeliveredStatus/GetProductDateData"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      productList = List<ProductStatusModel>.from(
          (json.decode(response.body)['Response'])
              .map((i) => ProductStatusModel.fromJson(i)));

      return productList!;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future<List<DeliveryStatusModel>> getDeliveryStatusData() async {
    Map<String, String> JsonBody = {
      'CompanyId': _myServices.myCompanyId!,
      'CustId': custid.toString(),
      'Cmonth': cmonth!,
      'Cyear': cyear!,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl! + "DeliveredStatus/GetDeliveryDateData"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      deliverystatusList = List<DeliveryStatusModel>.from(
          (json.decode(response.body)['Response'])
              .map((i) => DeliveryStatusModel.fromJson(i))).toList();
      // _Totalqty();
      return deliverystatusList!;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future<List<ProductStatusModel>> getProductDeliveryStatusData() async {
    Map<String, String> JsonBody = {
      'CompanyId': _myServices.myCompanyId!,
      'CustId': custid.toString(),
      'Cmonth': cmonth!,
      'Cyear': cyear!,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl! + "DeliveredStatus/GetProductDeliveryData"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      productList = List<ProductStatusModel>.from(
          (json.decode(response.body)['Response'])
              .map((i) => ProductStatusModel.fromJson(i))).toList();
      // _Totalqty();
      return productList!;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList!);

    List getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Milk Status"),
        backgroundColor: Color(0xFF2B2B81),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 10.0),
              child: TableCalendar(
                firstDay: DateTime.utc(2021, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay!,
                eventLoader: getEventForDay,
                //calendarFormat: _calendarFormat,
                availableGestures: AvailableGestures.all,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                rowHeight: 50.0,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      String sday = selectedDay.day.toString();
                      String smonth = selectedDay.month.toString();
                      String syear = selectedDay.year.toString();
                      String sdate = sday+"/"+smonth+"/"+syear;

                      showCupertinoModalPopup(context: context, builder:
                          (context) => ChangeMilkQuantity(sday,smonth,syear,sdate,custid!)
                      );
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) => events
                          .contains("nomilk")
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Text(
                              day.day.toString(),
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14.0),
                            ),
                          ),
                        )
                      : events.contains("MinMaxMilk")
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.lightBlue[600],
                                child: Text(
                                  day.day.toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.0),
                                ),
                              ),
                            )
                          : events.contains("AddProduct")
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 6.0),
                                  child: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.0, color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Text(
                                      day.day.toString(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14.0),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 6.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.green[600],
                                    child: Text(
                                      day.day.toString(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14.0),
                                    ),
                                  ),
                                ),
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 5.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: Color(0xFF2B2B81),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ButtonTheme(
                      minWidth: 150,
                      height: 40,
                      child: TextButton(
                        onPressed: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) => PlanVaccation(custid!));
                          // if(_formkey.currentState.validate())
                          // {
                          //   // RegistrationUser();
                          //   print("Successful");
                          // }else
                          // {
                          //   print("Unsuccessfull");
                          // }
                        },
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(
                              color: Colors.white,
                              backgroundColor: Color(0xFF2B2B81)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("PLAN VACCATION",
                            style: GoogleFonts.adamina(
                                fontSize: 12.0, color: Colors.white)),
                      ),
                    ),
                  ),
                  Container(
                    height: 5.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: Color(0xFF2B2B81),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ButtonTheme(
                      minWidth: 150,
                      height: 40,
                      child: TextButton(
                        onPressed: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) =>
                                  EvenOdd(custid!, cmonth!, cyear!));
                        },
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(
                              color: Colors.white,
                              backgroundColor: Color(0xFF2B2B81)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("EVEN/ODD",
                            style: GoogleFonts.adamina(
                                fontSize: 12.0, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 10.0,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 2.9,
                            child: Text(
                              "Milk Status",
                              style: GoogleFonts.adamina(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 4,
                            child: Text(
                              "Date",
                              style: GoogleFonts.adamina(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 4,
                            child: Text(
                              "Qty",
                              style: GoogleFonts.adamina(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    height: MediaQuery.of(context).size.height / 4.2,
                    child: FutureBuilder<List<DeliveryStatusModel>>(
                      future: deliverystatusfuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done)
                          return Center(child: CircularProgressIndicator());
                        if (snapshot.hasData) {
                          List<DeliveryStatusModel> cartitem = snapshot.data!;
                        }
                        return ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder:
                              (BuildContext context, int contextIndex) {
                            ch = 0.5 *
                                snapshot.data![contextIndex]
                                    .delvryCustcowmilkhalfqty!;
                            cf = ch! +
                                snapshot
                                    .data![contextIndex].delvryCustcowmilkqty!;
                            bh = 0.5 *
                                snapshot.data![contextIndex]
                                    .delvryCustbuffallomilkhalfqty!;
                            bf = bh! +
                                snapshot.data![contextIndex]
                                    .delvryCustbuffallomilkqty!;
                            milkstatus = snapshot
                                .data![contextIndex].delvryCustmilkstatus!;
                            if (milkstatus == "nomilk") {
                              milkS = true;
                            } else {
                              milkS = false;
                            }
                            return InkWell(
                              onTap: () {
                                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => CalenderPage()));
                                // snapshot.data[contextIndex].Id.toString(),
                                //     snapshot.data[contextIndex].RouteName,snapshot.data[contextIndex].AgentName +" "+ snapshot.data[contextIndex].AgentId.toString())));
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    top: 5.0,
                                    bottom: 5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    milkS!
                                        ? Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.9,
                                            child: Text(
                                              snapshot.data![contextIndex]
                                                  .delvryCustmilkstatus!,
                                              style: GoogleFonts.adamina(
                                                fontSize: 14.0,
                                                color: Colors.red,
                                              ),
                                            ))
                                        : Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.9,
                                            child: Text(
                                              snapshot.data![contextIndex]
                                                  .delvryCustmilkstatus!,
                                              style: GoogleFonts.adamina(
                                                fontSize: 14.0,
                                                color: Colors.lightBlue,
                                              ),
                                            )),
                                    Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        child: Text(
                                          snapshot.data![contextIndex]
                                              .delvryCustcdate!,
                                          style: GoogleFonts.adamina(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                          ),
                                        )),
                                    Container(
                                      alignment: Alignment.center,
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 22.0),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "C",
                                                  style: GoogleFonts.adamina(
                                                      fontSize: 14.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    cf.toString() + " " + "ltr",
                                                    style: GoogleFonts.adamina(
                                                        fontSize: 14.0,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 22.0),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "B",
                                                  style: GoogleFonts.adamina(
                                                      fontSize: 14.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    bf.toString() + " " + "ltr",
                                                    style: GoogleFonts.adamina(
                                                        fontSize: 14.0,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
