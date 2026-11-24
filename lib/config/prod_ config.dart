import 'package:Padres360/config/base_config.dart';

class ProdConfig implements BaseConfig {
  @override
  String get baseUrl => 'https://api.padres360.mx/';

  @override
  bool get reportErrors => true;

  @override
  bool get trackEvents => true;

}