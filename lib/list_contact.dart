import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:phone_book/detail_contact.dart';
import 'package:phone_book/model/person.dart';
import 'package:rounded_letter/rounded_letter.dart';
import 'package:rounded_letter/shape_type.dart';

class ListContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final Person person = dataPersonList[index];
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DetailContact(person, index);
            }));
          },
          child: Card(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Hero(
                        tag: "avatar-$index",
                        child: imageContact(person),
                      ),
                    )),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, bottom: 4.0, right: 4.0, left: 4.0),
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${person.firstName} ${person.lastName}",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              person.phoneNumber,
                              style: TextStyle(fontSize: 16.0),
                            )
                          ],
                        ),
                      ),
                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(top:16.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.call,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        callNumber(context, person.phoneNumber);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: dataPersonList.length,
    );
  }

  void callNumber(BuildContext context, String number) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(
          number.replaceAll(new RegExp(r'[^0-9]'), ''));
    } catch (e) {
      showSnackbar(context, "Ada error $e");
    }
  }

  void showSnackbar(BuildContext context, String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("$value selected"),
      duration: Duration(seconds: 1),
    ));
  }

  Widget imageContact(Person person) {
    if (person.imageAsset == "") {
      var name = (person.lastName=="") ? "${person.firstName[0]}".toUpperCase():"${person.firstName[0]}${person.lastName[0]}".toUpperCase() ;
      return RoundedLetter(
        text: "$name",
        shapeColor: Color(0xFF1ECCE3),
        shapeType: ShapeType.circle,
        borderColor: Color(0xFF2AECEC),
        borderWidth: 1,
        shapeSize: 60,
        fontSize: 30,
        key: Key(person.firstName),
      );
    } else {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage(person.imageAsset), fit: BoxFit.fill),
        ),
      );
    }
  }
}
