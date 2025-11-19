import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_factory/cubit/game_state/game_state.dart';
import 'package:flutter_factory/cubit/game_state/game_state_cubit.dart';
import 'package:flutter_factory/object/logical/add_object.dart';
import 'package:flutter_factory/object/entity/block.dart';
import 'package:flutter_factory/object/entity/camera.dart';
import 'package:flutter_factory/object/entity/character.dart';
import 'package:flutter_factory/object/game_object.dart';
import 'package:flutter_factory/object/logical/input.dart';
import 'package:flutter_factory/viewport/game_painter.dart';
import 'package:flutter_factory/widgets/input_listener.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //shutdown GameIsolate on app exit
  AppLifecycleListener(
    onExitRequested: () async {
      print('exit');
      //
      return AppExitResponse.exit;
    },
    onRestart: () {
      print('restart');
    },
    onDetach: () => print('detach'),
  );
  runApp(const MyApp());
  print('after runapp');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // scrollBehavior: const MaterialScrollBehavior().copyWith(
      //   // Mouse dragging enabled for this demo
      //   dragDevices: {PointerDeviceKind.mouse},
      // ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SplayTreeMap<int, Map<String, GameObject>>? gameObjects;
  @override
  Widget build(BuildContext context) {
    // if (gameObjects == null) {
    gameObjects = SplayTreeMap<int, Map<String, GameObject>>();
    gameObjects![0] =
        {}..addEntries(
          [
            Zoom(),
            AddObject(),
            KeyboardInput(),
            PointerInput(),
            for (int j = -5; j <= 5; j++)
              for (int k = -5; k <= 5; k++)
                if (j != 0 || k != 0)
                  Block(
                    size: Size.square(50),
                    position: Offset(j * 50.0, k * 50.0),
                  ),
            
          ].map((e) => MapEntry(e.uid, e)),
        );
    gameObjects![1000] =
        {}..addEntries(
          [Character(size: Size.square(50), position: Offset.zero, rotation: 0)]
              .map((e) => MapEntry(e.uid, e)),
        );
    gameObjects![2000] =
        {}..addEntries(
          [
            Camera(targetPosition: Offset.zero, position: Offset.zero),
          ].map((e) => MapEntry(e.uid, e)),
        );
    // }
    return Scaffold(
      body: MultiProvider(
        providers: [
          // BlocProvider.value(value: GameStateBloc()),
          // BlocProvider.value(value: CharacterCubit(CharacterState())),
          BlocProvider.value(
            value: GameStateCubit(
              GameState(
                gameObjects: gameObjects!,
              ),
            ),
          ),
        ],
        child: LayoutBuilder(
          builder: (context, constraints) {
            return InputListener(
              child: SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                // constraints: constraints,
                child: Stack(
                  children: [
                    GamePaint(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),

                    //inventory bar
                    Positioned(
                      bottom: 20,
                      width: constraints.maxWidth,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.add), isSelected: true,),
                          IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
