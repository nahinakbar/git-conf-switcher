import 'dart:io';
import "dart:convert";

Map<String, String> envVars = Platform.environment;
final confDir = '${envVars["HOME"]}/.config/git-ids';
Future<void> printConfigList() async {
  final filelist = await getConfigList();
  if (filelist.isNotEmpty) {
    print(
        '${filelist.length} config${filelist.length > 1 ? 's' : ''} available');
  }
  if (filelist.isEmpty) {
    print("no configs available");
    return;
  }
  for (var i = 0; i < filelist.length; i++) {
    print(filelist[i]);
  }
}

Future<void> doSwitch(String? str) async {
  if (str?.length == null) return;
  if (!await isGitRepo()) {
    print("not a git repo");
    return;
  }
  List optList = await getConfigList();
  if (optList.contains(str)) {
    print('Config chosen: $str');
    Map config = jsonDecode(await File('$confDir/$str.json').readAsString());
    if (config.containsKey('name') && config.containsKey('email')) {
      var result =
          await Process.run('git', ['config', 'user.name', config["name"]]);
      var result2 =
          await Process.run('git', ['config', 'user.email', config["email"]]);
      if (result.exitCode + result2.exitCode > 0) {
        print("operation failed");
        return;
      }
      print('Switched to $str');
    }
    return;
  }
  print('This configuration doesn\'t exist');
}

Future<List> getConfigList() async {
  final ct = CheckType<File>();
  final dir = Directory('${envVars["HOME"]}/.config/git-ids');
  if (!await dir.exists()) {
    await Directory(confDir).create(recursive: true);
  }
  final List<FileSystemEntity> entities = await dir.list().toList();
  final List<FileSystemEntity> filelist =
      List<FileSystemEntity>.from(entities.where(ct.isT)).toList();
  final List<String> conflist = filelist
      .map((fileInstance) =>
          fileInstance.path.replaceAll('$confDir/', '').replaceAll('.json', ''))
      .toList();
  return conflist;
}

void showHelp(help) {
  if (help) {
    print('Place the config file in $confDir');
    print(
        'The file has to be a .json file. The content of the file has to be like the following: ');
    print(
        "{\r\n    \"email\" : \"71415182+nahin-web@users.noreply.github.com\",\r\n    \"name\" : \"Nahin AKbar\"\r\n}");
  }
}

Future<void> getConf() async {
  var result = await Process.run('git', ['config', 'user.name']);
  var result2 = await Process.run('git', ['config', 'user.email']);
  if (result.exitCode + result2.exitCode > 0) {
    print("there was an error");
  }
  print(
      'Current User Name: ${result.stdout.toString().replaceAll(RegExp(r'\n'), '')}');
  print(
      'Current User Email: ${result2.stdout.toString().replaceAll(RegExp(r'\n'), '')}');
}

Future<bool> isGitRepo() async {
  final dir = Directory('./.git');
  return dir.exists();
}

class CheckType<T> {
  bool isT(dynamic v) => v is T;
}
