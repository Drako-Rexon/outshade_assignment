import 'package:hive/hive.dart';
part 'details.g.dart';

@HiveType(typeId: 1)
class Details {
  Details({required this.age, required this.gender});
  @HiveField(0)
  int age;

  @HiveField(1)
  String gender;
}
