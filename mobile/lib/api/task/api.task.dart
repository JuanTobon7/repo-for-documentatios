import 'package:mobile/api/conf/api.dart';
import 'package:mobile/models/task.dto.dart';

class ApiTask {
  final ApiClient apiClient;
  ApiTask(this.apiClient);
  static const String baseModuleUrl = '/tasks';

  Future<dynamic> getListTask(Map<String, dynamic> params) async {
    try {
      Map<String, dynamic> castedParams = new Map();
      castedParams['date'] = params['date'];
      if(params['status'].toString().isNotEmpty){
         castedParams['status'] = params['status'];
      }
      final response = await apiClient.dio.get('$baseModuleUrl',queryParameters: castedParams);
      if (response.statusCode != 200) {
        throw Exception('Failed to get ${params['date']}: ${response.statusCode}');
      }
      List<TaskDto> tasks = (response.data['data'] as List).map((item){
        return TaskDto.fromJson(item);
      }).toList();
      return tasks;
    } catch (e) {
      rethrow;
    }
  }


  Future<TaskDto> createTaskDto(Map<String, dynamic> dto) async {
    try {
      final response = await apiClient.dio.post('$baseModuleUrl', data: dto);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to register task: ${response.statusCode}');
      }
      final responseData = response.data['data'];
      TaskDto resTask = new TaskDto.fromJson(responseData);
      return resTask;
    } catch (e) {
      rethrow;
    }
  }

  Future<TaskDto> updateTaskDto(Map<String, dynamic> dto,String id) async {
    try {
      final response = await apiClient.dio.put('$baseModuleUrl/$id', data: dto);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to register task: ${response.statusCode}');
      }
      final responseData = response.data['data'];
      TaskDto resTask = new TaskDto.fromJson(responseData);
      return resTask;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTaskDto(String paramId) async {
    try{
      final response = await apiClient.dio.delete('$baseModuleUrl/$paramId');
      if(response.statusCode != 200){
        throw Exception('Failed to deleted task: $paramId');
      }
      return;
    }catch(e){
      rethrow;
    }

  }

  Future<void> updateDailyTask(String id,String date) async {
    try{
      await apiClient.dio.put('$baseModuleUrl/$id/daily-tasks/$date');
    }catch(e){
      rethrow;
    }
  }
  
}
