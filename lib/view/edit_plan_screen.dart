import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditPlanScreen extends StatefulWidget {
  const EditPlanScreen({Key? key}) : super(key: key);

  @override
  _EditPlanScreenState createState() =>
      _EditPlanScreenState();
}

class _EditPlanScreenState extends State<EditPlanScreen> {
  bool _active = false;

  void _changeSwitch(bool e) => setState(() => _active = e);

  void _showEditCanselConfirmation() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text('編集を破棄', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context, 'Delete');
              // ここに破棄のロジックを書く
            },
            isDestructiveAction: true,
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('キャンセル'),
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('予定の削除'),
          content: Text('本当にこの日の予定を削除しますか？'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('削除', style: TextStyle(color: Colors.blue)),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
                // ここで予定を削除する処理を追加する
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('予定の編集'),
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: _showEditCanselConfirmation,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0, bottom: 5),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              onPressed: () {},
              child: Text('保存'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              style: TextStyle(color: Colors.grey),
              decoration: InputDecoration(
                hintText: 'タイトルを入力してください',
                contentPadding: const EdgeInsets.only(left: 10),
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('終日'),
                          Switch(
                            value: _active,
                            activeColor: Colors.orange,
                            activeTrackColor: Colors.red,
                            inactiveThumbColor: Colors.blue,
                            inactiveTrackColor: Colors.green,
                            onChanged: _changeSwitch,
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('開始'),
                          const Text('開始日時を表示'),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('終了'),
                          const Text('終了日時を表示'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 200,
              width: 400,
              child: TextFormField(
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'コメントを入力してください',

                  contentPadding: const EdgeInsets.only(left: 10, top: 20, ),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: _showDeleteConfirmation,
              child: Container(
                width: double.infinity,
                height: 50,
                child: Center(child: Text('この予定を削除', style: TextStyle(color: Colors.red))),

              ),
            ),
          ),
        ],
      ),
    );
  }
}