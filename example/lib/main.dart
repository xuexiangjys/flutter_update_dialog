import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_update_dialog/flutter_update_dialog.dart';

import 'toast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ToastUtils.init(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Update Dialog Demo Page'),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, //文本是起始端对齐
                    children: <Widget>[
                  ButtonBar(
                    alignment:
                        MainAxisAlignment.start, //布局方向，默认MainAxisAlignment.end
                    mainAxisSize: MainAxisSize.min, //主轴大小，默认MainAxisSize.max
                    children: <Widget>[
                      RaisedButton(
                        child: Text('默认样式'),
                        color: Theme.of(context).primaryColor,
                        onPressed: defaultStyle,
                      ),
                      RaisedButton(
                        child: Text('自定义样式'),
                        color: Theme.of(context).primaryColor,
                        onPressed: customStyle,
                      ),
                    ],
                  ),
                ])));
  }

  UpdateDialog dialog;

  double progress = 0.0;

  void onUpdate() {
    ToastUtils.success("开始升级...");
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      progress = progress + 0.02;
      if (progress > 1.0001) {
        timer.cancel();
        dialog.dismiss();
        progress = 0;
        ToastUtils.success("升级成功！");
      } else {
        dialog.update(progress);
      }
    });
  }

  void defaultStyle() {
    if (dialog != null && dialog.isShowing()) {
      return;
    }
    dialog = UpdateDialog.showUpdate(context,
        title: "是否升级到4.1.4版本？",
        updateContent: "新版本大小:2.0M\n1.xxxxxxx\n2.xxxxxxx\n3.xxxxxxx",
        onUpdate: onUpdate);
  }

  void customStyle() {
    if (dialog != null && dialog.isShowing()) {
      return;
    }
    dialog = UpdateDialog.showUpdate(context,
        width: 200,
        title: "是否升级到4.1.4版本？",
        updateContent: "新版本大小:2.0M\n1.xxxxxxx\n2.xxxxxxx\n3.xxxxxxx",
        topImage: Image.asset('assets/bg_update_top.png'),
        radius: 8,
        themeColor: Color(0xFFFFAC5D),
        progressBackgroundColor: Color(0x5AFFAC5D),
        isForce: true,
        enableIgnore: true, onIgnore: () {
          ToastUtils.waring("忽略");
          dialog.dismiss();
        },
        onUpdate: onUpdate);
  }
}
