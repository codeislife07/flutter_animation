import 'package:flutter/material.dart';

import 'black_hole_clipper.dart';
import 'hello_wordl_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        // useMaterial3: true,
      ),
      home:CardHiddenAnimationPage()
    );
  }

}

class CardHiddenAnimationPage extends StatefulWidget {
  const CardHiddenAnimationPage({Key? key}) : super(key: key);

  @override
  State<CardHiddenAnimationPage> createState() =>
      CardHiddenAnimationPageState();
}

class CardHiddenAnimationPageState extends State<CardHiddenAnimationPage>
    with TickerProviderStateMixin {
  final cardSize = 150.0;
  late final holeSizeTween = Tween<double>(
    begin: 0,
    end: 1.5 * cardSize,
  );
  late final holeAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  double get holeSize => holeSizeTween.evaluate(holeAnimationController);


  late final cardOffsetAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  late final cardOffsetTween = Tween<double>(
    begin: 0,
    end: 2 * cardSize,
  ).chain(CurveTween(curve: Curves.easeInBack));
  late final cardRotationTween = Tween<double>(
    begin: 0,
    end: 0.5,
  ).chain(CurveTween(curve: Curves.easeInBack));
  late final cardElevationTween = Tween<double>(
    begin: 2,
    end: 20,
  );

  double get cardOffset =>
      cardOffsetTween.evaluate(cardOffsetAnimationController);
  double get cardRotation =>
      cardRotationTween.evaluate(cardOffsetAnimationController);
  double get cardElevation =>
      cardElevationTween.evaluate(cardOffsetAnimationController);





  @override
  void initState() {
    holeAnimationController.addListener(() => setState(() {}));
    cardOffsetAnimationController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    holeAnimationController.dispose();
    cardOffsetAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () async{
              holeAnimationController.forward();
              await cardOffsetAnimationController.forward();
              Future.delayed(const Duration(milliseconds: 200),
                      () => holeAnimationController.reverse());
            },
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () async{
              cardOffsetAnimationController.reverse();
              holeAnimationController.reverse();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          height: cardSize * 1.25,
          width: double.infinity,
          // TODO: wrap Stack with ClipPath
          child: ClipPath(
            clipper: BlackHoleClipper(),
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: holeSize, // animate the black hole
                  child: Image.asset(
                    'assets/hole.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(0, cardOffset), // TODO: Animate the offset
                      child: Transform.rotate(
                        angle: 0, // TODO: Animate the angle
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: HelloWorldCard(
                            size: cardSize,
                            elevation: 2, // TODO: Animate the elevation
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

