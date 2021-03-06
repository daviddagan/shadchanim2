import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_app/models/person.dart';
import 'package:flutter_app/models/shadchan.dart';
import 'package:flutter_app/providers/langText.dart';
import 'package:flutter_app/providers/personProvider.dart';
import 'package:flutter_app/providers/staticFunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/compareThemList.dart';
import 'package:flutter_app/screens/profileInfo.dart';
import 'package:flutter_app/themes/colorManager.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'loader.dart';

class FavoritesCard extends StatelessWidget {
  final Person person;
  final Shadchan shadchan;
  final Function reset;
  FavoritesCard(this.person, this.shadchan, this.reset);
  @override
  Widget build(BuildContext context) {
    PersonProvider personProvider = Provider.of<PersonProvider>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileInfo(
                      person: person,
                      shadchan: shadchan,
                    )));
      },
      child: Card(
        child: Container(
          child: Row(
            children: <Widget>[
              // InkWell(
              //               child: Container(
              //     height: 60,
              //     width: 30,
              //     decoration: BoxDecoration(
              //       color: Colors.grey[200],//ColorManager().theme.filterBackgroundColor,
              //       borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(100),bottomLeft:Radius.circular(100)
              //   )),child: Icon(Icons.delete,size:20,color: Colors.grey[700] ,)),
              // ),
              Padding(
                padding: MyApp.getLocale() == "he" ? const EdgeInsets.only(right: 10) : const EdgeInsets.only(left: 10),
                child: InkWell(
                  onTap: () {
                    personProvider.removeFavorite(person.id);
                    reset();
                  },
                  child: Icon(
                    Icons.cancel,
                    size: 40,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Container(
                      width: 70,
                      height: 70,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: person.profileImages[0],
                          placeholder: (context, url) => Loader(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              person.firstName,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              " ,",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              StaticFunctions.getAge(person.birthday).toString(),
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(LocaleText.getLocaleSelectText(MyApp.getLocale(), person.country.toString())),
                            Icon(
                              Icons.location_on,
                              //color:Theme.of(context).primaryColor
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: MyApp.getLocale() == "he" ? const EdgeInsets.only(left: 10) : const EdgeInsets.only(right: 10),
                child: RaisedButton(
                  color: ColorManager().theme.secondary,
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new CompareThemList(person, shadchan)));
                  },
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          LocaleText.getLocaleText(MyApp.getLocale(), 'Compare'),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
