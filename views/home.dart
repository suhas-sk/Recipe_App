import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/secret.dart';
import 'package:recipe_app/views/recipe_view.dart';
import 'package:recipe_app/widgets/widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipies = new List();
  String ingridients;
  bool _loading = false;
  String query = "";
  TextEditingController textEditingController = new TextEditingController();

  void getRecipes() async {
  if (textEditingController.text.isNotEmpty) {
    setState(() {
      _loading = true;
    });
    recipies = new List();
    String url =
        "https://api.edamam.com/search?q=${textEditingController.text}&app_id=$apiId&app_key=$apikey";
    var response = await http.get(url);
    print(" $response this is response");
    Map<String, dynamic> jsonData =
        jsonDecode(response.body);
    print("this is json Data $jsonData");
    jsonData["hits"].forEach((element) {
      print(element.toString());
      RecipeModel recipeModel = new RecipeModel();
      recipeModel =
          RecipeModel.fromMap(element['recipe']);
      recipies.add(recipeModel);
      print(recipeModel.url);
    });
    setState(() {
      _loading = false;
    });

    print("doing it");
  } else {
    print("not doing it");
  }
}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [const Color(0xff213A50), const Color(0xff071930)],
                    begin: FractionalOffset.topRight,
                    end: FractionalOffset.bottomLeft)),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: !kIsWeb
                      ? Platform.isIOS  ? 60 : 30 : 30, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomAppBar(),
                  SizedBox(
                    height: 40,
                  ),
                  IntroWidget(),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 1.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter Ingredients",
                              hintStyle: GoogleFonts.nunito(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        InkWell(
                            onTap: getRecipes,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                      colors: [
                                        const Color(0xffA2834D),
                                        const Color(0xffBC9A5F)
                                      ],
                                      begin: FractionalOffset.topRight,
                                      end: FractionalOffset.bottomLeft)),
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.search,
                                      size: 24, color: Colors.white),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: GridView(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          //childAspectRatio: 0.9,
                          mainAxisSpacing: 15.0,
                          crossAxisSpacing: 15.0,                          
                        maxCrossAxisExtent: 200.0),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        children: List.generate(recipies.length, (index) {
                        return GridTile(
                            child: RecipieTile(
                            title: recipies[index].label,
                            imgUrl: recipies[index].image,
                            desc: recipies[index].source,
                            url: recipies[index].url,
                          ));
                        })),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RecipieTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipieTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
    if (kIsWeb) {
      _launchURL(widget.url);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RecipeView(
                    postUrl: widget.url,
                  )));
    }
        },
        child: Container(
    //margin: EdgeInsets.all(8),    
    child: Stack(
      children: <Widget>[
        Image.network(                
          widget.imgUrl,
          height: 200,
          width: 200,
          fit: BoxFit.cover,
        ),
        Container(
          width: 200,
          height: 60,
          //alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white30, Colors.white],
                  begin: FractionalOffset.centerRight,
                  end: FractionalOffset.centerLeft)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title,
                  style: GoogleFonts.rubik(
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.normal,
                  ),
                  maxLines: 2,
                ),
                Text(
                  widget.desc,
                  style: GoogleFonts.rubik(
                    fontSize: 10,
                    color: Colors.black87,
                    fontWeight: FontWeight.normal,
                  ),
                  maxLines: 1,
                )
              ],
            ),
          ),
        )
      ],
    ),
        ),
      );
  }
}
