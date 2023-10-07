import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textController = TextEditingController();
  WebViewController webViewController = WebViewController();

  bool isLoading = false;
  double? progressValue;
  bool goBack = false;
  bool goForward = false;
  bool isFavorite = false;
  bool hasErr = false;
  String homePage = 'https://flutter.dev/';
  List<String> historyList = [];
  List<String> favoritesList = [];

  @override
  void initState() {
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) async {
            if (!hasErr) {
              progressValue = progress / 100;
              setState(() {});
              goBack = await webViewController.canGoBack();
              goForward = await webViewController.canGoForward();
              setState(() {});
            }
            if (progress == 100) {
              isLoading = false;
              progressValue = 0;
              setState(() {});
            }
          },
          onWebResourceError: (WebResourceError error) {
            isLoading = false;
            hasErr = true;
            progressValue = 0;
            setState(() {});
          },
          onUrlChange: (change) {
            isLoading = true;
            hasErr = false;
            progressValue = null;
            isFavorite = favoritesList.contains(change.url!);
            textController.text = change.url!;
            historyList.add(change.url!);
            setState(() {});
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.youtube.com/'));
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        automaticallyImplyLeading: false,
        actions: <Widget>[Container()],
        flexibleSpace: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (goBack) {
                            webViewController.goBack();
                          }
                        },
                        icon: Icon(
                          Icons.arrow_left,
                          color: goBack ? Colors.black : Colors.grey,
                        ),
                        iconSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (goForward) {
                            webViewController.goForward();
                          }
                        },
                        icon: Icon(
                          Icons.arrow_right,
                          color: goForward ? Colors.black : Colors.grey,
                        ),
                        iconSize: 20,
                      ),
                    ),
                    SizedBox(
                      child: IconButton(
                        onPressed: () {
                          webViewController.reload();
                        },
                        icon: Icon(isLoading ? Icons.close : Icons.refresh),
                        iconSize: 20,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        child: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () async {
                                String url =
                                    (await webViewController.currentUrl())!;
                                if (!isFavorite) {
                                  favoritesList.add(url);
                                } else {
                                  favoritesList
                                      .removeWhere((element) => element == url);
                                }
                                isFavorite = favoritesList.contains(url);
                                setState(() {});
                              },
                              icon: Icon(
                                  isFavorite ? Icons.star : Icons.star_border),
                            ),
                            contentPadding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide.none),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          onSubmitted: (value) {
                            webViewController.loadRequest(Uri.parse(value));
                          },
                        ),
                      ),
                    ),
                    PopupMenuButton(
                      color: Colors.grey.shade300,
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      onSelected: (value) async {
                        switch (value) {
                          case 0:
                            break;
                          case 1:
                        }
                        if (value == 0) {
                          webViewController.loadRequest(Uri.parse(homePage));
                        } else {
                          await showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              var list =
                                  value == 1 ? favoritesList : historyList;
                              return AlertDialog(
                                content: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      child: Column(
                                        children: [
                                          Text(value == 1
                                              ? 'Favorites'
                                              : 'History'),
                                          const Divider(),
                                          Expanded(
                                            child: Scrollbar(
                                              child: ListView.builder(
                                                  itemCount: list.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              list[index],
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              list.removeAt(
                                                                  index);
                                                              if (list
                                                                  .isEmpty) {
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                              setState(() {});
                                                            },
                                                            icon: const Icon(
                                                                Icons.delete)),
                                                      ],
                                                    );
                                                  }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem<int>(
                            value: 0,
                            child: Row(
                              children: [
                                Icon(Icons.home_outlined),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Home Page'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuItem<int>(
                            value: 1,
                            child: Row(
                              children: [
                                Icon(Icons.star_border),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Favorites'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuItem<int>(
                            value: 2,
                            child: Row(
                              children: [
                                Icon(Icons.history),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('History'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
              ),
              if (isLoading)
                LinearProgressIndicator(
                  value: progressValue,
                ),
            ],
          ),
        ),
      ),
      body: WebViewWidget(
        controller: webViewController,
      ),
    );
  }
}
