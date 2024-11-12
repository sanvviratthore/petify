// lib/species_selection_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpeciesSelectionPage extends StatefulWidget {
  @override
  _SpeciesSelectionPageState createState() => _SpeciesSelectionPageState();
}

class _SpeciesSelectionPageState extends State<SpeciesSelectionPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  // Replace with your chatbot API URL
  final String apiUrl = "https://yourapi.com/chatbot/message";

  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "message": message});
    });

    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"message": message}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          messages.add({"sender": "bot", "message": data['reply']});
        });
      } else {
        setState(() {
          messages.add({"sender": "bot", "message": "Error: Unable to get a response"});
        });
      }
    } catch (e) {
      setState(() {
        messages.add({"sender": "bot", "message": "Error: Could not connect to server"});
      });
    }
  }

  void openChatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 200,
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUser = message["sender"] == "user";
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blue[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(message["message"] ?? ""),
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      sendMessage(_controller.text);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Petify - Select a Species"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select a species to get started:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildSpeciesCard("Dog"),
                  _buildSpeciesCard("Cat"),
                  _buildSpeciesCard("Rabbit"),
                  _buildSpeciesCard("Fish"),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openChatDialog,
        child: Icon(Icons.chat),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Color.fromARGB(255, 248, 166, 211),
    );
  }

  Widget _buildSpeciesCard(String speciesName) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(Icons.pets, color: Colors.blue),
        title: Text(
          speciesName,
          style: TextStyle(fontSize: 18),
        ),
        onTap: () {
          // Action when species is selected (you could navigate to a new page)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected: $speciesName')),
          );
        },
      ),
    );
  }
}