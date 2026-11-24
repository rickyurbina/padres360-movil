import 'package:Padres360/config/base_config.dart';
import 'package:Padres360/config/dev_config.dart';
import 'package:Padres360/config/prod_%20config.dart';

class Environment {
  static final Environment _singleton = Environment._internal();

  factory Environment() => _singleton;

  Environment._internal();

  static const dev = "DEV";

  static const prod = "PROD";

  BaseConfig? config;

  initConfig(String environment){
  config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment){
    switch(environment){
      case Environment.dev:
        return DevConfig();
      case Environment.prod:
        return ProdConfig();
      default:
        return DevConfig();
    }
  }
}