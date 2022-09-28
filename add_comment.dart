import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bbtalk_app/common/constants.dart';
import 'package:http/http.dart' as http;

Future<bool> postComment(
    int id, String name, String email, String website, String comment) async {
  try {
    var response =
        await http.post(Uri.parse("$WORDPRESS_URL/wp-json/wp/v2/comments"), body: {
      "author_email": email.trim().toLowerCase(),
      "author_name": name,
      "author_website": website,
      "content": comment,
      "post": id.toString()
    });

    if (response.statusCode == 201) {
      return true;
    }
    return false;
  } catch (e) {
    throw Exception('Fehler beim Kommentieren');
  }
}

class AddComment extends StatefulWidget {
  final int commentId;

  AddComment(this.commentId, {Key? key}) : super(key: key);
  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  final _formKey = GlobalKey<FormState>();

  String _name = "";
  String _email = "";
  String _website = "";
  String _comment = "";

  @override
  Widget build(BuildContext context) {
    int commentId = widget.commentId;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('Kommentieren',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Poppins')),
          elevation: 5,
          backgroundColor: Colors.white,
        ),
        body: Builder(builder: (BuildContext context) {
          return Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: EdgeInsets.fromLTRB(24, 36, 24, 36),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Name *',
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Ihr Name';
                              }
                              return null;
                            },
                            onSaved: (String? val) {
                              _name = val.toString();
                            }),
                        TextFormField(
                            decoration: InputDecoration(
                              labelText: 'E-Mail *',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Ihre E-Mail Adresse';
                              }
                              return null;
                            },
                            onSaved: (String? val) {
                              _email = val.toString();
                            }),
                        TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Webseite',
                            ),
                            onSaved: (String? val) {
                              _website = val.toString();
                            }),
                        TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Kommentar *',
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Schreibe einen Kommentar';
                              }
                              return null;
                            },
                            onSaved: (String? val) {
                              _comment = val.toString();
                            }),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 36.0),
                          height: 120,
                          child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                postComment(commentId, _name, _email, _website,
                                        _comment)
                                    .then((back) {
                                  if (back) {
                                    Navigator.of(context).pop();
                                  } else {
                                    final snackBar = SnackBar(
                                        content: Text(
                                            'Fehler beim Kommentieren. '));
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                });
                              }
                            },
                            label: Text(
                              'Abschicken',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Text(
                          "Info: Nach der Freigabe erscheint Ihr Kommentar",
                          textAlign: TextAlign.center,
                        )
                      ],
                    ) // Build this out in the next steps.
                    ),
              ),
            ),
          );
        }));
  }
}
