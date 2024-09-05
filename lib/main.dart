import 'package:flutter/material.dart';

import 'data/leaveRepo.dart';
import 'model/LeaveData.dart';

void main(){
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
        title: Text('Leave Balance'),
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
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Container with LeaveType and Description
                        Container(
                          height: 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                leaveData.sLvDesc,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                leaveData.sLvTypeCode,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
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
