import 'package:drift/drift.dart' as Drift;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../model/db/plan_db.dart';

class AddPlanScreen extends StatefulWidget {
  const AddPlanScreen({Key? key}) : super(key: key);

  @override
  _AddPlanScreenState createState() => _AddPlanScreenState();
}

DateTime roundToNearestFifteen(DateTime dateTime) {
  final int minute = dateTime.minute;
  final int remainder = minute % 15;
  if (remainder >= 8) {
    return dateTime.add(Duration(minutes: 15 - remainder));
  } else {
    return dateTime.subtract(Duration(minutes: remainder));
  }
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();
  DateTime _startDateTime = roundToNearestFifteen(DateTime.now());
  DateTime _endDateTime = roundToNearestFifteen(DateTime.now());
  DateTime selectDate = roundToNearestFifteen(DateTime.now());
  bool _active = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // リスナーを追加して、テキストフィールドの内容が変更されるたびに状態を更新するようにします。
    _titleController.addListener(_updateSaveButtonState);
    _commentController.addListener(_updateSaveButtonState);
  }

  // テキストフィールドの内容に基づいて保存ボタンの状態を更新する関数を追加
  void _updateSaveButtonState() {
    setState(() {
      _isButtonEnabled = _titleController.text.isNotEmpty && _commentController.text.isNotEmpty;
    });
  }


  @override
  void dispose() {
    _titleController.removeListener(_updateSaveButtonState);
    _commentController.removeListener(_updateSaveButtonState);
    _titleController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _savePlan() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Save to database
      var database = MyDatabase();
      var plan = PlanItemCompanion(
        title: Drift.Value(_titleController.text),
        comment: Drift.Value(_commentController.text),
        startDate: Drift.Value(_startDateTime),
        endDate: Drift.Value(_endDateTime),
      );
      await database.writePlan(plan);

      Navigator.of(context).pop();
    }
  }

  void _changeSwitch(bool e) => setState(() => _active = e);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
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
                // isEnabledがtrueである場合にだけ_savePlanを実行するように変更
                onPressed: _isButtonEnabled ? _savePlan : null,
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
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'タイトルを入力してください';
                  }
                  return null;
                },
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
                              activeColor: Colors.blue,
                              activeTrackColor: Colors.blueAccent,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey,
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
                            GestureDetector(
                              onTap: () async {
                                final DateTime? selectedDate = await showCupertinoModalPopup(
                                  context: context,
                                  builder: (_) => Container(
                                    height: MediaQuery.of(context).size.height / 3,
                                    color: CupertinoColors.white,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 60,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              CupertinoButton(
                                                child: Text('Cancel'),
                                                onPressed: () => Navigator.of(context).pop(),
                                              ),
                                              CupertinoButton(
                                                child: Text('OK'),
                                                onPressed: () => Navigator.of(context).pop(selectDate),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 220, // CupertinoDatePicker has an intrinsic height of 216.0
                                          child: CupertinoDatePicker(
                                            initialDateTime: selectDate,
                                            mode: CupertinoDatePickerMode.dateAndTime,
                                            minuteInterval: 15,
                                            onDateTimeChanged: (dateTime) {
                                              setState(() => selectDate = dateTime);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                if (selectedDate != null) {
                                  setState(() => _startDateTime = selectedDate);
                                }
                              },
                              child: Text(
                                DateFormat('yyyy-MM-dd HH:mm').format(_startDateTime),
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
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
                            GestureDetector(
                              onTap: () async {
                                final DateTime? selectedDate = await showCupertinoModalPopup(
                                  context: context,
                                  builder: (_) => Container(
                                    height: MediaQuery.of(context).size.height / 3,
                                    color: CupertinoColors.white,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 60,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              CupertinoButton(
                                                child: Text('Cancel'),
                                                onPressed: () => Navigator.of(context).pop(),
                                              ),
                                              CupertinoButton(
                                                child: Text('OK'),
                                                onPressed: () => Navigator.of(context).pop(selectDate),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 220, // CupertinoDatePicker has an intrinsic height of 216.0
                                          child: CupertinoDatePicker(
                                            initialDateTime: selectDate,
                                            mode: CupertinoDatePickerMode.dateAndTime,
                                            minuteInterval: 15,
                                            onDateTimeChanged: (dateTime) {
                                              setState(() => selectDate = dateTime);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                if (selectedDate != null) {
                                  setState(() => _endDateTime = selectedDate);
                                }
                              },
                              child: Text(
                                DateFormat('yyyy-MM-dd HH:mm').format(_endDateTime),
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
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
                  controller: _commentController,
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
      ),
    );
  }
}
