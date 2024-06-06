import 'package:flutter/material.dart';
import 'package:chatlysper_app/composants/mydrawer.dart';
import 'package:chatlysper_app/composants/usertile.dart';
import 'package:chatlysper_app/screens/chatscreen.dart';
import 'package:chatlysper_app/screens/searchscreen.dart';
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
  late final List<Map<String, dynamic>> _usersWithConversation = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    _chatService.getUsersStream().listen((users) async {
      _usersWithConversation.clear();
      for (var userData in users) {
        bool hasConversation = await _chatService.hasConversation(
            _authService.getCurrentUser()!.uid, userData["uid"]);
        if (mounted) {
          setState(() {
            if (hasConversation) {
              _usersWithConversation.add(userData);
            }
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    if (_usersWithConversation.isEmpty) {
      return const Center(
        child: Text('Aucun utilisateur trouvé.'),
      );
    }
    return ListView.builder(
      itemCount: _usersWithConversation.length,
      itemBuilder: (context, index) {
        var userData = _usersWithConversation[index];
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
