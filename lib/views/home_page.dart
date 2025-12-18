
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_vault/viewmodels/RobustnessProvider.dart';

import 'package:safe_vault/models/database/Password.dart';
import 'package:safe_vault/viewmodels/DatabaseProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<DatabaseProvider>().loadPasswords()
    );
  }


  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Consumer<RobustnessProvider>(
              builder: (context, robustnessProvider, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Strong: ${robustnessProvider.strong}'),
                    Text('Weak: ${robustnessProvider.weak}'),
                    Text('Compromised: ${robustnessProvider.compromised}'),
                    Text('Reused: ${robustnessProvider.reused}'),
                  ],
                );
              },
            ),

            Divider(),

            Text('Save password :'),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),

            ElevatedButton(onPressed: () {
              // Save the password to the database
              String username = _usernameController.text;
              String password = _passwordController.text;
              dbProvider.insertPassword(Password(password: password, username: username, id_category: 1));
            }, child: Text('Save Password')),

            Divider(),

            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Consumer<DatabaseProvider>(
                builder: (context, dbProvider, _) {
                  final passwords = dbProvider.passwords;
                  if (passwords.isEmpty) {
                    return Text("No passwords saved");
                  }
                  return Column(
                    children: passwords.map((pwd) =>
                        ListTile(
                          title: Text(pwd.username),
                          subtitle: Text(pwd.password),
                        )
                    ).toList(),
                  );
                },
              ),
            ),

          ],
        ),

      ),
    );
  }
}