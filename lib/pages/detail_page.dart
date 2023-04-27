import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage(
      {super.key, required this.age, required this.gender, required this.name});
  final int age;
  final String gender, name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ListTile(
              leading: Text("Age: "),
              trailing: Text(age.toString()),
            ),
            ListTile(
              leading: Text("Gender: "),
              trailing: Text(gender),
            )
          ],
        ),
      ),
    );
  }
}
