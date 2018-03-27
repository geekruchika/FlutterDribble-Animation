import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'styles.dart';

import '../../Components/Calender.dart';

import 'package:flutter/animation.dart';
import 'dart:async';
import '../../Components/ListViewContainer.dart';
import '../../Components/AddButton.dart';
import '../../Components/HomeTopView.dart';
import '../../Components/FadeContainer.dart';
import 'homeAnimation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // DataListBuilder dataListBuilder = new DataListBuilder();
  ScrollController scroll;
  Animation<double> containerGrowAnimation;
  AnimationController _screenController;
  AnimationController _buttonController;
  Animation<double> buttonGrowAnimation;
  Animation<double> listTileWidth;
  Animation<Alignment> listSlideAnimation;
  Animation<EdgeInsets> listSlidePosition;
  Animation<Color> fadeScreenAnimation;
  var animateStatus = 0;
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
    scroll =
        new ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

    scroll.addListener(() {
      // print(scroll);
      // if (scroll.offset < 0) {
      //   // scroll.offset=0.0;

      // }
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
      begin: 1200.0,
      end: 500.0,
    )
        .animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.225,
          0.600,
          curve: Curves.bounceInOut,
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
          curve: Curves.bounceOut,
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

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.5;
    return (new Scaffold(
        body: new Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        new ListView.builder(
          shrinkWrap: _screenController.value < 1 ? false : true,
          controller: scroll,
          addAutomaticKeepAlives: false,
          padding: new EdgeInsets.all(0.0),
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0)
              return new ImageBackground(
                backgroundImage: backgroundImage,
                containerGrowAnimation: containerGrowAnimation,
                profileImage: profileImage,
                month: month,
                selectbackward: _selectbackward,
                selectforward: _selectforward,
              );
            else if (index == 1)
              return new Calender();
            else {
              return new ListViewContent(
                listSlideAnimation: listSlideAnimation,
                listSlidePosition: listSlidePosition,
                listTileWidth: listTileWidth,
              );
              // return new ListData(
              //   index: index,
              // );
            }
          },
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
            : new StaggerAnimation(buttonController: _buttonController.view),
      ],
    )));
  }
}
