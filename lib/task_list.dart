import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_tracker/task_model.dart';

import 'add_task.dart';
import 'main.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> with WidgetsBindingObserver {
  List<Task> tasks = [];
  List<Task> defaultList1 = [
    Task(title: 'Add Task', description: 'Tap on Add Button to add a new task'),
    Task(title: 'Delete Task', description: 'Swipe your completed task to delete that task'),
  ];

  @override
  void initState() {
    super.initState();
    _loadTasks();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _saveTasks();
    }
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskListJson = prefs.getStringList('tasks') ?? [];
    setState(() {
      if (taskListJson.isNotEmpty) {
        tasks = taskListJson.map((taskJson) => Task.fromJson(taskJson)).toList();
      } else {
        tasks = defaultList1 ;
        _saveTasks(); // Save default tasks if no tasks are stored in SharedPreferences
      }
    });
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskListJson = tasks.map((task) => task.toJsonString()).toList();
    await prefs.setStringList('tasks', taskListJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.lightbulb),
            onPressed: () {
              Provider.of<ThemeModeNotifier>(context, listen: false).toggleMode();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Dismissible(
            key: Key(task.title),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              setState(() {
                tasks.removeAt(index);
              });
              _saveTasks();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Task deleted')),
              );
            },
            child: ListTile(
              title: Text(task.title),
              subtitle: Text(task.description),
              trailing: Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  setState(() {
                    task.isCompleted = value!;
                  });
                  _saveTasks();
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTaskScreen,
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddTaskScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    ).then((newTask) {
      if (newTask != null) {
        setState(() {
          tasks.add(newTask);
        });
        _saveTasks();
      }
    });
  }
}
