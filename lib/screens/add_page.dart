import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void iniState(){
    super.initState();
    final todo = widget.todo;
    if(todo != null){
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text= title;
      descriptionController.text=description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isEdit? 'Edit todo' : 'Add  Todo',
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: isEdit? updateData : submitData,
              child:Padding(
                padding: const EdgeInsets.all(16.0),
                  child: Text(
                    isEdit ? 'Update' : 'Submit',
                  ),
              ),
          )
        ],
      ),
    );
  }
  Future<void> updateData() async{
    final todo = widget.todo;
    if(todo == null){
      print('you can not update data');
      return;
    }
    final id = todo['_id'];
    final iscompleted = todo['is_completed'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body=
    {
      "title": title,
      "description": description,
      "is_completed": iscompleted,
    };

    //submit data to the server
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.post(
        uri,
        body: jsonEncode(body),
    headers: {
    'Content-Type':'application/json'
    },
    );
  }

  Future<void> submitData() async{
    //get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    final body=
      {
        "title": title,
        "description": description,
        "is_completed": false,
      };

    //submit data to the server
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type':'application/json'
      },
    );

    //show success or fail message based on status
    if(response.statusCode==201) {
      print('creation success');
      showSuccesMessage('creation reussi');
    }else{
      showErrorMessage('creation echoue');
    }
  }

  void showSuccesMessage(String message){
    final snackBar = SnackBar(
        content:
        Text(
            message,
            style: TextStyle(color: Colors.green),));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void showErrorMessage(String message){
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white ),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
