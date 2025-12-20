import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_vault/viewmodels/AuthenticationProvider.dart';
import 'package:safe_vault/viewmodels/RobustnessProvider.dart';

import 'package:safe_vault/models/database/Password.dart';
import 'package:safe_vault/viewmodels/DatabaseProvider.dart';

import '../models/SharedPreferencesRepository.dart';
import '../models/authentication/KeyGenerator.dart';
import '../models/authentication/SecureStorageRepository.dart';

// TODO : Remove this page, it's only for testing purposes

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
      dbKey = KeyGenerator.keyToHex(KeyGenerator.createDeriveKeyFromPassword("azerty"));
      await storage.saveDbKey(dbKey);
    }

    await dbProvider.init(dbKey);
  }

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: loadDb(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState != ConnectionState.done) {
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
          },
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Test Page 2 - Authentication Page'),

            (context.watch<SharedPreferencesRepository>().firstTime)
                ? ElevatedButton(
                    onPressed: () {
                      // Simulate register
                      context.read<AuthenticationProvider>().registerNewUser("azerty");
                    },
                    child: Text('Register'),
                  )
                : ElevatedButton(
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

class TestPage3 extends StatefulWidget {
  const TestPage3({super.key});

  @override
  State<TestPage3> createState() => _TestPage3State();
}

class _TestPage3State extends State<TestPage3> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  double _sliderValue = 1.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

    return Scaffold(
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
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),

            Slider(value: _sliderValue, onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
            }, min: 1.0, max: 4.0, divisions: 4, label: 'Category ${_sliderValue.toInt()}'),

            ElevatedButton(
              onPressed: () {
                // Save the password to the database
                String username = _usernameController.text;
                String password = _passwordController.text;
                dbProvider.insertPassword(Password(password: password, username: username, id_category: _sliderValue.toInt()));
              },
              child: Text('Save Password'),
            ),

            Divider(),

            Consumer<DatabaseProvider>(
              builder: (context, dbProvider, _) {
                final passwords = dbProvider.passwords;
                if (passwords.isEmpty) {
                  return Text("No passwords saved");
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: passwords.map((pwd) => ListTile(title: Text(pwd.username), subtitle: Text(pwd.password))).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
