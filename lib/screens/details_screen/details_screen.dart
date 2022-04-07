import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';
import '../../models/bbad.dart';
import '../../mq.dart';
import '../loader_screen.dart';
import 'package:http/http.dart' as http;

class DetailsScreen extends StatefulWidget {
  final Bbad item;
  const DetailsScreen({Key key, this.item}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MQuery().init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.item.name),
        ),
        body: isLoading == true
            ? const LoaderScreen()
            : Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Profile Details:",
                      style: kTitleStyle.copyWith(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child: Image.network(widget.item.img)),
                    const SizedBox(
                      height: 20,
                    ),
                    // breakingBadItem(widget.item),
                    detailText("Name: ", widget.item.name),
                    detailText("NicKName: ", widget.item.nickname),
                    detailText("Birthday: ", widget.item.birthday),
                    detailText("Status: ", widget.item.status),
                    detailText("Portrayed: ", widget.item.portrayed),
                    detailText("Category: ", widget.item.category),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ));
  }

  detailText(String title, String value) {
    return Text.rich(
      TextSpan(
        text: '', // default text style
        children: <TextSpan>[
          TextSpan(
            text: title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black38,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontFamily: 'Allison',
              fontSize: 15,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  breakingBadItem(Bbad item) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${item.name}"),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("Status: ${item.status}"),
                  Text("Birthday: ${item.birthday}")
                ],
              )),
            ],
          )),
    );
  }
}
