import 'package:flutter/material.dart';
import './sql_service.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> data = (ModalRoute.of(context)?.settings.arguments ?? <String,dynamic>{}) as Map<String,dynamic>;
    int index = data['id'];
    DatabaseHelper databaseHelper = data['databaseHelper'];
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
              left: Radius.circular(20), right: Radius.circular(20.0)),
        ),
        title: const Text("Create A Note"),
        centerTitle: true,
        scrolledUnderElevation: 1,
      ),
      body: Container(
        color: Colors.green,
        child: Flex(
          direction: Axis.vertical,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Note No.: ${index+1}"),
                      const Divider(),
                      Expanded(
                        child: TextFormField(
                          controller: textEditingController,
                          onChanged: (value) => textEditingController.text,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if(textEditingController.text.trim() == '') {
                        Navigator.pop(context, true);
                      } else{
                        bool isSuccess = await databaseHelper.insertData(index, textEditingController.text);
                        if(!mounted) return;
                        Navigator.pop(
                          context,
                          isSuccess,
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 20.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20.0,),
                GestureDetector(
                  onTap: () {
                    if(!mounted) return;
                    Navigator.pop(
                      context,
                      false,
                    );
                  },
                  child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 20.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.red.shade700,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                    ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}