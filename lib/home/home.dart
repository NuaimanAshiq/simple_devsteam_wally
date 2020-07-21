import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:unsplash/home/app_bar.dart';
import 'package:unsplash/home/image_view.dart';

import 'data.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _keyword = '';
  Timer _debounce;
  List<Results> _data = [];

  onChangeText(text) {
    _keyword = text;
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () async {
      var data = await fetchData(_keyword);
      setState(() {
        _data = data.results;
      });
    });
  }

  Future<Data> fetchData(keyword) async {
    var url =
        'https://unsplash.com/napi/search/photos?query=$keyword&xp=&per_page=50&page=1';
    var responseApi = await http.get(url);
    if (responseApi.statusCode == 200) {
      var resJSON = json.decode(responseApi.body);
      var data = Data.fromJson(resJSON);
      return data;
    } else {
      print('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: AppBarr(),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: TextField(
                onChanged: onChangeText,
                decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Visibility(
              visible: _data.length > 0,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0),
                    itemCount: _data.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageView(
                                    Image.network(_data[index].urls.small),
                                  ),
                                ),
                              );
                            },
                            child: Image.network(_data[index].urls.small),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
