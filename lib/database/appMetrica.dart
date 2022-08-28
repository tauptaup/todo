import 'package:appmetrica_plugin/appmetrica_plugin.dart';

class AppMetricaReport {
  final apiKey = 'ff6dad69-d41b-4299-bcb2-a981d2378877';

  AppMetricaReport() {
    AppMetrica.activate(AppMetricaConfig(apiKey));
  }

  void addTaskReport() {
    AppMetrica.reportEvent('добавлено');
  }

  void deleteTaskReport() {
    AppMetrica.reportEvent('удалено');
  }

  void completeTaskReport() {
    AppMetrica.reportEvent('выполнено');
  }

  void transintionReport() {
    AppMetrica.reportEvent('переход');
  }
}
