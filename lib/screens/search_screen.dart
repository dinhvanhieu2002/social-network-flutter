import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network/models/user_model.dart';
import 'package:social_network/repository/auth_repository.dart';
import 'package:social_network/screens/profile_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<UserModel>>? _users;

  _buildUserTile(UserModel user) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20.0,
        backgroundImage: CachedNetworkImageProvider(user.avatar),
      ),
      title: Text(user.username!),
      subtitle: Text(user.fullName),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileScreen(
            currentUserId: ref.read(userProvider)!.id,
            userId: user.id,
          ),
        ),
      ),
    );
  }

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            border: InputBorder.none,
            hintText: 'Search',
            prefixIcon: const Icon(
              Icons.search,
              size: 24.0,
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.clear,
              ),
              onPressed: _clearSearch,
            ),
            filled: true,
          ),
          onChanged: (input) {
            if (input.isNotEmpty) {
              setState(() {
                _users = ref.watch(authRepositoryProvider).search(
                    token: ref.watch(userProvider)!.token, username: input);
              });
            }
          },
        ),
      ),
      body: _users == null
          ? const Center(
              child: Text('Search for a user'),
            )
          : FutureBuilder(
              future: _users,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No users found! Please try again.'),
                  );
                }
                print(snapshot.data);
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    UserModel user = snapshot.data![index];
                    return _buildUserTile(user);
                  },
                );
              },
            ),
    );
  }
}
