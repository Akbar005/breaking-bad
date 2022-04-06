import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';
import '../../models/models.dart';
import '../../mq.dart';
import '../details_screen/details_screen.dart';
import '../loader_screen.dart';
import 'package:http/http.dart' as http;

class CenemaScreen extends StatefulWidget {
  const CenemaScreen({
    Key key,
  }) : super(key: key);

  @override
  _CenemaScreenState createState() => _CenemaScreenState();
}

class _CenemaScreenState extends State<CenemaScreen>
    with SingleTickerProviderStateMixin {
  List<Bbad> _items;
  bool isLoading = false;
  bool _isLoadMoreRunning = false;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });
    await readJson();
    _controller = ScrollController()..addListener(_loadMore);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  void _loadMore() async {
    if (isLoading == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      try {
        var res = await http.get(Uri.parse(
            'https://breakingbadapi.com/api/characters?limit=10&offset=${_items.length}'));

        Iterable data = await json.decode(res.body);
        if (data != null) {
          _items.addAll(data.map((e) => Bbad.fromJson(e)).toList());
        } else {
          setState(() {});
        }
      } catch (err) {
        if (err.toString().contains('SocketException')) {
          return;
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  Future<void> readJson() async {
    var response = await http.get(Uri.parse(
        'https://breakingbadapi.com/api/characters?limit=10&offset=0'));
    Iterable data = await json.decode(response.body);
    _items = [];
    if (data != null) {
      _items = data.map((e) => Bbad.fromJson(e)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    MQuery().init(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Breaking Bad'),
        ),
        body: isLoading == true
            ? const LoaderScreen()
            : Stack(children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    searchFeild(),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    _buildSectiontitle('Actors', () {}),
                    exclusiveOffers(),
                    if (_isLoadMoreRunning == true)
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 40),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
              ]));
  }

  Widget _buildSectiontitle(String title, [Function onTap]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: kTitleStyle.copyWith(fontSize: 18),
          ),
          InkWell(
            onTap: onTap ?? () {},
            child: Text(
              'See all',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget exclusiveOffers() {
    return Expanded(
        child: ListView.separated(
      // physics: NeverScrollableScrollPhysics(),
      // shrinkWrap: true,
      controller: _controller,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      scrollDirection: Axis.vertical,
      itemCount: _items.length,
      itemBuilder: (_, i) => breakingBadItem(_items[i]),
      separatorBuilder: (_, __) => const SizedBox(width: 10),
    ));
  }

  breakingBadItem(Bbad item) {
    return InkWell(
      onTap: (() {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => DetailsScreen(item: item)));
      }),
      child: Card(
        child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailText("Name: ", item.name),
                    const SizedBox(
                      height: 5,
                    ),
                    detailText("Status:", item.status),
                    const SizedBox(
                      height: 5,
                    ),
                    detailText("Birthday:", item.birthday)
                  ],
                )),
                Expanded(child: Image.network(item.img)),
              ],
            )),
      ),
    );
  }

  detailText(String title, String value) {
    return Text.rich(
      TextSpan(
        text: '', // default text style
        children: <TextSpan>[
          TextSpan(
            text: title,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black38,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Allison',
              fontSize: 16,
              color: Colors.lightGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget searchFeild() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 40,
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search...',
          prefixIcon: Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
