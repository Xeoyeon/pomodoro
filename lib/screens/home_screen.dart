import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 1500;
  int totalSeconds = twentyFiveMinutes; // 시간 간격 : 1500초 (25분)
  int totalPomodoros = 0; //총 pomodoro를 실행한 횟수
  Timer? timer; // Nullable 타입으로 변경
  bool isRunning = false;
  bool onReset = false;

  void onTick(Timer timer) {
    //매 timestamp마다 읽는 함수. 여기서는 duration이 1이므로, 1초마다 읽는다
    if (totalSeconds == 0  ) {
      setState(() {
        totalPomodoros = totalPomodoros + 1;
        isRunning = false;
        totalSeconds = twentyFiveMinutes;
        timer.cancel();
      });
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onStartPressed() {
    if (timer == null || !timer!.isActive) {
      timer = Timer.periodic(const Duration(seconds: 1), onTick);
      setState(() {
        isRunning = true;
      });
    }
  }

  void onPausePressed() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
      setState(() {
        isRunning = false;
      });
    }
  }

  void onResetPressed() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
      setState(() {
        isRunning = false;
        onReset = true;
        totalSeconds = twentyFiveMinutes;
      });
    }
  }

  String format(int seconds) {
    var duration = Duration(
        seconds: seconds); //우리가 원하는 시간' 00 : 00'의 형태로 보여주고 싶다 => Duration클래스 이용

    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                format(totalSeconds),
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).cardColor,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 98,
                    color: Theme.of(context).cardColor,
                    onPressed: isRunning ? onPausePressed : onStartPressed,
                    icon: Icon(
                      isRunning
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline,
                    ),
                  ),
                  IconButton(
                    iconSize: 30,
                    color: Theme.of(context).cardColor,
                    onPressed: onResetPressed,
                    icon: const Icon(
                      Icons.restore_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodoros',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                        Text(
                          '$totalPomodoros',
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
