import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../global.dart';

class NoticeBoardScreen extends StatefulWidget {
  final bool isLoggedIn;
  final bool isAdmin;

  NoticeBoardScreen({required this.isLoggedIn, required this.isAdmin});

  @override
  _NoticeBoardScreenState createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  List<Map<String, dynamic>> notices = [];
  final String apiUrl = "$api/notice";

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  String? selectedNoticeId;

  @override
  void initState() {
    super.initState();
    _fetchNotices();
  }

  Future<void> _fetchNotices() async {
    final String endpoint = '$apiUrl/get-notice';

    try {
      final response = await http.get(Uri.parse(endpoint));
      print("Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('notice')) {
          setState(() {
            notices = List<Map<String, dynamic>>.from(data['notice']);
          });
        } else {
          throw Exception("Invalid data format: Expected a list under 'notice' key");
        }
      } else {
        throw Exception('Failed to load notices');
      }
    } catch (e) {
      print("Error fetching notices: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching notices")),
      );
    }
  }

  Future<void> _addNotice() async {
    final String endpoint = '$apiUrl/add-notice';

    final noticeData = {
      'title': titleController.text,
      'body': bodyController.text,
      'status': statusController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: json.encode(noticeData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notice Added Successfully')),
        );

        // Refresh the notices list
        _fetchNotices();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add notice')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _editNotice(String noticeId) async {
    final String endpoint = '$apiUrl/update-notice/$noticeId';

    final noticeData = {
      'title': titleController.text,
      'body': bodyController.text,
      'status': statusController.text,
    };

    try {
      final response = await http.put(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: json.encode(noticeData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notice Edited Successfully')),
        );

        // Refresh the notices list
        _fetchNotices();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to edit notice')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showAddOrEditNoticeDialog({String? noticeId}) {
    // If noticeId is provided, we are in Edit mode
    if (noticeId != null) {
      final selectedNotice = notices.firstWhere((notice) => notice['_id'] == noticeId);
      titleController.text = selectedNotice['title'];
      bodyController.text = selectedNotice['body'];
      statusController.text = selectedNotice['status'];
      selectedNoticeId = noticeId;
    } else {
      titleController.clear();
      bodyController.clear();
      statusController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(noticeId == null ? "Add Notice" : "Edit Notice"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(labelText: "Content"),
              ),
              DropdownButtonFormField<String>(
                value: statusController.text.isNotEmpty ? statusController.text : null,
                decoration: InputDecoration(labelText: 'Match Status'),
                items: ['important', 'general']
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) {
                  statusController.text = value ?? '';
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (noticeId == null) {
                  _addNotice();
                } else {
                  _editNotice(selectedNoticeId!);
                }
                Navigator.pop(context);
              },
              child: Text(noticeId == null ? "Add" : "Save"),
            ),
          ],
        );
      },
    );
  }

  String formatDate(String isoDate) {
    try {
      DateTime dateTime = DateTime.parse(isoDate);
      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (e) {
      return "Invalid Date";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
          title: Text('Notice')),
      body: notices.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: notices.length,
        itemBuilder: (context, index) {
          var notice = notices[index];
          return Card(
            margin: EdgeInsets.all(10),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notice['title'] ?? "No Title",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SingleChildScrollView(scrollDirection: Axis.horizontal,
                            child: Container(width: 300,
                              child: Text(
                                notice['body'] ?? "",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      /*Text(
                        "${formatDate(notice['createdAt'] ?? "")}",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),*/
                    ],
                  ),

                  Divider(),
                  Row(
                    children: [
                      Text(
                        "Status: ${notice['status'] ?? ""}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 130),
                      Text(
                        "${formatDate(notice['createdAt'] ?? "")}",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                  // Show Edit button for Admin only
                  if (widget.isAdmin)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showAddOrEditNoticeDialog(noticeId: notice['_id']);
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
        onPressed: () {
          _showAddOrEditNoticeDialog();
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      )
          : null,




    );
  }
}
