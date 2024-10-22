import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../services/api/api_service.dart';
import '../../models/user.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  UsersScreenState createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  late final BuildContext _context;
  TextEditingController searchController = TextEditingController();
  List<User> allUsers = [];
  List<User> filteredUsers = [];
  bool showOnlyAdmins = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _context = context;
      fetchUsers();
    });
  }

  Future<void> fetchUsers() async {
    try {
      final users =
          await Provider.of<ApiService>(_context, listen: false).fetchUsers();
      if (mounted) {
        setState(() {
          allUsers = users;
          filteredUsers = users;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(_context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: $error')),
        );
      }
    }
  }

  void filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUsers = showOnlyAdmins
            ? allUsers.where((user) => user.isAdmin).toList()
            : allUsers;
      } else {
        filteredUsers = allUsers
            .where((user) =>
                user.nome.toLowerCase().contains(query.toLowerCase()) &&
                (!showOnlyAdmins || user.isAdmin))
            .toList();
      }
    });
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
        elevation: 0, // Remove a sombra da AppBar
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: filterUsers,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Pesquisar",
                      labelStyle: const TextStyle(color: Colors.white54),
                      hintText: "Pesquisar por nome",
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF333333),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                FilterChip(
                  label: const Text('Apenas Admins'),
                  selected: showOnlyAdmins,
                  onSelected: (bool selected) {
                    setState(() {
                      showOnlyAdmins = selected;
                      filterUsers(searchController.text);
                    });
                  },
                  selectedColor: Colors.green,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                      color: showOnlyAdmins ? Colors.white : Colors.white70),
                  backgroundColor: const Color(0xFF333333),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredUsers.isEmpty
                ? const Center(
                    child: Text('Nenhum usuário encontrado.',
                        style: TextStyle(color: Colors.white54, fontSize: 16)))
                : ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return Card(
                        color: const Color(0xFF333333),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ExpansionTile(
                          title: Text(user.nome,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          subtitle: Text(user.email,
                              style: const TextStyle(color: Colors.white70)),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white24,
                            child: Text(
                              user.nome.substring(0, 1).toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(color: Colors.white24),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(Icons.location_city, 'Cidade',
                                      user.cidade),
                                  _buildInfoRow(
                                      Icons.phone, 'Contato', user.contato),
                                  _buildInfoRow(Icons.calendar_today,
                                      'Criado em', formatDate(user.criadoEm)),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Status de Admin',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      Switch(
                                        value: user.isAdmin,
                                        onChanged: (value) async {
                                          user.isAdmin = value;
                                          try {
                                            await Provider.of<ApiService>(
                                                    _context,
                                                    listen: false)
                                                .updateUser(user);
                                            if (mounted) {
                                              ScaffoldMessenger.of(_context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Usuário atualizado com sucesso')),
                                              );
                                            }
                                          } catch (error) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(_context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Erro ao atualizar usuário: $error')),
                                              );
                                            }
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
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white54, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
