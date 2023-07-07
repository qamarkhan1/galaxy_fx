import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/utils/config.dart';
import 'package:forex_guru/widgets/cust_button.dart';
import 'package:forex_guru/widgets/cust_prog_ind.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/widgets/lazy_load_wid.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CoursesList extends StatefulWidget {
  const CoursesList({
    Key? key,
    // required this.ref,
    required this.data,
  }) : super(key: key);

  // final String ref;
  final Map data;
  @override
  State<CoursesList> createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  late VideoPlayerController _videoPlayerController1;
  AllRepos allRepos = AllRepos();

  ChewieController? _chewieController;
  int? bufferDelay;

  @override
  void initState() {
    getClassesContents();
    initializePlayer([]);
    loadMore(true);

    super.initState();
  }

  List<int> lData = [];
  int currentLength = 0;

  final int increment = 10;
  bool isLoading = false;

  Future loadMore(bool isInit) async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: isInit ? 0 : 2));
    for (var i = currentLength; i <= currentLength + increment; i++) {
      lData.add(i);
    }
    setState(() {
      isLoading = false;
      currentLength = lData.length;
    });
  }

  @override
  void dispose() {
    _chewieController?.dispose();

    disposePlayer();
    super.dispose();
  }

  initializePlayer(List srcList) async {
    List? srcs = await allRepos.getClassesContents(widget.data['reference']);

    if (srcs.isNotEmpty) {
      List videoSrcs = [];
      for (var src in srcs) {
        videoSrcs.add(src['video_url']);
      }
      _videoPlayerController1 = VideoPlayerController.network(
        videoSrcs[currPlayIndex],
      );
      await Future.wait([
        _videoPlayerController1.initialize(),
      ]);
      _createChewieController(videoSrcs, currPlayIndex);
      setState(() {});
    }
  }

  disposePlayer() {
    _videoPlayerController1.dispose();
  }

  Future<List>? future;
  getClassesContents() {
    future = allRepos.getClassesContents(widget.data['reference']);
  }

  void _createChewieController(List srcList, int index) {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: false,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      additionalOptions: (context) {
        return <OptionItem>[
          OptionItem(
            onTap: () => toggleVideo(srcList, index),
            iconData: Icons.live_tv_sharp,
            title: 'Toggle Video Src',
          ),
        ];
      },
      hideControlsTimer: const Duration(seconds: 5),

      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      placeholder: Container(
        color: black,
      ),

      // autoInitialize: true,
    );

    _chewieController?.addListener(() {
      final isFullScreen = _chewieController?.isFullScreen;
      if (isFullScreen == false) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        Future.delayed(const Duration(seconds: 1)).then((_) =>
            SystemChrome.setPreferredOrientations(DeviceOrientation.values));
      }
    });
  }

  int currPlayIndex = 0;

  Future<void> toggleVideo(List srcList, int index) async {
    // await _videoPlayerController1.pause();
    currPlayIndex = index;

    await disposePlayer();

    await initializePlayer(srcList);
  }

  int index = 0;

  List thumbnails = [];

  @override
  Widget build(BuildContext context) {
    final List<Tab> myTabs = <Tab>[
      const Tab(text: 'Info'),
      const Tab(text: 'Contents'),
    ];

    String lastUpdate = allRepos.getNewDate(widget.data['updated_at']);
    // print('ref $ref');
    Size med = MediaQuery.of(context).size;
    return CustScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            index == 0
                ? CourseHeaderWid(
                    image: widget.data['cover_image'],
                    // 'https://a.c-dn.net/b/1rjm0X/headline_shutterstock_283169099.jpg',
                    hasPlay: false,
                  )
                : Container(
                    height: 300,
                    color: black,
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: _chewieController != null &&
                              _chewieController!
                                  .videoPlayerController.value.isInitialized
                          ? Chewie(
                              controller: _chewieController!,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CustProgIndicator(),
                              ],
                            ),
                    ),
                  ),
            // const CourseHeaderWid(
            //   image:
            //       'https://a.c-dn.net/b/1rjm0X/headline_shutterstock_283169099.jpg',
            //   hasPlay: true,
            // ),
            DefaultTabController(
              length: myTabs.length,
              child: SizedBox(
                height: med.height,
                child: Column(
                  children: [
                    TabBar(
                      tabs: myTabs,
                      labelColor: primaryColor,
                      onTap: (int ind) {
                        setState(() {
                          index = ind;
                        });
                      },
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.data['level'],

                                  // 'Beginner Class',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  widget.data['description'],

                                  // 'In this class we teach you the fundamentals and terminologies of forex.',
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.data['average_rating']
                                          .toStringAsFixed(1),

                                      // '4.4',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Row(
                                      children: [
                                        RatingBar.builder(
                                          initialRating:
                                              widget.data['average_rating'],

                                          // 4.4,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 2.0),
                                          itemSize: 20,
                                          itemBuilder: (context, _) => Icon(
                                            IconlyBold.star,
                                            color: primaryColor,
                                          ),
                                          onRatingUpdate: (rating) {
                                            // ignore: avoid_print
                                            print(rating);
                                          },
                                          ignoreGestures: true,
                                        ),
                                        const SizedBox(width: 20),
                                        !widget.data['enrolled']
                                            ? const SizedBox.shrink()
                                            : GestureDetector(
                                                onTap: () => popRate(
                                                    widget.data, allRepos),
                                                child: const Text('Rate Now')),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${widget.data['total_raters']} ratings of ${widget.data['total_enrolled']} students',
                                ),
                                ListTile(
                                  leading: const Icon(IconlyLight.calendar),
                                  title: Text('Last Updated $lastUpdate'),
                                ),
                                ListTile(
                                  leading: const Icon(IconlyLight.discovery),
                                  title: Text(widget.data['language']),
                                ),
                                // const ListTile(
                                //   leading: Icon(IconlyLight.timeSquare),
                                //   title: Text('4 hours on demand video'),
                                // ),
                                const Text(
                                  'What you will learn',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                ListTile(
                                  leading: const Icon(IconlyLight.tickSquare),
                                  title: Text(widget.data['you_learn']),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Requirements',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                ListTile(
                                  leading: const Icon(IconlyLight.dangerCircle),
                                  title: Text(widget.data['requirement']),
                                ),

                                const SizedBox(height: 5),
                                widget.data['enrolled']
                                    ? const SizedBox.shrink()
                                    : CustButton(
                                        onTap: () => popConfirmation(
                                            widget.data, allRepos),
                                        title: 'Enroll',
                                      ),
                                const SizedBox(height: 5),
                                CustButton(
                                  onTap: () {},
                                  title: 'Share',
                                  isHollow: true,
                                ),
                              ],
                            ),
                          ),
                          FutureBuilder<List?>(
                              future: future,
                              builder: (context, snapshot) {
                                return allRepos.snapshotFuture(
                                  snapshot,
                                  LazyLoadWid(
                                    isLoading: isLoading,
                                    data: snapshot.data == null
                                        ? []
                                        : snapshot.data!,
                                    lData: lData,
                                    onEndOfPage: () => loadMore(false),
                                    itemBuilder: (context, index) {
                                      var dt = snapshot.data!;
                                      List videoSrcs = [];
                                      for (var dts in dt) {
                                        videoSrcs.add(dts['video_url']);
                                      }

                                      // print('video $videoSrcs');

                                      return CourseContentWid(
                                        title: dt[index]['title'],
                                        videoUrl: dt[index]['video_url'],
                                        onTap: () =>
                                            toggleVideo(videoSrcs, index),
                                      );
                                    },
                                  ),
                                  hasBack: false,
                                );
                              })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  popRate(
    data,
    AllRepos allRepos,
  ) {
    double currentRating = 3.0;
    allRepos.showPopUp(
        Center(
          child: RatingBar.builder(
            initialRating: currentRating,
            minRating: 1,
            // direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
            itemBuilder: (context, _) => Icon(Icons.star, color: primaryColor),
            itemSize: 25,
            onRatingUpdate: (rating) {
              currentRating = rating;
            },
          ),
        ),
        [
          CupertinoButton(
            child: const Text("Rate"),
            onPressed: () async {
              try {
                Map body = {
                  'class_reference': data['reference'],
                  'rating': currentRating,
                };
                await allRepos.rateCourse(body);
                setState(() {});
              } catch (e) {
                allRepos.showFlush(
                  e.toString(),
                  backgroundColor: red,
                );
              }
            },
          ),
          CupertinoButton(
            child: const Text("No"),
            onPressed: () => Get.back(),
          ),
        ],
        []);
  }

  popConfirmation(data, AllRepos allRepos) {
    return allRepos.showPopUp(
      const Text('Are you sure you want to Enroll for this course?'),
      [
        CupertinoButton(
          child: const Text("Yes"),
          onPressed: () async {
            try {
              Map body = {
                'class_reference': data['reference'],
              };
              await allRepos.enroll(body);
              Future.delayed(const Duration(seconds: 1)).then(
                (value) => Get.back(),
              );
              setState(() {});
            } catch (e) {
              allRepos.showFlush(e.toString(), success: false);
            }
          },
        ),
        CupertinoButton(
          child: const Text("No"),
          onPressed: () => Get.back(),
        ),
      ],
      [
        TextButton(
          child: const Text("Yes"),
          onPressed: () async {
            try {
              Map body = {
                'class_reference': data['reference'],
              };
              await allRepos.enroll(body);
              setState(() {});
            } catch (e) {
              allRepos.showFlush(e.toString(), success: false);
            }
          },
        ),
        TextButton(
          child: const Text("No"),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }
}

class CourseHeaderWid extends StatelessWidget {
  const CourseHeaderWid({
    Key? key,
    required this.image,
    required this.hasPlay,
  }) : super(key: key);

  final String image;
  final bool hasPlay;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: grey,
        image: DecorationImage(
          image: CachedNetworkImageProvider(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        height: 300,
        color: black.withOpacity(0.5),
        child: Center(
          child: hasPlay
              ? Icon(
                  IconlyLight.play,
                  size: 100,
                  color: white,
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class CourseContentWid extends StatefulWidget {
  const CourseContentWid({
    Key? key,
    required this.title,
    required this.videoUrl,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String videoUrl;
  final Function()? onTap;

  @override
  State<CourseContentWid> createState() => _CourseContentWidState();
}

class _CourseContentWidState extends State<CourseContentWid> {
  @override
  void initState() {
    getThumb();
    super.initState();
  }

  late Future<Uint8List?> _future;
  getThumb() {
    _future = getThumbnail(widget.videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          InkWell(
            onTap: null,
            child: SizedBox(
              width: med.width,
              child: Row(
                children: [
                  FutureBuilder<Uint8List?>(
                      future: _future,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.data == null ||
                            snapshot.data!.isEmpty ||
                            snapshot.hasError) {
                          return SizedBox(
                              height: 100,
                              width: 120,
                              child: snapshot.hasData ||
                                      snapshot.data == null ||
                                      snapshot.data!.isEmpty
                                  ? Image.asset('assets/images/null_image.png')
                                  : Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                    ));
                        } else {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              height: 100,
                              width: 120,
                            ),
                          );
                        }
                      }),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: GoogleFonts.aBeeZee().fontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Play',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Icon(
                                    Feather.video,
                                    color: white,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Divider(
            color: accent,
          ),
        ],
      ),
    );
  }

  // List thumbnails = [];
  Future<Uint8List?> getThumbnail(String videoUrl) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      quality: 50,
      timeMs: 10000,
    );

    return uint8list;
  }
}
