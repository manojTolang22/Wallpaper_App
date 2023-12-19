import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'fullscreen.dart';

class Wallpaper extends StatefulWidget {
  @override
  _WallpaperState createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List images = [];
  int page = 1;

  @override
  void initState() {
    super.initState();
    fetchapi();
  }

  fetchapi() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              '9bgVwlXxEealjsDS0WydM5nkifWCTvbrqWgTfAsweNvcFvLXL3AZsX0A'
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
      print(images[0]);
    });
  }

  loadMore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          '9bgVwlXxEealjsDS0WydM5nkifWCTvbrqWgTfAsweNvcFvLXL3AZsX0A'
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: GridView.builder(
                    itemCount: images.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 2,
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3,
                        mainAxisSpacing: 2),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Fullscreen(
                                        imageurl: images[index]['src']
                                            ['large2x'],
                                      )));
                        },
                        child: Container(
                          color: Colors.white,
                          child: Image.network(
                            images[index]['src']['tiny'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
              ),
            ),
            InkWell(
              onTap: () {
                loadMore();
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black,
                  ),
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Text('Load More',
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
