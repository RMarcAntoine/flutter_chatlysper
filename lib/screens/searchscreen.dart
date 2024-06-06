import 'package:chatlysper_app/screens/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:chatlysper_app/composants/usertile.dart';
import 'package:chatlysper_app/services/auth/authserv.dart';
import 'package:chatlysper_app/services/chat/chatservice.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ChatService _chatService = ChatService();
  final AuthServ _authService = AuthServ();
  String _searchQuery = '';
  List<Map<String, dynamic>> _allUsers = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    _chatService.getUsersStream().listen((users) {
      setState(() {
        _allUsers = users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chercher Utilisateurs"),
        backgroundColor: colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Chercher les utilisateurs...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildUserList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    final List<Map<String, dynamic>> filteredUsers = _allUsers.where((user) {
      return user["email"].toLowerCase() == _searchQuery &&
          user["email"] != _authService.getCurrentUser()!.email;
    }).toList();

    if (filteredUsers.isEmpty) {
      return const Center(
        child: Text('Aucun utilisateur trouvé.'),
      );
    }
    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        var userData = filteredUsers[index];
        return UserTile(
          text: userData["email"],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  receiverEmail: userData["email"],
                  receiverID: userData["uid"],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
