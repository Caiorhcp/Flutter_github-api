import 'package:dio/dio.dart';
import 'package:my_ext/models/project_model.dart';

Future<List<Project>> getProjects(String username) async {
  final dio = Dio();
  final Response response = await dio.get(
    'https://api.github.com/users/$username/repos',
  );
  final List<Project> projects = (response.data as List)
      .map((value) => Project.fromMap(value as Map<String, dynamic>))
      .toList();
  return projects;
}
