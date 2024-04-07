import 'package:flutter/material.dart';
import './sql_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
              left: Radius.circular(20), right: Radius.circular(20.0)),
        ),
        title: const Text("Notes"),
        centerTitle: true,
        scrolledUnderElevation: 1,
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: FutureBuilder(
              future: databaseHelper.getData,
              builder: (context, snapshot) {
                return (databaseHelper.id > 0)
                ? ListView.separated(
                  itemCount: snapshot.data?.length ?? 0,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: (index % 2 == 0) ? Colors.lightBlue.shade50 : Colors.lightGreen.shade50,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              snapshot.data?.elementAt(index)['text'].toString() as String,
                              maxLines: null,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              bool isSuccess = await databaseHelper.deleteData(index);
                              if(!mounted) return;
                              if (isSuccess) setState(() {});
                            },
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.red.shade800,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
                : const Center(
                  child: Text(
                    "No Data",
                    style: TextStyle(
                      color: Colors.black54
                    ),
                  ),
                );
              }
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () async {
                if (!mounted) return;
                final result = await Navigator.pushNamed(
                  context,
                  '/create',
                  arguments: {
                    'id' : databaseHelper.id,
                    'databaseHelper' : databaseHelper,
                  },
                );
                setState(() {});
                if(result == false) return;
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20, right: 20),
                child: const Icon(
                  Icons.add_circle_outline,
                  size: 50.0,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}