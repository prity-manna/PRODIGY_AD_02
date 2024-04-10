import 'package:flutter/material.dart';
import 'package:todo/update_note.dart';
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
        title: const Text("Todo"),
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
                    return GestureDetector(
                      onTap: () async {
                        if (!mounted) return;
                        await showModalBottomSheet(
                          context: context,
                          showDragHandle: true,
                          isDismissible: true,
                          clipBehavior: Clip.none,
                          builder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(20.0),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Todo No.: ${index+1}",
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Text(
                                        snapshot.data?.elementAt(index)['text'] as String,
                                        style: const TextStyle(
                                          color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        );
                      },
                      child: Container(
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
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (!mounted) return;
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateTodo(
                                      index: index,
                                      databaseHelper: databaseHelper
                                    ),
                                  ),
                                );
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade200,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.green.shade800,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            GestureDetector(
                              onTap: () async {
                                bool isSuccess = await databaseHelper.deleteData(index);
                                if(!mounted) return;
                                if (isSuccess) setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
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