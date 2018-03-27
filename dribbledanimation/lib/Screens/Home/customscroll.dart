import 'package:flutter/material.dart';
import 'styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import '../../Components/ListViewContainer.dart';
import '../../Components/AddButton.dart';
import '../../Components/HomeTopView.dart';
import '../../Components/FadeContainer.dart';
import 'homeAnimation.dart';
import 'package:intl/intl.dart';
import '../../Components/Calender.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;
  ScrollController scroll;
  AnimationController topImageController;
  Animation<double> appbarHeight;
  Animation<double> containerGrowAnimation;
  AnimationController _screenController;
  AnimationController _buttonController;
  Animation<double> buttonGrowAnimation;
  Animation<double> listTileWidth;
  Animation<Alignment> listSlideAnimation;
  Animation<Alignment> buttonSwingAnimation;
  Animation<EdgeInsets> listSlidePosition;
  Animation<Color> fadeScreenAnimation;

  var animateStatus = 0;
  String title = "";
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  String month = new DateFormat.MMMM().format(
    new DateTime.now(),
  );
  int index = new DateTime.now().month;
  void _selectforward() {
    if (index < 12)
      setState(() {
        ++index;
        month = months[index - 1];
      });
  }

  void _selectbackward() {
    if (index > 1)
      setState(() {
        --index;
        month = months[index - 1];
      });
  }

  @override
  void initState() {
    super.initState();
    _screenController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    _buttonController = new AnimationController(
        duration: new Duration(milliseconds: 1500), vsync: this);

    topImageController = new AnimationController(
        duration: new Duration(milliseconds: 800), vsync: this);

    scroll =
        new ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    appbarHeight = new Tween<double>(
      begin: 256.0,
      end: 350.0,
    )
        .animate(
      new CurvedAnimation(
        parent: topImageController,
        curve: Curves.ease,
      ),
    );
    scroll.addListener(() {
      print(scroll.offset);
      if (scroll.offset > 100)
        title = "List to do";
      else
        title = "";
      if (scroll.offset < 0) {
        appbarHeight.addListener(() {
          this.setState(() {});
        });
        topImageController.forward();
      } else
        topImageController.reset();
    });

    fadeScreenAnimation = new ColorTween(
      begin: const Color.fromRGBO(247, 64, 106, 1.0),
      end: const Color.fromRGBO(247, 64, 106, 0.0),
    )
        .animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: Curves.ease,
      ),
    );
    containerGrowAnimation = new CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeIn,
    );

    buttonGrowAnimation = new CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOut,
    );
    containerGrowAnimation.addListener(() {
      this.setState(() {});
    });
    containerGrowAnimation.addStatusListener((AnimationStatus status) {});

    listTileWidth = new Tween<double>(
      begin: 1000.0,
      end: 600.0,
    )
        .animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.225,
          0.600,
          curve: Curves.bounceIn,
        ),
      ),
    );

    listSlideAnimation = new AlignmentTween(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    )
        .animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.325,
          0.500,
          curve: Curves.ease,
        ),
      ),
    );
    buttonSwingAnimation = new AlignmentTween(
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
    )
        .animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.225,
          0.600,
          curve: Curves.ease,
        ),
      ),
    );
    listSlidePosition = new EdgeInsetsTween(
      begin: const EdgeInsets.only(bottom: 16.0),
      end: const EdgeInsets.only(bottom: 80.0),
    )
        .animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.325,
          0.800,
          curve: Curves.ease,
        ),
      ),
    );
    _screenController.forward();
  }

  @override
  void dispose() {
    _screenController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  }

  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.3;

    return new Theme(
      data: new ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromRGBO(247, 64, 106, 1.0),
        platform: Theme.of(context).platform,
      ),
      child: new Scaffold(
          key: _scaffoldKey,
          body: new Stack(alignment: Alignment.bottomRight, children: <Widget>[
            new CustomScrollView(
              // shrinkWrap: true,
              //primary: false,
              controller: scroll,
              slivers: <Widget>[
                new SliverAppBar(
                  elevation: 0.0,
                  forceElevated: true,
                  automaticallyImplyLeading: false,
                  expandedHeight: topImageController.value > 0
                      ? appbarHeight.value
                      : _appBarHeight,
                  pinned: _appBarBehavior == AppBarBehavior.pinned,
                  floating: _appBarBehavior == AppBarBehavior.floating ||
                      _appBarBehavior == AppBarBehavior.snapping,
                  snap: _appBarBehavior == AppBarBehavior.snapping,
                  flexibleSpace: new FlexibleSpaceBar(
                    title: new Text(title),
                    background: new Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        new ImageBackground(
                          backgroundImage: backgroundImage,
                          containerGrowAnimation: containerGrowAnimation,
                          profileImage: profileImage,
                          month: month,
                          selectbackward: _selectbackward,
                          selectforward: _selectforward,
                        ),
                      ],
                    ),
                  ),
                ),
                new SliverList(
                  delegate: new SliverChildListDelegate(<Widget>[
                    new Calender(),
                    new ListViewContent(
                      listSlideAnimation: listSlideAnimation,
                      listSlidePosition: listSlidePosition,
                      listTileWidth: listTileWidth,
                    ),
                  ]),
                ),
              ],
            ),
            new FadeBox(
              fadeScreenAnimation: fadeScreenAnimation,
              containerGrowAnimation: containerGrowAnimation,
            ),
            animateStatus == 0
                ? new Padding(
                    padding: new EdgeInsets.all(20.0),
                    child: new InkWell(
                        splashColor: Colors.white,
                        highlightColor: Colors.white,
                        onTap: () {
                          setState(() {
                            animateStatus = 1;
                          });
                          _playAnimation();
                        },
                        child: new AddButton(
                          buttonGrowAnimation: buttonGrowAnimation,
                        )))
                : new StaggerAnimation(
                    buttonController: _buttonController.view),
          ])),
    );
  }
}
