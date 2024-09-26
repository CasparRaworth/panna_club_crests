import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://your-supabase-instance-url.supabase.co',
    anonKey: 'your-anon-key',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Football App'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Fixtures'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeTab(),
            FixturesTab(),
          ],
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Welcome to the Football App!',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class FixturesTab extends StatefulWidget {
  @override
  _FixturesTabState createState() => _FixturesTabState();
}

class _FixturesTabState extends State<FixturesTab> {
  List<Map<String, dynamic>> teams = [];
  List<Map<String, dynamic>> fixtures = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  // Fetch teams from Supabase
  Future<void> fetchTeams() async {
    final response = await Supabase.instance.client
        .from('teams')
        .select('id, name, logo_url');

    if (response.error == null) {
      setState(() {
        teams = List<Map<String, dynamic>>.from(response.data);
        fixtures = generateFixtures(teams); // Generate fixtures after fetching teams
        isLoading = false;
      });
    } else {
      print("Error fetching teams: ${response.error!.message}");
    }
  }

  // Generate fixtures from the fetched teams
  List<Map<String, dynamic>> generateFixtures(List<Map<String, dynamic>> teams) {
    List<Map<String, dynamic>> fixtures = [];

    for (int i = 0; i < teams.length; i++) {
      for (int j = 0; j < teams.length; j++) {
        if (i != j) {
          fixtures.add({
            'home': teams[i],
            'away': teams[j],
          });
        }
      }
    }
    return fixtures;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: fixtures.length,
            itemBuilder: (context, index) {
              final fixture = fixtures[index];
              final homeTeam = fixture['home'];
              final awayTeam = fixture['away'];

              return ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      homeTeam['logo_url'],
                      width: 40,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image);
                      },
                    ),
                    const SizedBox(width: 10),
                    Image.network(
                      awayTeam['logo_url'],
                      width: 40,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image);
                      },
                    ),
                  ],
                ),
                title: Text(
                  '${homeTeam['name']} vs ${awayTeam['name']}',
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Text('Match ${index + 1}'),
              );
            },
          );
  }
}


