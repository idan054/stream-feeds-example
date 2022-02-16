import 'package:feeds_tutorial/dummy_app_user.dart';
import 'package:feeds_tutorial/utils/utils.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Feed Demo',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login with a User',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 42),
              for (final user in DummyAppUser.values)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 4.0),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      context.showSnackbar('Loading User');

                      // final _client = StreamFeedClient.connect("ay57s8swfnan", token: user.token);
                      final secret = 'gfcfa94ghkctn3du36s2d4nmqg9q24wtxhr56qd84pj7dum94ahhtedccj8q7wk4';
                      final apiKey = 'ah48ckptkjvm';
                      final appId = '1164896';

                      // # 1. Set a Server Client
                      // instantiate a new serverClient (server side)
                      final serverClient = StreamFeedClient.connect(apiKey,
                        secret: secret,
                        appId: appId,
                        runner: Runner.server,
                      );

                      // # 2. Set a feed for the user - .flatFeed(Feed_Name, User_Id);
                      //           userClient.flatFeed(...); // Doesnt matter?
                      final idad = serverClient.flatFeed('test_uesr', 'idan2');
                      print('idad.userToken');
                      print(idad.userToken);
                      print(idad.feedId.slug);

                      // # 3. Add & Get activities for the feed
                      // at least 1 is needed to find the feed on the stream Explorer.
                      // tip: you can add unlimited custom fields (like 'message')
                      await idad.addActivity(Activity(
                          actor: 'idad',
                          verb: 'add',
                          object: 'picture:10',
                          foreignId: 'picture:10',
                          extraData: {'message': 'Beautiful bird!'}));

                      final results = await idad.getActivities(limit: 10);
                      print('results');
                      print(results);

                      // # 4. Set a userClient to get user details
                      var userToken = serverClient.frontendToken('idan2'); // user_id
                      final userClient = StreamFeedClient.connect(apiKey,
                        token: userToken,
                        appId: appId,
                        runner: Runner.client,
                      );


                      var cUser = await userClient.currentUser?.get();
                      // print('get user 1 ${cUser?.data}');
                      // Post: needed for 1st time, but to update use - userClient.currentUser?.update({

                      final _user = await userClient.setUser({
                        'first_name': 'idan Y',
                        'nFeild' : 'lol',
                        'last_name': 'biton',
                        'full_name': 'idan biton',
                      });

                      cUser = await userClient.currentUser?.update({
                        'first_name': 'idan Y',
                        'nFeild' : 'lol',
                        'last_name': 'biton',
                        'full_name': 'idan biton',
                      });
                      cUser = await userClient.currentUser?.get();
                      print('get user 2 ${cUser?.data}');
                      // print(_client.collections);


                     // Create a following relationship between Jack's "timeline" feed and Chris' "user" feed:
                     //  final jack = client.flatFeed('timeline', 'jack');
                     //  await jack.follow(chris);
                     //
                     //  // Read Jack's timeline and Chris' post appears in the feed:
                     //  final results = await jack.getActivities(limit: 10);
                     //
                     //  // Remove an Activity by referencing it's Foreign Id:
                     //  await chris.removeActivityByForeignId('picture:10');


                      context.showSnackbar('User Loaded');

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) =>
                              ClientProvider( // Here we are wrapping our application using a client provider.
                                client: userClient,
                                child: HomeScreen(
                                    streamUser: cUser!), // Pass the _user variable to the streamUser param
                              ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 36.0, horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            user.name!,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.blue,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
