import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vxemkwxzzmbmdwlulmgr.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ4ZW1rd3h6em1ibWR3bHVsbWdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjcwODY5MzcsImV4cCI6MjA0MjY2MjkzN30.dN4gyIFngUzy0BDYOzCQG4wi3AWUha80Cn15JlXOWKg',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Teams',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _future = Supabase.instance.client
      .from('teams')
      .select();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final teams = snapshot.data!;
          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              return ListTile(
                leading: team['logo_url'] != null
                    ? Image.network(
                        team['logo_url'],
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image);
                        },
                      )
                    : const Icon(Icons.image_not_supported),
                title: Text(team['name']),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const fixturesSim()),
          );
        },
        child: const Icon(Icons.list),
        tooltip: 'Go to Fixtures',
      ),
    );
  }
}

// Define the Fixtures Simulation Page
class fixturesSim extends StatelessWidget {
  const fixturesSim({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixtures Simulation'),
      ),
      body: const Center(
        child: Text(
          'This is the Fixtures Simulation page.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}


