// Add Stream import
import 'package:stream_feed/stream_feed.dart';

void main() async {
  print('Loading User');

  final secret =
      'gfcfa94ghkctn3du36s2d4nmqg9q24wtxhr56qd84pj7dum94ahhtedccj8q7wk4';
  final apiKey = 'ah48ckptkjvm';
  final appId = '1164896';

  // instantiate a new serverClient (server side)
  final serverClient = StreamFeedClient.connect(
    apiKey,
    secret: secret,
    appId: appId,
    runner: Runner.server,
  );
  final userToken = serverClient.frontendToken("chris2");
  final userClient =
      StreamFeedClient.connect(apiKey,
          token: userToken,
          appId: appId,
          runner: Runner.client,
      );

  print(userClient.currentUser?.userId);
  print(userClient.currentUser?.userToken);
  print(userClient.currentUser?.ref);

  final chris = serverClient.flatFeed('test_uesr', 'chris2');

// Add an Activity; message is a custom field - tip: you can add unlimited custom fields!
  await chris.addActivity(Activity(
      actor: 'chris',
      verb: 'add',
      object: 'picture:10',
      foreignId: 'picture:10',
      extraData: {'message': 'Beautiful bird!'}));

  print('User Loaded');
}
