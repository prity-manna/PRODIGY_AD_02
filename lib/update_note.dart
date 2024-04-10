import 'package:flutter/material.dart';
import 'package:todo/sql_service.dart';

class UpdateTodo extends StatefulWidget {
  final int index;
  final DatabaseHelper databaseHelper;
  const UpdateTodo({required this.index, required this.databaseHelper, super.key});

  @override
  State<UpdateTodo> createState() => _UpdateTodoState();
}

class _UpdateTodoState extends State<UpdateTodo> {

  late final TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    getData();
  }

  Future<void> getData() async {
    Map<String,Object?>? data = await widget.databaseHelper.getDataAt(widget.index);
    if (data == null) {
      if (!mounted) return;
      showAdaptiveDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: true,
        builder: (context) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Text(
            "No data exists",
            style: TextStyle(
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      Future.delayed(
        const Duration(
          seconds: 3,
        ),
        () => Navigator.pop(context)
      );
      return;
    }
    textEditingController.text = data['text'] as String;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20)),
        ),
        title: Text("Update Todo No.: ${widget.index+1}"),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                        await widget.databaseHelper.deleteData(widget.index);
                        if (!mounted) return;
                        Navigator.pop(this.context);
                      } else{
                        await widget.databaseHelper.updateData(widget.index, textEditingController.text);
                        if(!mounted) return;
                        Navigator.pop(
                          this.context
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
                  onTap: () async {
                    await widget.databaseHelper.deleteData(widget.index);
                    if(!mounted) return;
                    Navigator.pop(
                      this.context
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