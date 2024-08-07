import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../models/user.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  TextEditingController searchController = TextEditingController();
  List<User> allUsers = [];
  List<User> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final users =
          await Provider.of<ApiService>(context, listen: false).fetchUsers();
      setState(() {
        allUsers = users;
        filteredUsers = users;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $error')),
      );
    }
  }

  void filterSearchResults(String query) {
    List<User> dummySearchList = [];
    dummySearchList.addAll(allUsers);
    if (query.isNotEmpty) {
      List<User> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nome.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filteredUsers.clear();
        filteredUsers.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        filteredUsers.clear();
        filteredUsers.addAll(allUsers);
      });
    }
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: AppBar(
        title: const Text('Usuários'),
        backgroundColor: const Color(0xFF333333),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterSearchResults(value);
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Pesquisar",
                labelStyle: const TextStyle(color: Colors.white),
                hintText: "Pesquisar por nome",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF333333),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredUsers.isEmpty
                ? const Center(
                    child: Text('Nenhum usuário encontrado.',
                        style: TextStyle(color: Colors.white)))
                : ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return Card(
                        color: const Color(0xFF333333),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.nome,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const SizedBox(height: 8),
                              Text('Email: ${user.email}',
                                  style: const TextStyle(color: Colors.white)),
                              Text('Cidade: ${user.cidade}',
                                  style: const TextStyle(color: Colors.white)),
                              Text('Contato: ${user.contato}',
                                  style: const TextStyle(color: Colors.white)),
                              Text('Criado em: ${formatDate(user.criadoEm)}',
                                  style: const TextStyle(color: Colors.white)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Admin:',
                                      style: TextStyle(color: Colors.white)),
                                  Switch(
                                    value: user.isAdmin,
                                    onChanged: (value) async {
                                      user.isAdmin = value;
                                      try {
                                        await Provider.of<ApiService>(context,
                                                listen: false)
                                            .updateUser(user);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Usuário atualizado com sucesso')),
                                        );
                                      } catch (error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Erro ao atualizar usuário: $error')),
                                        );
                                      }
                                    },
                                    activeColor: Colors.green,
                                    inactiveThumbColor: Colors.red,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
