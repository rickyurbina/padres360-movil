
import 'package:Padres360/Repository/constant_functions.dart';
import 'package:Padres360/Screens/Authentication/Sign%20In/Model/LogInResponseModel.dart';

class ChildrenRepository {
  Future<List<Student>> getChildrenByParent() async {
    await Future.delayed(const Duration(seconds: 2));
    final user = await UserService.getUser();

    return user.students;
  }
}
