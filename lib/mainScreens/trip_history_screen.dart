import 'package:boride/assistants/assistant_methods.dart';
import 'package:boride/assistants/app_info.dart';
import 'package:boride/widgets/history_design_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('Trip History', style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: "Brand-Regular"),),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: ListView.separated(
          padding: EdgeInsets.all(0),
          itemBuilder: (context, index) {
            return HistoryTile(
              history: Provider.of<AppInfo>(context).tripsData[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(height: 1,thickness: 0.5,),
          itemCount: Provider.of<AppInfo>(context).tripsData.length,
          physics: ClampingScrollPhysics(),
          shrinkWrap:  true,
        ),
      ),
    );
  }
}