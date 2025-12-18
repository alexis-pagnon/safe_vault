import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_vault/viewmodels/AuthenticationProvider.dart';
import 'package:safe_vault/viewmodels/RobustnessProvider.dart';

import 'package:safe_vault/models/database/Password.dart';
import 'package:safe_vault/viewmodels/DatabaseProvider.dart';

import '../models/SharedPreferencesRepository.dart';
import '../models/authentication/KeyGenerator.dart';
import '../models/authentication/SecureStorageRepository.dart';

// TODO : Remove this home page, it's only for testing purposes

class TestPage1 extends StatefulWidget {
  const TestPage1({super.key});

  @override
  State<TestPage1> createState() => _TestPage1State();
}

class _TestPage1State extends State<TestPage1> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  Future<void> loadDb() async {
    final dbProvider = context.read<DatabaseProvider>();
    final storage = context.read<SecureStorageRepository>();

    String? dbKey = await storage.readDbKey();
    if (dbKey == null) {
      dbKey = KeyGenerator.keyToHex(
        KeyGenerator.createDeriveKeyFromPassword("azerty"),
      );
      await storage.saveDbKey(dbKey);
    }

    await dbProvider.init(dbKey);

  }

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);


    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Center(
        child: FutureBuilder(
          future: loadDb(),
          builder: (context, asyncSnapshot) {
            if(asyncSnapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            }

            dbProvider.loadPasswords();

            return Column(
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
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                ),

                ElevatedButton(
                  onPressed: () {
                    // Save the password to the database
                    String username = _usernameController.text;
                    String password = _passwordController.text;
                    dbProvider.insertPassword(Password(password: password, username: username, id_category: 1));
                  },
                  child: Text('Save Password'),
                ),

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
                        children: passwords.map((pwd) => ListTile(title: Text(pwd.username), subtitle: Text(pwd.password))).toList(),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}

class TestPage2 extends StatefulWidget {
  const TestPage2({super.key});

  @override
  State<StatefulWidget> createState() => _TestPage2State();
}

class _TestPage2State extends State<TestPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Center(
        child: Column(
          children: [
            Text('Test Page 2 - Authentication Page Placeholder'),

            if (context.watch<SharedPreferencesRepository>().firstTime)
              ElevatedButton(
                onPressed: () {
                  // Simulate authentication
                  context.read<AuthenticationProvider>().registerNewUser("azerty");
                },
                child: Text('Register'),
              ),

            if (!context.watch<SharedPreferencesRepository>().firstTime)
              ElevatedButton(
                onPressed: () {
                  // Simulate authentication
                  context.read<AuthenticationProvider>().authenticate("azerty");
                },
                child: Text('Authenticate'),
              ),
          ],
        ),
      ),
    );
  }
}
