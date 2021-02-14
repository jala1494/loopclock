import 'package:flutter/material.dart';
import 'package:looploop/Home/home_screen.dart';
import 'package:looploop/constant.dart';
import 'package:looploop/time.dart';
import 'dart:async';
import '../time.dart';

// ignore: must_be_immutable
class Run extends StatefulWidget {
  final Time init;
  Time run;
  Run(this.init, this.run);

  @override
  _RunState createState() => _RunState();
}

class _RunState extends State<Run> {
  Color screenColor;
  Timer _timer;
  int s = 0;
  Widget toStr(int a) {
    int k = a ~/ 60;
    int s = a % 60;
    String min = k.floor().toString().padLeft(2, '0');
    String sec = s.floor().toString().padLeft(2, '0');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 3,
          child: Text(
            min,
            style: textStyle(),
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 3,
          child: Text(
            sec,
            style: textStyle(),
          ),
        ),
      ],
    );
  }

  TextStyle textStyle() {
    return TextStyle(
        fontSize: MediaQuery.of(context).size.height / 10,
        fontWeight: FontWeight.bold);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initState() {
    _startTimer();
    super.initState();
  }

  bool start = true;
  bool _isrest = false;
  // ignore: unused_field
  bool _isrunning = true;
  Future _startTimer() async {
    widget.run.works = widget.init.works;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted)
        setState(() {
          if (start) {
            if (widget.run.times > 0) {
              if (widget.run.works > 0) {
                if (_isrest == true) {
                  _isrest = false;
                }
                widget.run.works--;
                s++;
              }
              if (widget.run.works == 0) {
                if (widget.run.rests == 0) {
                  widget.run.times--;
                  _isrest = false;
                  widget.run.works = widget.init.works;
                  widget.run.rests = widget.init.rests;
                } else {
                  if (_isrest == false) {
                    _isrest = true;
                  }
                  widget.run.rests--;
                }
              }
            }
            if (widget.run.times == 1) {
              if (widget.run.works == 0) {
                {
                  start = false;
                  _isrunning = false;
                  widget.run = Time(0, 0, 0);
                  _timer.cancel();
                }
              }
            }
          }
        });
    });
  }

  void _unpauseTimer() => _startTimer();
  @override
  Widget build(BuildContext context) {
    return (_isrunning)
        ? Scaffold(
            backgroundColor: (_isrest) ? kgreenColor : kblueColor,
            appBar: AppBar(
              centerTitle: true,
              title: (_isrest)
                  ? Text(
                      'REST',
                    )
                  : Text(
                      'WORK',
                    ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                (_isrest) ? toStr(widget.run.rests) : toStr(widget.run.works),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ignore: deprecated_member_use
                    RaisedButton(
                        child: Icon(Icons.skip_next),
                        onPressed: () {
                          setState(() {
                            if (_isrest) {
                              widget.run.rests = 0;
                            } else {
                              widget.run.works = 0;
                            }
                          });
                        }),
                    SizedBox(
                      width: 20,
                    ),

                    TextButton(
                        child: Text('+20s'),
                        onPressed: () {
                          setState(() {
                            if (_isrest) {
                              widget.run.rests += 20;
                            } else {
                              widget.run.works += 20;
                            }
                          });
                        }),
                    // ignore: deprecated_member_use
                  ],
                ),
                Container(
                  child: Text(
                      (widget.init.times - widget.run.times + 1).toString() +
                          '/' +
                          widget.init.times.toString()),
                )
              ],
            ),
          )
        : Scaffold(
            body:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('FINSH'),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isrunning = true;
                    widget.run = Time(0, 0, 0);
                    _startTimer();
                  });
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('DONE'),
              )
            ])
          ]));
  }
}