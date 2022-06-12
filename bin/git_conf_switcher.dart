import 'package:args/args.dart';
import 'package:git_conf_switcher/git_conf_switcher.dart' as git_conf_switcher;

Future<void> main(List<String> arguments) async {
  var parser = ArgParser();
  parser.addFlag('list', callback: (list) {
    if (list) git_conf_switcher.printConfigList();
  });
  parser.addOption('switch', callback: git_conf_switcher.doSwitch);
  parser.addFlag('get-conf', callback: (getConf) {
    if (getConf) git_conf_switcher.getConf();
  });
  parser.addFlag('help', callback: git_conf_switcher.showHelp);
  try {
    if (arguments.isEmpty) return;
    parser.parse(arguments);
  } catch (e) {
    print("Please enter a valid option");
  }
  return;
}
