import 'dart:async';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CountDownTimer(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentColor: Colors.red,
      ),
    );
  }
}

class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  late AnimationController controller;

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    return index == 0
        ? '00:30'
        : '0${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  AudioPlayer player = AudioPlayer();
  Future<void> playdata() async {
    await player.play(AssetSource('audio/countdown_tick.mp3'));

    setState(() {
      isplaying = false;
    });
  }

  bool soundenable = true;
  int index = 0;
  List textdata = [
    "Finish your meal",
    "Nom Nom :)",
    "Break Time",
    "Finish Your Meal"
  ];
  List textdat1 = [
    "It's simple: eat slowly for ten minutes, rest for five, then finish your meal",
    "You have 10 minutes to eat before the pause. Focus on eating slowly",
    "Take a five-minute break to check in on your level of fullness",
    "You can eat untill you feel full"
  ];
  bool isplaying = false;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30, microseconds: 0),
    )..addListener(() async {
        if (controller.value == 0 && index < 3) {
          controller.reverse(
              from: controller.value == 0.0 ? 1.0 : controller.value);
          setState(() {
            index = index + 1;
          });
        }
        Duration duration = controller.duration! * controller.value;
        if (duration.inSeconds < 6 &&
            duration.inSeconds >= 1 &&
            !(controller.status == PlayerState.playing) &&
            !isplaying) {
          setState(() {
            isplaying = true;
          });
          Timer(Duration(seconds: 1), () async {
            print(soundenable);
            if (soundenable) {
              await playdata();
            }
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(26, 23, 37, 1),
        leading: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Icon(Icons.arrow_back),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Mindful Meal Timer",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
          ],
        ),
        elevation: 4,
        leadingWidth: 300,
        shadowColor: Colors.white,
      ),
      backgroundColor: Color.fromRGBO(26, 23, 37, 1),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: index == 1 ? 13 : 10,
                    width: index == 1 ? 13 : 10,
                    decoration: BoxDecoration(
                        color: index == 1 ? Colors.white : Colors.grey[300],
                        shape: BoxShape.circle),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: index == 2 ? 13 : 10,
                    width: index == 2 ? 13 : 10,
                    decoration: BoxDecoration(
                        color: index == 2 ? Colors.white : Colors.grey[300],
                        shape: BoxShape.circle),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: index == 3 ? 13 : 10,
                    width: index == 3 ? 13 : 10,
                    decoration: BoxDecoration(
                        color: index == 3 ? Colors.white : Colors.grey[300],
                        shape: BoxShape.circle),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                textdata[index],
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: Text(
                  textdat1[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 2.5,
                child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      return Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Align(
                                    alignment: FractionalOffset.center,
                                    child: AspectRatio(
                                      aspectRatio: 1.0,
                                      child: Stack(
                                        children: <Widget>[
                                          Positioned.fill(
                                            child: CustomPaint(
                                                painter: CustomTimerPainter(
                                              animation: controller,
                                              backgroundColor: Colors.green,
                                              color: index == 0
                                                  ? Colors.green
                                                  : Colors.white,
                                            )),
                                          ),
                                          Positioned.fill(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CustomPaint(
                                                  painter: ClockDialPainter(
                                                      animation: controller,
                                                      index: index)),
                                            ),
                                          ),
                                          Align(
                                            alignment: FractionalOffset.center,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  timerString,
                                                  style: TextStyle(
                                                      fontSize: 40.0,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  "minutes remaining",
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
              ),
              Switch(
                onChanged: (bool sound) {
                  if (soundenable) {
                    soundenable = false;
                  } else {
                    isplaying = false;
                    soundenable = true;
                  }
                  setState(() {});
                  // setState(() {
                  //   soundenable = sound;
                  // });
                },
                value: soundenable,
                activeColor: Colors.green,
                activeTrackColor: Colors.green,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Color.fromRGBO(0, 0, 0, 0.1),
              ),
              Text(
                soundenable ? "Sond On" : "Sound Off",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 70,
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    if (index == 0) {
                      setState(() {
                        index = 1;
                      });
                      controller.reverse(
                          from:
                              controller.value == 0.0 ? 1.0 : controller.value);
                    } else {
                      if (controller.isAnimating)
                        controller.stop();
                      else {
                        controller.reverse(
                            from: controller.value == 0.0
                                ? 1.0
                                : controller.value);
                      }
                    }
                    setState(() {});
                  },
                  child: index == 0
                      ? Text(
                          "Start",
                          style: style,
                        )
                      : controller.isAnimating
                          ? Text(
                              "PAUSE",
                              style: style,
                            )
                          : Text(
                              "RESUME",
                              style: style,
                            ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(218, 238, 223, 1),
                      foregroundColor: Color.fromRGBO(26, 23, 37, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        //border radius equal to or more than 50% of width
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 70,
                width: 300,
                child: OutlinedButton(
                  onPressed: () {
                    controller.reset();
                    controller.stop();
                    setState(() {
                      index = 0;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    side: BorderSide(width: 1.0, color: Colors.white),
                  ),
                  child: Text(
                    "LET'S STOP I'M FULL NOW",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle style = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
}

class ClockDialPainter extends CustomPainter {
  final Animation<double> animation;
  final hourTickMarkLength = 15.0;
  final minuteTickMarkLength = 10.0;

  final hourTickMarkWidth = 4.0;
  final minuteTickMarkWidth = 2.5;

  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle textStyle;
  int index;
  ClockDialPainter({
    required this.animation,
    required this.index,
  })  : tickPaint = new Paint(),
        textPainter = new TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
        textStyle = TextStyle(
          color: Colors.grey[300]!,
          fontFamily: 'Times New Roman',
          fontSize: 15.0,
        ) {
    tickPaint.color = Colors.grey[300]!;
  }

  @override
  void paint(Canvas canvas, Size size) {
    size = Size(size.width - 80, size.height - 80);
    var tickMarkLength;
    final angle = 2 * (math.pi) / 60;
    final radius = (size.width) / 2;
    canvas.save();
    canvas.translate(radius + 40, radius + 40);
    for (var i = 0; i < 60; i++) {
      tickMarkLength = i % 15 == 0 ? hourTickMarkLength : minuteTickMarkLength;
      tickPaint.color = index == 0
          ? Colors.green
          : !(((1 - animation.value) * 2 * math.pi) * 9.6 <= (60 - i))
              ? Colors.grey[300]!
              : Colors.green;
      tickPaint.strokeWidth =
          i % 15 == 0 ? hourTickMarkWidth : minuteTickMarkWidth;
      canvas.drawLine(Offset(0.0, -radius),
          Offset(0.0, -radius + tickMarkLength), tickPaint);

      canvas.rotate(angle);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

enum ClockText { roman, arabic }

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    Paint paint1 = Paint()
      ..color = Colors.grey
      ..strokeWidth = 30.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    Paint paint2 = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        size.center(Offset.zero), size.shortestSide / 2.5, paint2);
    canvas.drawCircle(
        size.center(Offset.zero), (size.width - 60) / 2.0, paint1);
    canvas.drawCircle(size.center(Offset.zero), (size.width - 80) / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: (size.width - 80),
            height: (size.height - 80)),
        math.pi * 1.5,
        -progress,
        false,
        paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
