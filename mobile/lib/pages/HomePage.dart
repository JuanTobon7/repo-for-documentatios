import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/api/task/api.task.dart';
import 'package:mobile/api/conf/api.dart';
import 'package:mobile/common/AddTaskDialog.dart';
import 'package:mobile/common/AlertError.dart';
import 'package:mobile/common/TaskEnum.dart';
import 'package:mobile/components/taskCard.dart';
import 'package:mobile/models/task.dto.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _messageError = '';
  String _dateStr = '';
  List<TaskDto>? tasks;
  bool _isLoading = true;
  DateTime _date = DateTime.now();
  bool _menuOpen = false;
  String _status = '';
  final ScrollController _scrollController = ScrollController();
  Set<TaskDto> _selectedTaks = {};
  ApiTask apiTask = ApiTask(ApiClient());

  String _formatDate(DateTime date) {
    final utcDate = DateTime.utc(date.year, date.month, date.day);
    return "${utcDate.year.toString().padLeft(4, '0')}-"
        "${utcDate.month.toString().padLeft(2, '0')}-"
        "${utcDate.day.toString().padLeft(2, '0')}";
  }


  Future<void> createTaskFun(String title, String description) async{
    try{
      if(title.isEmpty) return;
      final data = {
        'title': title,
        'description': description,
        'createdAt': DateTime.now().toIso8601String()
      };
      TaskDto taskRes = await apiTask.createTaskDto(data);
      setState((){
        if(taskRes.title.isEmpty || taskRes.description.isEmpty || taskRes.id.isEmpty ) return;
        tasks!.add(taskRes);
      });
      await _getList();
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeIn,
      );
    } on FormatException {
      AlertHelper.show('Datos Incompletos','Titulo no proporcionado');
    }
    catch(e){
      AlertHelper.show('un error inesperado a ocurrido','');
    }
  }

  bool afterDate(){
    String today = _formatDate(DateTime.now());
    return today.trim() != _dateStr.trim();
  }

  Future<void> updateDailyTask(String id) async {
    try{
      if(id.isEmpty) return AlertHelper.show('Datos Incompletos', 'No se especifico la tarea');

      if(afterDate()) return AlertHelper.show('Operación Invalida', 'No puede cambiar el estado de una tarea en una fecha distinta a la actual');

      await apiTask.updateDailyTask(id, _formatDate(DateTime.now()));
      await _getList();
    }catch(e){
      AlertHelper.show('un error inesperado a ocurrido','');
    }finally{
      await _getList();
    }
  }

  Future<void> updateTaskFun(String title, String description) async{
    try{
      if(title.isEmpty) return;
      if(_selectedTaks.isEmpty) return;
      final data = {
        'title': title,
        'description': description,
      };

      String id = _selectedTaks.first.id;
      TaskDto taskRes = await apiTask.updateTaskDto(data,id);
      setState((){
        if(taskRes.title.isEmpty || taskRes.description.isEmpty || taskRes.id.isEmpty ) return;
        tasks!.add(taskRes);
      });
      await _getList();
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeIn,
      );
    } on FormatException {
      AlertHelper.show('Datos Incompletos','Titulo no proporcionado');
    }
    catch(e){
      AlertHelper.show('un error inesperado a ocurrido','');
    }
  }

  @override
  void initState() {
    super.initState();
    _date = DateTime.now();
    _dateStr = _formatDate(_date);
    _getList();
  }

  Future<void> _getList() async {
    try {
      String status = _status;
      final params = {
        "date": _dateStr,
        "status": status,
      };
      final response = await apiTask.getListTask(params);
      setState(() {
        tasks = response;
        _isLoading = false;
      });
    } on DioException catch(err){
      if(err.response?.statusCode == 404 ){
        setState(() {
          tasks = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messageError = 'Error al obtener tareas: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _date = DateTime(picked.year, picked.month, picked.day);
        _dateStr = _formatDate(_date);
        _isLoading = true;
      });

      await _getList();
    }
  }

  void _openFilterSheet() {
    DateTime tempDate = _date;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filtrar tareas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Fecha igual
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Fecha: ${_formatDate(_date)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            TextButton(
                              onPressed: () async {
                                _selectDate();
                              },
                              child: const Text('Cambiar'),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              'Estado: ${TaskEnum.fromString(_status).label}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            color: _status == TaskEnum.PENDING.name ? Colors.grey.shade800 : Colors.grey.shade300,
                            onPressed: () {
                              setState(() {
                                _status = TaskEnum.PENDING.name;
                              });
                            },
                            icon: const Icon(Icons.pending),
                          ),
                          Text(
                            'Pendientes',
                            style: TextStyle(
                              color: _status == TaskEnum.PENDING.name ? Colors.grey.shade800 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            color: _status == TaskEnum.DONE.name ? Colors.green.shade700 : Colors.green.shade300,
                            onPressed: () {
                              setState(() {
                                _status = TaskEnum.DONE.name;
                              });
                            },
                            icon: const Icon(Icons.check),
                          ),
                          Text(
                            'Hechos',
                            style: TextStyle(
                              color: _status == TaskEnum.DONE.name ? Colors.green.shade700 : Colors.green.shade400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     ElevatedButton.icon(
                       icon: const Icon(Icons.delete),
                       label: const Text('Quitar filtros'),
                       onPressed: () {
                         Navigator.pop(context);
                         setState(() {
                           _date = DateTime.now();
                           _status = '';
                           _isLoading = true;
                         });
                         _getList();
                       },
                     ),
                     ElevatedButton.icon(
                       icon: const Icon(Icons.check),
                       label: const Text('Aplicar Filtro'),
                       onPressed: () {
                         Navigator.pop(context);
                         setState(() {
                           _date = DateTime(tempDate.year, tempDate.month, tempDate.day);
                           _isLoading = true;
                         });
                         _getList();
                       },
                     ),
                   ],
                 )
                ],
              ),
            );
          },
        );
      },
    );
  }


  Future<void> _deleteTaskFun() async{
    try{
      if(_selectedTaks.isEmpty){
        return;
      }
      String ids = _selectedTaks.map((items)=> items.id).toList().join(',');
      await apiTask.deleteTaskDto(ids);
      AlertHelper.show('Operación Exitosa', 'Se eliminaron ${_selectedTaks.length} tarea/s');
      await _getList();
      _selectedTaks = {};
    }
    catch(e){
      AlertHelper.show('Ups algo salio mal', 'Comunicate el equipo de sopote');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> floatingButtons = [];

    if (_menuOpen) {
      floatingButtons = [
        Container(
          margin: const EdgeInsets.only(bottom: 190),
          child: FloatingActionButton(
            heroTag: 'add',
            mini: true,
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false, // para que no se cierre tocando afuera
                builder: (context) => AddTaskDialog(
                  onSave: createTaskFun,
                ),
               );
              },
            child: const Icon(Icons.add),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 130),
          child: FloatingActionButton(
            heroTag: 'delete',
            mini: true,
            onPressed: _deleteTaskFun,
            child: const Icon(Icons.delete),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 70),
          child: FloatingActionButton(
            heroTag: 'edit',
            mini: true,
            onPressed: () {
              if(_selectedTaks.isEmpty) return;
              if(_selectedTaks.length > 1) return AlertHelper.show('Cuidado', 'Si vas a editar asegurate de haber seleccionado solo una tarea');

              showDialog(
                context: context,
                barrierDismissible: false, // para que no se cierre tocando afuera
                builder: (context) => AddTaskDialog(
                    initialTitle: _selectedTaks.first.title,
                    initialDescription: _selectedTaks.first.description,
                    onSave: (title, description) {
                      updateTaskFun(title, description);
                    },
                ),
              );
            },
            child: const Icon(Icons.edit),
          ),
        ),
      ];
    }

    floatingButtons.add(
      FloatingActionButton(
        heroTag: 'main',
        onPressed: () {
          setState(() {
            _menuOpen = !_menuOpen;
          });
        },
        tooltip: _menuOpen ? 'Cerrar menú' : 'Abrir menú',
        child: Icon(_menuOpen ? Icons.close : Icons.menu),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Gestor de Tareas Personal"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_alt),
            onPressed: _openFilterSheet,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks == null || tasks!.isEmpty
          ? const Center(child: Text("No hay tareas disponibles"))
          : ListView(
        padding: const EdgeInsets.all(20),
        controller: _scrollController,
        children: [
          const Text(
            'Hola Bienvenido a tu Gestor de Tareas',
            style:
            TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          Text(
            _dateStr,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          for (var task in tasks!)
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_selectedTaks.contains(task)) {
                    _selectedTaks.remove(task);
                  } else {
                    _selectedTaks.add(task);
                  }
                });
              },
              child: MyCardTask(
                id: task.id,
                title: task.title,
                description: task.description,
                action: updateDailyTask,
                status: (task.dailyTasks.status.isNotEmpty ||
                    TaskEnum.fromString(task.dailyTasks.status)
                        .label
                        .isEmpty)
                    ? TaskEnum.fromString(task.dailyTasks.status)
                    : TaskEnum.PENDING,
                isSelected: _selectedTaks.contains(task),
              ),
            )
        ],
       ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: floatingButtons,
      ),
    );
  }
}
