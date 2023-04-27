import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:outshade_assign/pages/detail_page.dart';
import 'package:outshade_assign/utils/sample_json.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _age;
  late TextEditingController _gender;

  final _dbBox = Hive.box('dataBox');

  @override
  void initState() {
    super.initState();
    _age = TextEditingController();
    _gender = TextEditingController();
    _age.addListener(() => setState(() {}));
    _gender.addListener(() => setState(() {}));
  }

  List<Map<String, dynamic>> items = [];

  void _refreshList() {
    final data = _dbBox.keys.map((key) {
      final item = _dbBox.get(key);
      return {
        "key": key,
        "id": item["id"],
        "age": item["data"]["age"],
        "gender": item["data"]["gender"]
      };
    }).toList();

    setState(() {
      items = data.reversed.toList();
    });
    print(items);
  }

  Future<void> _addData(int ind, int age, String gender) async {
    Map<String, dynamic> item = {
      "id": data[0]['users'][ind]['id'],
      "data": {"age": age, "gender": gender}
    };
    await _dbBox.add(item);
    _refreshList();
  }

  void _showDialogCustom(BuildContext ctx, int ind) {
    showModalBottomSheet(
      elevation: 10,
      context: ctx,
      builder: (_) => Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 50),
            TextFormField(
              controller: _age,
              decoration: const InputDecoration(
                hintText: "Enter your age",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Colors.purple, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _gender,
              decoration: const InputDecoration(
                hintText: "Enter your gender",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Colors.purple, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (!_ifExist(int.parse(data[0]['users'][ind]['id'])))
                  _addData(ind, int.parse(_age.text), _gender.text);
                _age.text = "";
                _gender.text = "";
                Navigator.of(context).pop();
                _refreshList();
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  bool _ifExist(int num) {
    for (int i = 0; i < items.length; i++) {
      if (int.parse(items[i]['id']) == num) return true;
    }
    return false;
  }

  int _returnKey(int num) {
    for (int i = 0; i < items.length; i++) {
      if (int.parse(items[i]['id']) == num) return items[i]['key'];
    }
    return -1;
  }

  void _deleteData(int id) async {
    int key = _returnKey(id);
    if (key >= 0) {
      await _dbBox.delete(key);
    }
    _refreshList();
  }

  Map<String, dynamic> _returnItem(int id) {
    for (int i = 0; i < items.length; i++) {
      if (int.parse(items[i]["id"]) == id) return items[i];
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double devHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(data[0]['users'].length, (index) {
            _refreshList();
            return InkWell(
              onTap: () {
                print(_ifExist(int.parse(data[0]['users'][index]['id'])));
                (_ifExist(int.parse(data[0]['users'][index]['id'])))
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            age: _returnItem(int.parse(
                                data[0]['users'][index]['id']))["age"],
                            gender: _returnItem(int.parse(
                                data[0]['users'][index]['id']))["gender"],
                            name: data[0]['users'][index]['name'],
                          ),
                        ),
                      )
                    : null;
              },
              child: ListTile(
                title: Text(data[0]['users'][index]['name']),
                trailing: TextButton(
                  onPressed: () {
                    (_ifExist(int.parse(data[0]['users'][index]['id'])))
                        ? _deleteData(int.parse(data[0]['users'][index]['id']))
                        : _showDialogCustom(context, index);
                  },
                  child: Text(
                    (_ifExist(int.parse(data[0]['users'][index]['id'])))
                        ? "Sign out"
                        : "Sign in",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.purple),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
