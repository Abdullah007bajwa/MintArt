import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RiveAnimationControllerHelper {
  // Singleton class for managing Rive animation controllers.
  static final RiveAnimationControllerHelper _instance =
      RiveAnimationControllerHelper._internal();

  factory RiveAnimationControllerHelper() {
    return _instance;
  }

  RiveAnimationControllerHelper._internal();

  Artboard? _riveArtboard;

  RiveAnimationController? _controllerIdle;
  RiveAnimationController? _controllerHandsUp;
  RiveAnimationController? _controllerHandsDown;
  RiveAnimationController? _controllerSuccess;
  RiveAnimationController? _controllerFail;
  RiveAnimationController? _controllerLookDownRight;
  RiveAnimationController? _controllerLookDownLeft;

  bool isLookingRight = false;
  bool isLookingLeft = false;

  Artboard? get riveArtboard => _riveArtboard;

  void addController(RiveAnimationController controller) {
    removeAllControllers();
    _riveArtboard?.addController(controller);
  }

  void addDownLeftController() {
    if (_controllerLookDownLeft != null) {
      addController(_controllerLookDownLeft!);
      isLookingLeft = true;
    }
  }

  void addDownRightController() {
    if (_controllerLookDownRight != null) {
      addController(_controllerLookDownRight!);
      isLookingRight = true;
    }
  }

  void addFailController() {
    if (_controllerFail != null) {
      addController(_controllerFail!);
    }
  }

  void addHandsDownController() {
    if (_controllerHandsDown != null) {
      addController(_controllerHandsDown!);
    }
  }

  void addHandsUpController() {
    if (_controllerHandsUp != null) {
      addController(_controllerHandsUp!);
    }
  }

  void addSuccessController() {
    if (_controllerSuccess != null) {
      addController(_controllerSuccess!);
    }
  }

  Future<void> loadRiveFile(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final file = RiveFile.import(data);
    _riveArtboard = file.mainArtboard;

    // Initialize controllers after the Rive file is loaded
    _controllerIdle = SimpleAnimation('idle');
    _controllerHandsUp = SimpleAnimation('Hands_up');
    _controllerHandsDown = SimpleAnimation('hands_down');
    _controllerSuccess = SimpleAnimation('success');
    _controllerFail = SimpleAnimation('fail');
    _controllerLookDownRight = SimpleAnimation('Look_down_right');
    _controllerLookDownLeft = SimpleAnimation('Look_down_left');

    // Add the default controller
    _riveArtboard?.addController(_controllerIdle!);
  }

  void removeAllControllers() {
    final listOfControllers = [
      _controllerIdle,
      _controllerHandsUp,
      _controllerHandsDown,
      _controllerSuccess,
      _controllerFail,
      _controllerLookDownRight,
      _controllerLookDownLeft,
    ];
    for (var controller in listOfControllers) {
      if (controller != null) {
        _riveArtboard?.removeController(controller);
      }
    }
    isLookingLeft = false;
    isLookingRight = false;
  }

  void dispose() {
    removeAllControllers();
    _controllerIdle?.dispose();
    _controllerHandsUp?.dispose();
    _controllerHandsDown?.dispose();
    _controllerSuccess?.dispose();
    _controllerFail?.dispose();
    _controllerLookDownRight?.dispose();
    _controllerLookDownLeft?.dispose();
  }
}
