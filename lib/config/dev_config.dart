import 'package:Padres360/config/base_config.dart';

class DevConfig implements BaseConfig {
  @override
  String get baseUrl => 'http://192.168.0.103:8000/';

  @override
  bool get reportErrors => false;

  @override
  bool get trackEvents => false;

}