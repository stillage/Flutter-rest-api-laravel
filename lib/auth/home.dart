import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kegiatanapp/auth/login.dart';
import 'package:kegiatanapp/konfigurasi/api.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/usercontroller.dart';
import '../controller/todocontroller.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name;
  @override
  void initState() {
    _loadUserData();
    _dataTodo();
    super.initState();
  }

  _dataTodo() {
    setState(() {
      Provider.of<TodoController>(context, listen: false).getTodo();
    });
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('data'));

    if (user != null) {
      setState(() {
        name = user['name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _dataTodo();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('$name'),
        backgroundColor: Colors.amber,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout),
        onPressed: logout,
        backgroundColor: Colors.amber,
      ),
      body: RefreshIndicator(
        //ADAPUN FUNGSI YANG DIJALANKAN ADALAH getEmployee() DARI EMPLOYEE_PROVIDER
        onRefresh: () =>
            Provider.of<TodoController>(context, listen: false).getTodo(),
        color: Colors.red,
        child: Container(
          margin: EdgeInsets.all(10),
          //KETIKA PAGE INI DIAKSES MAKA AKAN MEMINTA DATA KE API
          child: FutureBuilder(
            //DENGAN MENJALANKAN FUNGSI YANG SAMA
            future:
                Provider.of<TodoController>(context, listen: false).getTodo(),
            builder: (context, snapshot) {
              //JIKA PROSES REQUEST MASIH BERLANGSUNG
              if (snapshot.connectionState == ConnectionState.waiting) {
                //MAKA KITA TAMPILKAN INDIKATOR LOADING
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              //SELAIN ITU KITA RENDER ATAU TAMPILKAN DATANYA
              //ADAPUN UNTUK MENGAMBIL DATA DARI STATE DI PROVIDER
              //MAKA KITA GUNAKAN CONSUMER
              return Consumer<TodoController>(
                builder: (context, data, _) {
                  //KEMUDIAN LOOPING DATANYA DENGNA LISTVIEW BUILDER
                  return ListView.builder(
                    //ADAPUN DATA YANG DIGUNAKAN ADALAH REAL DATA DARI GETTER dataEmployee
                    itemCount: data.dataTodo.length,
                    itemBuilder: (context, i) {
                      return Card(
                        elevation: 8,
                        child: ListTile(
                          title: Text(
                            //DAN DATA YANG DITAMPILKAN JG DIAMBIL DARI GETTER DATAEMPLOYEE
                            //SESUAI INDEX YANG SEDANG DILOOPING
                            data.dataTodo[i].to_user,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('${data.dataTodo[i].title}'),
                          trailing: Text('${data.dataTodo[i].create_by}'),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void logout() async {
    var res = await Network().logOut('/logoutapi');
    var body = json.decode(res.body);
    // if (body['success']) {
    //   SharedPreferences localStorage = await SharedPreferences.getInstance();
    //   localStorage.remove('data');
    // localStorage.remove('token');
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    // }
  }
}
