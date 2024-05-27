import 'package:flutter/material.dart';
import 'package:chatlysper_app/composants/mydrawer.dart';
import 'package:chatlysper_app/composants/usertile.dart';
import 'package:chatlysper_app/screens/chatscreen.dart';
import 'package:chatlysper_app/services/auth/authserv.dart';
import 'package:chatlysper_app/services/chat/chatservice.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ChatService _chatService = ChatService();
  final AuthServ _authService = AuthServ();
  String _searchQuery = '';
  late final List<Map<String, dynamic>> _usersWithConversation = [];
  late final List<Map<String, dynamic>> _usersWithoutConversation = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    _chatService.getUsersStream().listen((users) async {
      _usersWithConversation.clear();
      _usersWithoutConversation.clear();
      for (var userData in users) {
        bool hasConversation = await _chatService.hasConversation(
            _authService.getCurrentUser()!.uid, userData["uid"]);
        if (hasConversation) {
          setState(() {
            _usersWithConversation.add(userData);
          });
        } else {
          setState(() {
            _usersWithoutConversation.add(userData);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text("UTILISATEURS"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
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
                hintText: 'Filtrer les utilisateurs...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colorScheme.surface, // Adjust color based on theme
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
    List<Map<String, dynamic>> filteredUsers = [];
    filteredUsers.addAll(_usersWithConversation);
    filteredUsers.addAll(_usersWithoutConversation);

    if (filteredUsers.isEmpty) {
      return const Center(
        child: Text('Aucun utilisateur trouvé.'),
      );
    }
    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        var userData = filteredUsers[index];
        if (userData["email"] != _authService.getCurrentUser()!.email &&
            userData["email"].toLowerCase().contains(_searchQuery)) {
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
        } else {
          return Container();
        }
      },
    );
  }
}
