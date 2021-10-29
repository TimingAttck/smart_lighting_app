library rounded_loading_button;

import 'dart:ui';

import 'package:flutter/material.dart';

///
/// @author https://pub.dev/packages/rounded_loading_button
/// Adapted to my needs
/// A animated status button that can show errors, animated success and handles the method to execute
///
class StateButton extends StatefulWidget {
  final StateButtonController controller;

  final VoidCallback onPressed;
  final Widget child;
  final double height;
  final double width;
  final bool animateOnTap;
  final Color backgroundColor;
  final double borderRadius;
  final Alignment alignment;
  final bool disabled;

  const StateButton(
      { required this.disabled,
        required this.alignment,
        required this.controller,
        required this.onPressed,
        required this.child,
        required this.backgroundColor,
        required this.borderRadius,
        this.height = 50,
        this.width = 300,
        this.animateOnTap = false});

  @override
  State<StatefulWidget> createState() => StateButtonState();
}

class StateButtonState extends State<StateButton> with TickerProviderStateMixin {

  late AnimationController _buttonController;
  late AnimationController _checkButtonControler;
  late AnimationController _borderRadiusController;

  late Animation _radiusAnimation;
  late Animation _squeezeAnimation;
  late Animation _bounceAnimation;

  void onPressedCallBack() {
    if (widget.animateOnTap) {
      _start();
    } else {
      widget.onPressed();
    }
  }

  bool isSuccessful = false;
  bool isErrored = false;
  bool isClicked = false;
  late bool isDisabled;

  String _errorText = "";

  @override
  Widget build(BuildContext context) {

    var _errorCard = Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 8, // 20%
              child: Padding(padding: const EdgeInsets.only(right: 8), child: Text(_errorText, textScaleFactor: 1.2, style: TextStyle(color: Colors.white))),
            ),
            Expanded(
              flex: 3, // 60%
              child: GestureDetector(
                onTap: () {
                  _reset();
                },
                child: Container(
                  decoration: const BoxDecoration(
                  border: Border(
                      left: BorderSide(width: 4.0, color: Colors.white),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.refresh, size: 60, color: Colors.white)
                  )
                ),
              )
            ),
          ],
        ),
      ),
    ));

    var _check = Container(
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius:
              BorderRadius.all(Radius.circular((_bounceAnimation.value+10) / 2)),
        ),
        width: _bounceAnimation.value+10,
        height: _bounceAnimation.value+10,
        child: _bounceAnimation.value > 20
            ? const Icon(
                Icons.check,
                color: Colors.white,
              )
            : null);

    var _loader = Container(
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius:
          BorderRadius.all(Radius.circular((_bounceAnimation.value+50) / 2)),
        ),
        width: _bounceAnimation.value+50,
        height: _bounceAnimation.value+50,
        child: const Padding(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2
          )
        )
    );

    var _btn = ButtonTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          _radiusAnimation.value
        ),
      ),
      minWidth: _squeezeAnimation.value,
      height: widget.height,
      child: RaisedButton(
          child: _squeezeAnimation.value > 150  ? widget.child : _loader,
          color: widget.backgroundColor,
          onPressed: isDisabled ? null : onPressedCallBack
      ),
    );

    return Container(
        alignment: widget.alignment,
        child: isErrored
          ? _errorCard
          : isSuccessful
            ? _check
            : isClicked ? _loader : _btn
    );
  }

  @override
  void initState() {
    super.initState();

    isDisabled = widget.disabled;

    _buttonController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _checkButtonControler = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _borderRadiusController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    _bounceAnimation = Tween<double>(begin: 0, end: widget.height).animate(
        CurvedAnimation(
            parent: _checkButtonControler, curve: Curves.elasticOut));
    _bounceAnimation.addListener(() {
      setState(() {});
    });

    _radiusAnimation = Tween<double>(begin: widget.borderRadius, end: 120).animate(_borderRadiusController);

    _squeezeAnimation = Tween<double>(begin: widget.width, end: widget.height).animate(
        CurvedAnimation(
            parent: _buttonController, curve: Curves.easeInOutCirc));
    _squeezeAnimation.addListener(() {
      setState(() {});
    });

    widget.controller._addListeners(_enable, _disable, _start, _stop, _success, _error, _reset);
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _checkButtonControler.dispose();
    super.dispose();
  }

  _enable() {
    isDisabled = false;
    setState(() { });
  }

  _disable() {
    isDisabled = true;
    setState(() { });
  }

  _start() {
    _buttonController.forward();
    _borderRadiusController.forward();
    isClicked = true;
  }

  _stop() {
    isSuccessful = false;
    isErrored = false;
    isClicked = true;
    _buttonController.reverse();
  }

  _success() {
    isSuccessful = true;
    isErrored = false;
    _checkButtonControler.forward();
  }

  _error(String errorText) {
    _errorText = errorText;
    isErrored = true;
    _checkButtonControler.forward();
  }

  _reset() {
    isSuccessful = false;
    isErrored = false;
    isClicked = false;
    _buttonController.reverse();
    _borderRadiusController.reverse();
    _checkButtonControler.reverse();
  }
}

class StateButtonController {

  late VoidCallback _enableCallback;
  late VoidCallback _disableCallback;
  late VoidCallback _startListener;
  late VoidCallback _stopListener;
  late VoidCallback _successListener;
  late Function(String errorText) _errorListener;
  late VoidCallback _resetListener;
  bool wasClicked = false;

  _addListeners(
      VoidCallback enableCallback,
      VoidCallback disableCallback,
      VoidCallback startListener,
      VoidCallback stopListener,
      VoidCallback successListener,
      Function(String errorText) errorListener,
      VoidCallback resetListener) {
    _enableCallback = enableCallback;
    _disableCallback = disableCallback;
    _startListener = startListener;
    _stopListener = stopListener;
    _successListener = successListener;
    _errorListener = errorListener;
    _resetListener = resetListener;
  }

  bool isClicked() {
    return wasClicked;
  }

  start() {
    _startListener();
  }

  disable() {
    _disableCallback();
  }

  enable() {
    _enableCallback();
  }

  stop() {
    _stopListener();
  }

  success() {
    _successListener();
    wasClicked = true;
  }

  error(String errorText) {
    _errorListener(errorText);
    wasClicked = true;
  }

  reset() {
    _resetListener();
    wasClicked = false;
  }
}
