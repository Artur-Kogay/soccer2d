import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// void main(){
//
//   WidgetsFlutterBinding.ensureInitialized();
//
//   Flame.device.setLandscape();
//   Flame.device.fullScreen();
//
//   runApp(GameWidget(
//   game: game,
//   ));
// }

class MainGame extends StatelessWidget {
  const MainGame({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: game,
      overlayBuilderMap: const {
        "PauseMenu": _pauseMenuBuilder,
      },
    );
  }
}

int maxScore = 10;

Widget _pauseMenuBuilder(BuildContext buildContext, Game game) {
  return Center(
    child: Stack(
      children: [
        Container(color: Colors.black.withOpacity(.75)),
        Container(
            margin: EdgeInsets.symmetric(vertical: 50, horizontal: 200),
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.indigoAccent,
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: Border.all(color: Colors.black, width: 3)),
            child: Wrap(
              children: [
                Column(
                  children: [
                    Text(
                      enemyScore >= maxScore ? "You lose!" : "You win!",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          decoration: TextDecoration.none),
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    // Text("9 : 10" ,
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 35,
                    //       decoration: TextDecoration.none,
                    //     )),
                    new RichText(
                      text: new TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: new TextStyle(
                          fontSize: 55.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          new TextSpan(text: playerScore.toString(), style: new TextStyle(color: Colors.lightGreenAccent, fontWeight: FontWeight.bold)),
                          new TextSpan(text: ' : ', style: TextStyle(color: Colors.white)),
                          new TextSpan(text: enemyScore.toString(), style: new TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Container(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => {
                          game.RestartGame()
                        },
                        child: Text(
                          "Restart",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue),
                      ),
                    )
                  ],
                )
              ],
            )),
      ],
    ),
  );
}

Widget overlayBuilder() {
  return GameWidget<Game>(
    game: Game()..paused = true,
    overlayBuilderMap: const {
      'PauseMenu': _pauseMenuBuilder,
    },
    initialActiveOverlays: const ['PauseMenu'],
  );
}

Game game = Game();
Player player = Player();
Enemy enemy = Enemy();
Ball ball = Ball();

Vector2 gravity = Vector2(0, 50);

Vector2 frameSize = Vector2(360, 360);
double animationStepTime = 0.06;

int playerScore = 0;
int enemyScore = 0;

TextComponent textComponent = TextComponent(
    text: playerScore.toString() + " : " + enemyScore.toString(),
    anchor: Anchor.center,
    position: Vector2(game.canvasSize.x / 2, 30),
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 35,
      ),
    ));

class Game extends Forge2DGame{

  SpriteComponent bg = SpriteComponent();
  InGameButton rBtn = InGameButton();
  InGameButton lBtn = InGameButton();
  InGameButton uBtn = InGameButton();

  bool shouldResetGame = false;


  @override
  Future<void> onLoad() async {
    super.onLoad();

    world.gravity = gravity;
    world.physicsWorld.gravity = gravity;

    bg
      ..sprite = await loadSprite("bg.png")
      ..size = Vector2(size.x, size.y)
    ;
    add(bg);

    rBtn
      ..sprite = await loadSprite("rBtn.png")
      ..anchor = Anchor.center
      ..scale = Vector2.all(.7)
      ..position = Vector2(175, canvasSize.y - 30)
    ;

    lBtn
      ..sprite = await loadSprite("lBtn.png")
      ..anchor = Anchor.center
      ..scale = Vector2.all(.7)
      ..position = Vector2(100, canvasSize.y - 30)
    ;

    uBtn
      ..sprite = await loadSprite("uBtn.png")
      ..anchor = Anchor.center
      ..scale = Vector2.all(.7)
      ..position = Vector2(canvasSize.x - 100, canvasSize.y - 30)
    ;

    add(lBtn);
    add(rBtn);
    add(uBtn);


    world.add(ball);
    world.add(player);
    world.add(enemy);
    world.add(Goal(true));
    world.add(Goal(false));

    world.add(FilledWall(Vector2(-39.5, -13)));
    world.add(FilledWall(Vector2(39.5, -13)));

    world.addAll(createBoundaries());

    add(textComponent);
  }

  void resetGame(){
    enemy.body.linearVelocity = Vector2.zero();
    enemy.body.clearForces();
    enemy.body.setTransform(enemy.startPos, 0);

    player.body.linearVelocity = Vector2.zero();
    player.body.clearForces();
    player.body.setTransform(player.startPos, 0);

    ball.body.linearVelocity = Vector2.zero();
    ball.body.clearForces();
    ball.body.setTransform(ball.startPos, 0);

    shouldResetGame = false;
  }

  void EndGame(){
    overlays.add('PauseMenu');
    pauseEngine();
  }

  void CheckGameResults(){
    if(enemyScore >= maxScore || playerScore >= maxScore){
      EndGame();
    }
  }

  void RestartGame(){
    overlays.remove('PauseMenu');
    resumeEngine();

    playerScore = 0;
    enemyScore = 0;
    textComponent.text = playerScore.toString() + " : " + enemyScore.toString();

    resetGame();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if(rBtn.isPressed){
      player.move(Vector2(1, 0));
    }
    if(lBtn.isPressed){
      player.move(Vector2(-1, 0));
    }
    if(uBtn.isPressed){
      player.jump();
    }

    if(shouldResetGame){
      resetGame();
    }
  }

  List<Component> createBoundaries() {
    final visibleRect = camera.visibleWorldRect;
    final topLeft = visibleRect.topLeft.toVector2();
    final topRight = visibleRect.topRight.toVector2();
    final bottomRight = visibleRect.bottomRight.toVector2();
    final bottomLeft = visibleRect.bottomLeft.toVector2();

    return [
      Wall(topLeft, topRight),
      Wall(topRight, bottomRight),
      Wall(Vector2(bottomLeft.x, bottomLeft.y - 7), Vector2(bottomRight.x, bottomRight.y - 7)),
      Wall(topLeft, bottomLeft),
    ];
  }
}

class Player extends Pawn{

  double moveSpeed = 40;
  double jumpForce = 850;

  double floorPos = game.camera.visibleWorldRect.bottomLeft.toVector2().y - 12;

  Vector2 colliderSize = Vector2(3.1, 5.6);
  Vector2 startPos = Vector2(
      game.camera.visibleWorldRect.bottomLeft.toVector2().x + 15,
      game.camera.visibleWorldRect.bottomLeft.toVector2().y - 12);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    renderBody = false;

    final sprite = await game.loadSprite('Player.png');
    add(
      SpriteComponent(
          sprite: sprite,
          anchor: Anchor.center,
          scale: Vector2.all(0.05)
      ),
    );
  }

  void move(Vector2 dir){
    body.linearVelocity = Vector2(dir.x * moveSpeed, body.linearVelocity.y);
  }

  void jump(){
    if(body.position.y >= floorPos-1){
      //body.linearVelocity = Vector2(body.linearVelocity.x, -30);
      body.applyLinearImpulse((Vector2(0, -1) * jumpForce) * 100);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if(body.position.x >= -2.5){
      body.setTransform(Vector2(-2.5, body.position.y), 0);
    }
  }


  @override
  void onMount() async {
    super.onMount();

    MassData massData = MassData();
    massData.mass = 5000;

    body.setMassData(massData);
  }

  @override
  Body createBody() {
    FixtureDef fixtureDef = FixtureDef(PolygonShape()..setAsBoxXY(colliderSize.x, colliderSize.y), friction: 10, restitution: 0, density: 1);
    BodyDef bodyDef = BodyDef(userData: this, position: startPos, type: BodyType.dynamic, fixedRotation: true);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class Enemy extends Pawn{

  double moveSpeed = 30;
  double jumpForce = 1500;

  double jumpDelay = 0.3;
  double thinkDelay = 1;

  double jumpTimer = 0;
  double thinkTimer = 0;
  bool moveUntilThink = false;
  bool isMoveingUntilThink = false;

  double floorPos = game.camera.visibleWorldRect.bottomLeft.toVector2().y - 12;

  Vector2 colliderSize = Vector2(3.1, 5.6);
  Vector2 startPos = Vector2(
      game.camera.visibleWorldRect.bottomRight.toVector2().x - 15,
      game.camera.visibleWorldRect.bottomLeft.toVector2().y - 12);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    renderBody = false;

    final sprite = await game.loadSprite('Enemy.png');
    add(
      SpriteComponent(
          sprite: sprite,
          anchor: Anchor.center,
          scale: Vector2.all(0.05),

      ),
    );
  }

  void move(Vector2 dir){
    body.linearVelocity = Vector2(dir.x * moveSpeed, body.linearVelocity.y);
  }

  void jump(){
    if(body.position.y >= floorPos-1){
      //body.linearVelocity = Vector2(body.linearVelocity.x, -30);
      body.applyLinearImpulse((Vector2(0, -1) * jumpForce) * 100);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if(body.position.x <= 2.5){
      body.setTransform(Vector2(2.5, body.position.y), 0);
    }

    if(abs(ball.body.position.x - body.position.x) > 3){
      if(!isMoveingUntilThink){
        //if ball is front of enemy => move to ball
        if(ball.body.position.x < body.position.x){
          thinkTimer = 0;
          if(ball.body.position.y < 0){
            if(jumpTimer >= jumpDelay){
              jump();
              jumpTimer = 0;
            }
          }

          if(distance(body.position, ball.body.position) < 30){
            move(Vector2(-1, 0));
          }
        }

        //if ball is begind of enemy => move to ball
        if(ball.body.position.x > body.position.x){
          move(Vector2(1, 0));
        }
      }
    }
    else{
      if(!isMoveingUntilThink){
        thinkTimer = 0;
        moveUntilThink = true;
      }
    }

    if(moveUntilThink){
      isMoveingUntilThink = true;
      if(thinkTimer < thinkDelay){
        move(Vector2(.5, 0));
      }
      else{
        isMoveingUntilThink = false;
        moveUntilThink = false;
      }
    }

    thinkTimer += dt;
    jumpTimer += dt;
  }


  @override
  void onMount() async {
    super.onMount();

    MassData massData = MassData();
    massData.mass = 5000;

    body.setMassData(massData);
  }

  @override
  Body createBody() {
    FixtureDef fixtureDef = FixtureDef(PolygonShape()..setAsBoxXY(colliderSize.x, colliderSize.y), friction: 10, restitution: 0, density: 1);
    BodyDef bodyDef = BodyDef(userData: this, position: startPos, type: BodyType.dynamic, fixedRotation: true);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class Ball extends BodyComponent with ContactCallbacks{

  double radius = 3;
  double pushForce = 100;

  double floorPos = game.camera.visibleWorldRect.bottomLeft.toVector2().y - 12;

  Vector2 colliderSize = Vector2(3.1, 5.25);
  Vector2 startPos = Vector2(
      0,
      game.camera.visibleWorldRect.bottomLeft.toVector2().y - 12);

  void beginContact(Object other, Contact contact) {
    if (other is Pawn) {
      push(Vector2(0, -1) * clampDouble(other.body.linearVelocity.length, 0, 30));
    }
  }

  void push(Vector2 dir)
  {
    body.applyLinearImpulse(dir * pushForce);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    renderBody = false;


    final sprite = await game.loadSprite('mainball.png');
    add(
      SpriteComponent(
          sprite: sprite,
          anchor: Anchor.center,
          scale: Vector2.all((0.05 / 4) * radius),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
  }


  @override
  void onMount() async {
    super.onMount();
  }

  @override
  Body createBody() {
    FixtureDef fixtureDef = FixtureDef(CircleShape()..radius = radius, friction: .5, restitution: .9, density: 1);
    BodyDef bodyDef = BodyDef(userData: this, position: startPos, type: BodyType.dynamic, angularDamping: 1);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class InGameButton extends SpriteComponent with TapCallbacks{

  bool isPressed = false;

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    isPressed = true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    isPressed = false;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    super.onTapCancel(event);
    isPressed = false;
  }

}

class Goal extends BodyComponent with ContactCallbacks{

  Goal(bool isLeftSide){
    leftSide = isLeftSide;
  }

  double floorPos = game.camera.visibleWorldRect.bottomLeft.toVector2().y - 12;

  Vector2 colliderSize = Vector2(6, 8);
  Vector2 startPos = Vector2(
      0,
      0);

  double freezeTimer = 0;
  double freezeDelay = .1;

  bool leftSide = false;

  void beginContact(Object other, Contact contact) {
    if(freezeTimer >= freezeDelay){
      if (other is Ball) {
        if(leftSide){
          enemyScore++;
        }
        else{
          playerScore++;
        }
        textComponent.text = playerScore.toString() + " : " + enemyScore.toString();

        game.CheckGameResults();
        game.shouldResetGame = true;
      }
    }
  }


  @override
  Future<void> onLoad() async {
    await super.onLoad();

    renderBody = false;

    final side = await game.loadSprite('goal_side.png');
    final top = await game.loadSprite('goal_top.png');

    if(leftSide){
      body.setTransform(Vector2(-40, 5), 0);

      //front
      add(
        SpriteComponent(
          sprite: side,
          anchor: Anchor.center,
          scale: Vector2.all(0.05),
          position: Vector2(0,0),
          priority: 4,
        ),
      );

      //front far
      add(
        SpriteComponent(
            sprite: side,
            anchor: Anchor.center,
            scale: Vector2.all(0.05),
            position: Vector2(4,-3.5),
            priority: 2
        ),
      );

      //top
      add(
        SpriteComponent(
            sprite: top,
            anchor: Anchor.center,
            scale: Vector2.all(0.05),
            position: Vector2(4,-10.5),
            priority: 2
        ),
      );
    }
    else{
      body.setTransform(Vector2(40, 5), 0);

      //front
      add(
        SpriteComponent(
          sprite: side,
          anchor: Anchor.center,
          scale: Vector2(-0.05, 0.05),
          position: Vector2(0,0),
          priority: 4,
        ),
      );

      //front far
      add(
        SpriteComponent(
            sprite: side,
            anchor: Anchor.center,
            scale: Vector2(-0.05, 0.05),
            position: Vector2(-4,-3.5),
            priority: 2
        ),
      );

      //top
      add(
        SpriteComponent(
            sprite: top,
            anchor: Anchor.center,
            scale: Vector2(-0.05, 0.05),
            position: Vector2(-4,-10.5),
            priority: 2
        ),
      );
    }

  }

  @override
  void update(double dt) {
    super.update(dt);

    freezeTimer += dt;
  }


  @override
  void onMount() async {
    super.onMount();
  }

  @override
  Body createBody() {
    FixtureDef fixtureDef = FixtureDef(PolygonShape()..setAsBoxXY(colliderSize.x, colliderSize.y), isSensor: true);
    BodyDef bodyDef = BodyDef(userData: this, position: startPos, type: BodyType.static);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class Wall extends BodyComponent {
  final Vector2 _start;
  final Vector2 _end;

  Wall(this._start, this._end);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    renderBody = false;
  }

  @override
  Body createBody() {
    final shape = EdgeShape()..set(_start, _end);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(
      position: Vector2.zero(),
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class FilledWall extends BodyComponent{
  FilledWall(Vector2 position){
    this.startPos = position;
  }

  Vector2 startPos = Vector2.zero();
  Vector2 colliderSize = Vector2(8, 8);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    renderBody = false;
  }

  @override
  Body createBody() {
    FixtureDef fixtureDef = FixtureDef(PolygonShape()..setAsBoxXY(colliderSize.x, colliderSize.y));
    BodyDef bodyDef = BodyDef(userData: this, position: startPos, type: BodyType.kinematic);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class Pawn extends BodyComponent{

}

double distance(Vector2 v1, Vector2 v2) {
  return sqrt(pow(v1.x - v2.x, 2) + pow(v1.y - v2.y, 2));
}

double abs(double val){
  if(val < 0){
    return -val;
  }
  if(val > 0){
    return val;
  }

  return 0;
}