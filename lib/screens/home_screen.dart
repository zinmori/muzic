import 'package:flutter/material.dart';
import 'package:muzic/screens/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
      future: _audioQuery.querySongs(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No song found...',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.transparent,
                child: ListTile(
                  leading: Image.asset(
                    'assets/images/zhead.jpeg',
                    height: 50,
                    width: 50,
                  ),
                  title: Text(
                    snapshot.data![index].title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) {
                          return Player(
                            index: index,
                            musicFile: snapshot.data![index],
                            playlist: snapshot.data!,
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
