import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/leaveRepo.dart';
import 'model/LeaveData.dart';

void main() {
  runApp(const Mypp());
}

class Mypp extends StatelessWidget {
  const Mypp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LeaveScreen(),
    );
  }
}

class LeaveScreen extends StatefulWidget {
  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  late Future<List<LeaveData>> futureLeaveData;
  Color? containerColor;
  Color? textColor;
  List<dynamic>?  getgetYtdMonth;
  List<dynamic>?  hrmsLeaveBalanceV2;
  var sLvDescTitle;
  var dDate;
  var sLvDesc;

  @override
  void initState() {
    super.initState();
    futureLeaveData = HrmsreimbursementLogRepo().hrmsReimbursementLog(context);
    print('---35--response---$futureLeaveData');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // statusBarColore
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color  // 2a697b
          statusBarColor: Color(0xFF2a697b),
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        // backgroundColor: Colors.blu
        backgroundColor: Color(0xFF0098a6),
        leading: InkWell(
          onTap: () {
            // Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const DashBoard()),
            // );
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Apply Leave',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.normal,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
        ), // Removes shadow under the AppBar
      ),
      body: FutureBuilder<List<LeaveData>>(
        future: futureLeaveData,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                LeaveData leaveData = snapshot.data![index];
                sLvDesc = leaveData.sLvDesc;
                sLvDescTitle = (sLvDesc=="Leave Without Pay")? "Note:-Salary will be deducated for this leave.":"";
                containerColor;
                textColor;
                var note;
                if(sLvDesc =="Leave Without Pay"){
                  containerColor = Colors.redAccent;
                  textColor = Colors.redAccent;
                  // note="Note : Salary will be deducated for this leave ."
                }else{
                  containerColor = Color(0xFF0098a6);
                  textColor = Colors.black;
                }

                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Container with LeaveType and Description
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start, // Align items to the start of the row
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 56, // Height of the first container
                              width: MediaQuery.of(context).size.width-50, // Width of the first container
                              decoration: BoxDecoration(
                                color: Color(0xFFD3D3D3), // Background color of the first container
                                borderRadius: BorderRadius.circular(0), // Border radius
                                border: const Border(
                                  left: BorderSide(
                                    color: Colors.green, // Color of the left border
                                    width: 5.0, // Width of the left border
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Leave Type',
                                          style: TextStyle(
                                              color: Color(0xFF0098a6),
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          leaveData.sLvDesc,
                                          //'${hrmsLeaveBalaceV2List?[index].sLvDesc}',
                                          style: TextStyle(
                                              color: textColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal
                                          ),
                                        ),


                                      ],
                                    )
                                  ],
                                ),
                              ),

                            )
                          ],
                        ),

                        SizedBox(height: 16.0),
                        // Row with 5 equal Columns
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildColumn('Opening', leaveData.fOpeningBal),
                            buildColumn('Entitlement', leaveData.fEntitlement),
                            buildColumn('Availed', leaveData.fAvailed),
                            buildColumn('Closing', leaveData.fClosingBalance),
                            buildColumn('YTD', leaveData.fYTD),
                          ],
                        ),

                        SizedBox(height: 16.0),

                        // ElevatedButton at the end of the Card
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle button press
                            },
                            child: Text('Button'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Helper function to build each Column
  Column buildColumn(String label, String value) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'data/leaveRepo.dart';
// import 'model/LeaveData.dart';
// void main(){
//   runApp(const MyApp());
// }
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyLeveV2(),
//     );
//   }
// }
// class MyLeveV2 extends StatefulWidget {
//   const MyLeveV2({super.key});
//
//   @override
//   State<MyLeveV2> createState() => _MyLeveV2State();
// }
//
// class _MyLeveV2State extends State<MyLeveV2> {
//   List reimbursementStatusLog = [];
//
//   hrmsReimbursementLog() async {
//     reimbursementStatusLog = await HrmsreimbursementLogRepo().hrmsReimbursementLog(context);
//     print(" -----xxxxx-  hrmsReimbursement-----> $reimbursementStatusLog");
//     // setState(() {});
//   }
//   // response Convert into the model
//   // List<LeaveData> parseLeaveData(String responseBody) {
//   //   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
//   //   return parsed.map<LeaveData>((json) => LeaveData.fromJson(json)).toList();
//   // }
//   // // put data into the parseLeaveData
//   //  List<LeaveData> leaveDataList = parseLeaveData(reimbursementStatusLog);
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     hrmsReimbursementLog();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Leave Balance',style: TextStyle(
//           color: Colors.black,fontSize: 14
//         ),),
//       ),
//       body:Container(
//          height: MediaQuery.of(context).size.height,
//         child: ListView.builder(
//           itemCount: reimbursementStatusLog?.length ?? 0,
//           itemBuilder: (context, index) {
//             //final leaveData = reimbursementStatusLog[index];
//             return Card(
//               margin: EdgeInsets.all(8.0),
//               elevation: 4.0,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Top Container with LeaveType and sLvDesc
//                     Container(
//                       height: 50,
//                       color: Colors.blue.shade100,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             '${reimbursementStatusLog?[index]['sLvDesc']}',
//                              //'${reimbursementStatusLog[index]['sLvDesc']}',
//                            // leaveData.sLvDesc,
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                            '${reimbursementStatusLog[index]['sLvTypeCode']}',
//                           //  leaveData.sLvTypeCode,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 16.0),
//
//                     // Row with 5 equal Columns
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         buildColumn('Opening','${reimbursementStatusLog[index]['fOpeningBal']}'),
//                         buildColumn('Entitlement', '${reimbursementStatusLog[index]['fEntitlement']}'),
//                         buildColumn('Availed',  '${reimbursementStatusLog[index]['fAvailed']}'),
//                         buildColumn('Closing',  '${reimbursementStatusLog[index]['fClosingBalance']}'),
//                         buildColumn('YTD', '${reimbursementStatusLog[index]['fYTD']}' '${reimbursementStatusLog[index]['fClosingBalance']}'),
//                       ],
//                     ),
//
//                     SizedBox(height: 16.0),
//
//                     // ElevatedButton at the end of the Card
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Handle button press
//                         },
//                         child: Text('Button'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   // Helper function to build each Column
//   Column buildColumn(String label, String value) {
//     return Column(
//       children: [
//         Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: Colors.blueAccent,
//             borderRadius: BorderRadius.circular(25),
//           ),
//           child: Center(
//             child: Text(
//               value,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//         SizedBox(height: 8.0),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     );
//
//
//
//   }
// }
