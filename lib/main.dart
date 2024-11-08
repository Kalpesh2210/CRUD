import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController textname = TextEditingController();
  List<String> myitems = [];
  bool addbtn = true;
  bool updatebtn = false;
  var fetch_index;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: textname,
            ),
            Visibility(
              visible: addbtn,
              child: ElevatedButton(
                  onPressed: () {
                    additem(textname.text);
                  },
                  child: Text('add data')),
            ),
            Visibility(
              visible: updatebtn,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      myitems[fetch_index] = textname.text;
                      savedata();
                    });
                    textname.text = '';
                    addbtn = true;
                    updatebtn = false;
                  },
                  child: Text('Update')),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: myitems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(myitems[index]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    myitems.removeAt(index);
                                    savedata();
                                  });
                                },
                                icon: Icon(Icons.delete)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    fetch_index = index;
                                    textname.text = myitems[index];
                                    addbtn = false;
                                    updatebtn = true;
                                  });
                                },
                                icon: Icon(Icons.edit))
                          ],
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  void savedata() async {
    var pref = await SharedPreferences.getInstance();
    pref.setString('name', json.encode(myitems));
  }

  void getdata() async {
    var pref = await SharedPreferences.getInstance();
    final String? storeitem = pref.getString('name');
    if (storeitem != null) {
      setState(() {
        myitems = List<String>.from(json.decode(storeitem));
      });
    }
  }

  void additem(String item) {
    setState(() {
      myitems.add(item);
      savedata();
    });
    textname.text = '';
  }
}
