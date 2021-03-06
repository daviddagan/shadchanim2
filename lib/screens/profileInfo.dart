import 'dart:async';

import 'package:flutter_app/models/person.dart';
import 'package:flutter_app/models/shadchan.dart';
import 'package:flutter_app/providers/langText.dart';
import 'package:flutter_app/providers/personProvider.dart';
import 'package:flutter_app/providers/staticFunctions.dart';
import 'package:flutter_app/widgets/shadchanDialog.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_app/widgets/loader.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'compareThemList.dart';

class ProfileInfo extends StatefulWidget {
  Person person;
  Shadchan shadchan;
  final String shadchanId;
  final String personId;
  ProfileInfo({this.person, this.shadchan, this.personId, this.shadchanId});
  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  int topImage = 0;
  int _pos = 0;
  Timer _timer;
  bool isInit = true;
  bool isLoading = false;
  PersonProvider personProvider;
  @override
  void didChangeDependencies() {
    if (isInit) {
      isInit = false;
      List<Future> futures = [];
      personProvider = Provider.of<PersonProvider>(context);
      if (widget.person == null && widget.personId != null) {
        setState(() {
          isLoading = true;
        });
        futures.add(personProvider.getPersonById(widget.personId));
      }
      if (widget.shadchan == null && widget.shadchanId != null) {
        setState(() {
          isLoading = true;
        });
        futures.add(personProvider.shadchanProvider.getShadchanByID(widget.shadchanId));
      }
      Future.wait(futures).then((value) {
        if (value != null && value.length > 0) {
          widget.person = value[0];
        }
        if (value != null && value.length > 1) {
          widget.shadchan = value[1];
        }
        setState(() {
          isLoading = false;
        });
        if (widget.person != null && widget.person.profileImages != null && widget.personId != null) {
          _timer = Timer.periodic(new Duration(seconds: 3), (_timer) {
            setState(() {
              _pos = (_pos + 1) % widget.person.profileImages.length;
            });
          });
        }
      });
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    if (widget.person != null && widget.person.profileImages != null) {
      _timer = Timer.periodic(new Duration(seconds: 3), (_timer) {
        setState(() {
          _pos = (_pos + 1) % widget.person.profileImages.length;
        });
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: Opacity(
                            opacity: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      //colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.color),
                                      fit: BoxFit.cover,
                                      image: AssetImage("assets/images/road.jpg"))),
                              height: 200,
                              //color: Theme.of(context).accentColor
                            ),
                          ),
                        ),
                        // Positioned(
                        //   bottom: 20,
                        //   right: 20,
                        //   child: Container(
                        //     alignment: Alignment.center,
                        //     child: OutlineButton(
                        //       onPressed: () {
                        //         Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new CompareThemList(widget.person, widget.shadchan)));
                        //       },
                        //       child: Container(
                        //         child: Row(
                        //           children: <Widget>[
                        //             Text(
                        //               LocaleText.getLocaleText(MyApp.getLocale(), 'Compare'),
                        //               style: TextStyle(color: Theme.of(context).accentColor),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       shape: new RoundedRectangleBorder(
                        //         borderRadius: new BorderRadius.circular(30.0),
                        //       ),
                        //       borderSide: BorderSide(
                        //         color: Theme.of(context).accentColor, //Color of the border
                        //         style: BorderStyle.solid, //Style of the border
                        //         width: 1, //width of the border
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Positioned(
                            bottom: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  width: 145,
                                  height: 145,
                                  child: ClipOval(
                                      child: Hero(
                                    tag: 'imageHero' + widget.person.id.toString(),
                                    child: widget.person.profileImages != null
                                        ? //getMyImage()
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(150),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: widget.person.profileImages[_pos],
                                              placeholder: (context, url) => Loader(),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            ),
                                          )
                                        : Container(),
                                  )),
                                ),
                              ),
                            )),
                        Positioned(
                            top: 15,
                            left: 15,
                            child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => CustomDialog(
                                      shadchan: widget.shadchan,
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: "shadchanImage",
                                  child: Container(
                                    decoration: BoxDecoration(color: widget.shadchan.isOnline ? Colors.green[200] : Colors.red[300], shape: BoxShape.circle),
                                    padding: EdgeInsets.all(2),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: widget.shadchan.image,
                                          placeholder: (context, url) => Loader(),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))),
                        Positioned(
                          top: 20,
                          right: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.person.firstName,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "${StaticFunctions.getAge(widget.person.birthday)}",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // if(widget.person.area!=null)   Text(StaticFunctions.getArea(widget.person.area), style: TextStyle(fontSize: 18, color: Colors.white)),
                              if (widget.person.area != null)
                                Text(
                                  LocaleText.getLocaleSelectText(MyApp.getLocale(), widget.person.area.toString()),
                                  style: TextStyle(color: Colors.black54, fontSize: 16),
                                ),
                              if (widget.person.area != null)
                                Text(
                                  ", ",
                                  style: TextStyle(color: Colors.black54, fontSize: 16),
                                ),
                              Text(
                                LocaleText.getLocaleSelectText(MyApp.getLocale(), widget.person.country.toString()),
                                style: TextStyle(color: Colors.black54, fontSize: 16),
                              ),

                              SizedBox(width: 4),
                              Icon(
                                Icons.location_on,
                                color: Colors.black54,
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.person.short),
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                              Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                Text(LocaleText.getLocaleText(MyApp.getLocale(), 'Status'), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  LocaleText.getLocaleSelectText(MyApp.getLocale(), widget.person.status.toString()),
                                  style: TextStyle(color: Colors.black54),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(LocaleText.getLocaleText(MyApp.getLocale(), 'Hashkafa'), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Text(
                                  LocaleText.getLocaleSelectText(MyApp.getLocale(), widget.person.hashkafa.toString()),
                                  style: TextStyle(color: Colors.black54),
                                )
                              ]),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(LocaleText.getLocaleText(MyApp.getLocale(), 'Height'), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  Text(
                                    (widget.person.height.toString()),
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(LocaleText.getLocaleText(MyApp.getLocale(), 'Religious'), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  Text(
                                    LocaleText.getLocaleSelectText(MyApp.getLocale(), widget.person.dos.toString()),
                                    style: TextStyle(color: Colors.black54),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(LocaleText.getLocaleText(MyApp.getLocale(), 'Smoking'), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  Text(
                                    LocaleText.getLocaleSelectText(MyApp.getLocale(), widget.person.smoke.toString()),
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(LocaleText.getLocaleText(MyApp.getLocale(), 'Eda'), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  Text(
                                    LocaleText.getLocaleSelectText(MyApp.getLocale(), widget.person.eda.toString()),
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                          SizedBox(height: 30),
                          Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                Text(
                                  LocaleText.getLocaleText(MyApp.getLocale(), 'Who am I'),
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: 200,
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.black26,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(widget.person.long),
                                SizedBox(height: 40),
                                Text(
                                  LocaleText.getLocaleText(MyApp.getLocale(), 'What am I looking for'),
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: 200,
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.black26,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(widget.person.moreInfo),
                                SizedBox(height: 40),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          OutlineButton(
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new CompareThemList(widget.person, widget.shadchan)));
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              style: BorderStyle.solid,
              width: 3,
            ),
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  LocaleText.getLocaleText(MyApp.getLocale(), 'Compare'),
                  style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 15),
                )),
          ),
        ]),
      ),
    );
  }
}
