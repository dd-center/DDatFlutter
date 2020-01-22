import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:web_socket_channel/status.dart' as status;
import 'package:dd_at_flutter/ResultModel.dart';
import 'package:dd_at_flutter/TaskModel.dart';
import 'package:dd_at_flutter/net/NetRequest.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

const interval = const Duration(milliseconds: 840);

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final title = 'DD @ Flutter';
    return MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
        channel: IOWebSocketChannel.connect('ws://cluster.vtbs.moe/?runtime=flutter&version=0.0.1&platform=Phone'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {

  final String title;
  final WebSocketChannel channel;

  MyHomePage({Key key, @required this.title, @required this.channel})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TaskModel taskModel;
  Timer timer;
  bool isTaskFetched = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {

                // getModel from data
                if (snapshot.data != null) {

                  taskModel = TaskModel.fromJson(json.decode(snapshot.data));
                  isTaskFetched = true;

                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                      snapshot.hasData ?
                      'Current: ${taskModel.data.url}' : 'Current: '
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {

    super.initState();

    timer = new Timer.periodic(interval, (Timer timer) {

      fetchTask();

      if (taskModel != null && isTaskFetched == true) {

        print("执行拉取的请求===========");
        execTask();

      }
      isTaskFetched = false;

    });
  }

  void fetchTask() async {

    widget.channel.sink.add("DDhttp");
    print("拉取请求=================");


  }

  void execTask() {

    String taskKey = "";

    if (taskModel.key != null) {
      taskKey = taskModel.key;
    }

    NetRequest.get(taskModel.data.url,
        onSuccess:(response) {

      ResultModel result = new ResultModel(key: taskKey,data: response);
      result.data = json.encode(result.data);
      String data = json.encode(result);
      widget.channel.sink.add(data);

      print(data);

      },
        onFailure:(error) {print(error);});
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    timer.cancel();
    super.dispose();
  }
}
