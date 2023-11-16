import 'package:flutter/material.dart';
import 'package:muzic/screens/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key, required this.favoriteSongs});
  final List<SongModel> favoriteSongs;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: favoriteSongs.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color.fromARGB(0, 0, 0, 0),
            child: ListTile(
              leading: Image.asset('assets/images/zhead.jpeg'),
              title: Text(
                favoriteSongs[index].title,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => Player(
                      index: index,
                      musicFile: favoriteSongs[index],
                      playlist: favoriteSongs,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
