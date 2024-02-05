import 'package:flutter/material.dart';
import 'database.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key,required this.userId});
  final int userId;
  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  void Data() async{
    Map<String, dynamic>? data = await Sqldb.getSingleData(widget.userId);
    if(data!= null){
      _ageController.text = data['age'].toString();
      _nameController.text = data['name'];
    }
  }

  @override
  void initState() {
    Data();
    super.initState();
  }

  void updateData(BuildContext context) async{
    Map<String,dynamic> data ={
      'name': _nameController.text,
      'age' : _ageController.text,
    };
    print(data);

    int id = await Sqldb.updateData(widget.userId, data);

    Navigator.pop(context, true);

  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(hintText: 'age'),
            ),
            ElevatedButton(onPressed: (){
              updateData(context);
            },
                child:const Text('Update User'))
          ],
        ),
      ),
    );
  }
}

