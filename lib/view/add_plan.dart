import 'package:flutter/material.dart';

class AddPlanPage extends StatefulWidget {
  const AddPlanPage({Key? key}) : super(key: key);

  @override
  _AddPlanPageState createState() => _AddPlanPageState();
}

class _AddPlanPageState extends State<AddPlanPage> {
  bool _active = false;

  void _changeSwitch(bool e) => setState(() => _active = e);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('予定の追加'),
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {},
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
        ],
      ),
    );
  }
}
