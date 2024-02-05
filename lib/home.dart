import 'package:flutter/material.dart';
import 'package:todolist/database.dart';
import 'package:todolist/update_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  List<Map<String, dynamic>> dataList = [];

  void _saveData() async{
    final name = _nameController.text;
    final age = int.tryParse(_ageController.text) ?? 0;
    int insertId = await Sqldb.insertUser(name, age);
    print(insertId);

    List<Map<String, dynamic>> UpdatedData = await Sqldb.getData();
    setState(() {
      dataList = UpdatedData;
    });
    _nameController.text = '';
    _ageController.text='';

  }

  @override
  void initState() {
    _viewUsers();
    super.initState();
  }

 void _viewUsers() async{
   List<Map<String, dynamic>> userList = await Sqldb.getData();
   setState(() {
     dataList = userList;
   });
  }

  void _delete(int Id) async{
    int id = await Sqldb.deleteData(Id);
    List<Map<String,dynamic>> updatedData = await Sqldb.getData();
    setState(() {
      dataList=updatedData;
    });
  }

  void Data() async{
    List<Map<String,dynamic>> Data = await Sqldb.getData();
    setState(() {
      dataList = Data;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDoList'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(hintText:  'age'),
                  ),
                  ElevatedButton(onPressed: _saveData,
                      child:const Text('Save User')
                  )
                ],
              ),
              const SizedBox(height: 30),
              Expanded(child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context , i){
                    return ListTile(
                      title: Text(dataList[i]['name']),
                      subtitle: Text('Age ${dataList[i]['age']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>
                                UpdateUser(userId: dataList[i]['id'])
                                )
                            ).then((result){
                              if(result == true){
                                Data();
                              }
                            });
                          },
                              icon: const Icon(Icons.edit,color: Colors.blue,)),
                          IconButton(
                            onPressed: (){
                              _delete(dataList[i]['id']);
                            }, icon:
                           const Icon(Icons.delete,
                            color: Colors.red,),
                          ),
                        ],
                      ) ,
                    );
                  })
              )
            ],
          ),
        ),
      ),
    );
  }
}
