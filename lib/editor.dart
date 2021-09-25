import 'dart:math';

import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/js.dart' as js;
import 'fake_ui.dart' if (dart.library.html) 'real_ui.dart' as ui;

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  late js.JsObject connector;
  String createdViewId = Random().nextInt(1000).toString();
  late html.IFrameElement element;
  String htmlText = """​<!DOCTYPE html>
<html>
<body>
<p>
This is the sample text from flutter.
</p>
<p>
Please subscribe to <strong>Breaking Code<strong> YT Channel.
</p>
</body>
</html>
""";

  @override
  void initState() {
    js.context["connect_content_to_flutter"] = (js.JsObject content) {
      connector = content;
    };
    element = html.IFrameElement()
      ..src = "/assets/editor.html"
      ..style.border = 'none';

    ui.platformViewRegistry
        .registerViewFactory(createdViewId, (int viewId) => element);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: getMessageFromEditor,
                    child: Text("GET MESSAGE FROM EDITOR")),
                ElevatedButton(
                    onPressed: () {
                      sendMessageToEditor(htmlText);
                    },
                    child: Text("SEND MESSAGE TO EDITOR"))
              ],
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 340,
              child: HtmlElementView(
                viewType: createdViewId,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getMessageFromEditor() {
    final String str = connector.callMethod(
      'getValue',
    ) as String;
    print(str);
  }

  void sendMessageToEditor(String data) {
    element.contentWindow!.postMessage({
      'id': 'value',
      'msg': data,
    }, "*");
  }
}
