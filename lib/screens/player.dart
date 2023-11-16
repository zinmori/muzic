import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:muzic/providers/favorites_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends ConsumerStatefulWidget {
  const Player({
    super.key,
    required this.index,
    required this.musicFile,
    required this.playlist,
  });
  final int index;
  final SongModel musicFile;
  final List<SongModel> playlist;

  @override
  ConsumerState<Player> createState() {
    return _Player();
  }
}

class _Player extends ConsumerState<Player> {
  late AudioPlayer _audioPlayer;

  void _init() {
    _audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: [
          for (final music in widget.playlist)
            AudioSource.uri(
              Uri.parse(music.uri!),
              tag: MediaItem(
                id: music.id.toString(),
                title: music.title,
              ),
            ),
        ],
      ),
      initialIndex: widget.index,
    );
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _init();
    _audioPlayer.setLoopMode(LoopMode.off);
    _audioPlayer.setShuffleModeEnabled(false);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteSongs = ref.watch(favoriteSongsProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData().copyWith(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color.fromARGB(255, 83, 83, 83)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/z.jpg'),
            ),
            const SizedBox(height: 15),
            StreamBuilder(
              stream: _audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final currentMusic =
                    snapshot.data!.currentSource!.tag as MediaItem;

                return Column(
                  children: [
                    Text(
                      currentMusic.title,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(favoriteSongsProvider.notifier)
                            .toggleSongFavoriteStatus(
                                widget.playlist[_audioPlayer.currentIndex!]);
                      },
                      icon: Icon(
                        Icons.favorite_rounded,
                        color: favoriteSongs.any((element) =>
                                element.id.toString() == currentMusic.id)
                            ? Colors.red[900]
                            : Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 5),
            StreamBuilder(
              stream: _audioPlayer.positionStream,
              builder: (context, snapshot) {
                return ProgressBar(
                  progress: snapshot.data!,
                  total: _audioPlayer.duration ??
                      Duration(milliseconds: widget.musicFile.duration!),
                  thumbColor: Colors.white,
                  progressBarColor: Colors.white,
                  baseBarColor: Colors.grey[900],
                  timeLabelTextStyle: const TextStyle(color: Colors.white),
                  onSeek: (value) {
                    _audioPlayer.seek(value);
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _audioPlayer.seekToPrevious,
                  icon: const Icon(
                    Icons.skip_previous_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                StreamBuilder(
                    stream: _audioPlayer.playingStream,
                    builder: (context, snapshot) {
                      return IconButton(
                        onPressed: () {
                          if (snapshot.data!) {
                            _audioPlayer.pause();
                          } else {
                            _audioPlayer.play();
                          }
                        },
                        icon: Icon(
                          snapshot.data!
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 100,
                        ),
                      );
                    }),
                IconButton(
                  onPressed: _audioPlayer.seekToNext,
                  icon: const Icon(
                    Icons.skip_next_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder(
                  stream: _audioPlayer.shuffleModeEnabledStream,
                  builder: (context, snapshot) {
                    return IconButton(
                      onPressed: () async {
                        if (snapshot.data!) {
                          await _audioPlayer.setShuffleModeEnabled(false);
                        } else {
                          await _audioPlayer.setShuffleModeEnabled(true);
                        }
                      },
                      icon: Icon(
                        snapshot.data == false
                            ? Icons.shuffle_rounded
                            : Icons.shuffle_on_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    );
                  },
                ),
                StreamBuilder(
                  stream: _audioPlayer.loopModeStream,
                  builder: (context, snapshot) {
                    return IconButton(
                      onPressed: () async {
                        if (snapshot.data == LoopMode.all) {
                          await _audioPlayer.setLoopMode(LoopMode.one);
                        } else if (snapshot.data == LoopMode.one) {
                          await _audioPlayer.setLoopMode(LoopMode.off);
                        } else {
                          await _audioPlayer.setLoopMode(LoopMode.all);
                        }
                      },
                      icon: Icon(
                        snapshot.data == LoopMode.all
                            ? Icons.repeat_on_rounded
                            : snapshot.data == LoopMode.one
                                ? Icons.repeat_one_rounded
                                : Icons.repeat_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
