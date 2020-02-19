import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:webmail_app/colors.dart';

import 'package:webmail_app/utils/gallery_options.dart';
import 'package:webmail_app/utils/gallery_localizations.dart';
import 'package:webmail_app/utils/adaptive.dart';
import 'package:webmail_app/utils/text_scale.dart';
import 'package:webmail_app/utils/focus_traversal_policy.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.Login;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultFocusTraversal(
      policy: EdgeChildrenFocusTraversalPolicy(
        focusScope: FocusScope.of(context),
      ),
      child: ApplyTextOptions(
        child: Scaffold(
          body: SafeArea(
            child: _MainView(
              authMode: _authMode,
              onAuthModeTap: _switchAuthMode,
              usernameController: _usernameController,
              passwordController: _passwordController,
            ),
          ),
        ),
      ),
    );
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      // _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      // _controller.reverse();
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class _MainView extends StatefulWidget {
  const _MainView({
    Key key,
    @required this.authMode,
    @required this.onAuthModeTap,
    this.usernameController,
    this.passwordController,
  }) : super(key: key);

  final AuthMode authMode;
  final VoidCallback onAuthModeTap;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  @override
  __MainViewState createState() => __MainViewState();
}

class __MainViewState extends State<_MainView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  void _login(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    List<Widget> listViewChildren;

    Future<void> _submit() async {
      if (!_formKey.currentState.validate()) {
        // Invalid!
        return;
      }
    }

    if (isDesktop) {
      final desktopMaxWidth = 400.0 + 100.0 * (cappedTextScale(context) - 1);
      listViewChildren = [
        Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _UsernameInput(
                    authMode: widget.authMode,
                    maxWidth: desktopMaxWidth,
                    usernameController: widget.usernameController,
                  ),
                  const SizedBox(height: 12),
                  _PasswordInput(
                    maxWidth: desktopMaxWidth,
                    passwordController: widget.passwordController,
                  ),
                  if (widget.authMode == AuthMode.Signup) ...[
                    const SizedBox(height: 12),
                    _ConfirmPasswordInput(
                      authMode: widget.authMode,
                      maxWidth: desktopMaxWidth,
                      passwordController: widget.passwordController,
                    )
                  ],
                ],
              ),
            )),
        _LoginButton(
          maxWidth: desktopMaxWidth,
          onTap: _submit,
        ),
        if (widget.authMode == AuthMode.Login)
          _GoogleLoginButton(
            maxWidth: desktopMaxWidth,
            onTap: () {
              _login(context);
            },
          ),
      ];
    } else {
      listViewChildren = [
        Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _UsernameInput(
                    authMode: widget.authMode,
                    usernameController: widget.usernameController,
                  ),
                  const SizedBox(height: 12),
                  _PasswordInput(
                    passwordController: widget.passwordController,
                  ),
                  if (widget.authMode == AuthMode.Signup) ...[
                    const SizedBox(height: 12),
                    _ConfirmPasswordInput(
                      authMode: widget.authMode,
                      passwordController: widget.passwordController,
                    )
                  ],
                ],
              ),
            )),
        _ThumbButton(
          onTap: _submit,
        ),
        if (widget.authMode == AuthMode.Login)
          _GoogleLoginButton(
            onTap: () {
              _login(context);
            },
          ),
      ];
    }

    return Column(
      children: [
        _TopBar(
          authMode: widget.authMode,
          onAuthModeTap: widget.onAuthModeTap,
        ),
        // if (!isDesktop) const SizedBox(height: 8),
        Expanded(
          child: Align(
            alignment: isDesktop ? Alignment.center : Alignment.bottomCenter,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: listViewChildren,
            ),
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    Key key,
    @required this.authMode,
    @required this.onAuthModeTap,
  }) : super(key: key);

  final AuthMode authMode;
  final VoidCallback onAuthModeTap;

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    final spacing = const SizedBox(width: 30);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Wrap(
        alignment:
            isDesktop ? WrapAlignment.spaceBetween : WrapAlignment.spaceAround,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: SizedBox(
                  height: 80,
                  child: Image.asset(
                    'assets/images/logo.png',
                  ),
                ),
              ),
              spacing,
              Text(
                GalleryLocalizations.of(context).starterLoginLoginToStarter,
                style: Theme.of(context).textTheme.body2.copyWith(
                      fontSize: 35 / reducedTextScale(context),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                authMode == AuthMode.Login
                    ? GalleryLocalizations.of(context).rallyLoginNoAccount
                    : GalleryLocalizations.of(context).rallyLoginHaveAccount,
                style: Theme.of(context).textTheme.subhead,
              ),
              spacing,
              _BorderButton(
                text: authMode == AuthMode.Login
                    ? GalleryLocalizations.of(context).rallyLoginSignUp
                    : GalleryLocalizations.of(context).rallyLoginSignIn,
                onTap: onAuthModeTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallLogo extends StatelessWidget {
  const _SmallLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: SizedBox(
        height: 160,
        child: ExcludeSemantics(
          child: Image.asset(
            'assets/images/logo.png',
          ),
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  const _UsernameInput({
    Key key,
    this.authMode,
    this.maxWidth,
    this.usernameController,
  }) : super(key: key);

  final AuthMode authMode;
  final double maxWidth;
  final TextEditingController usernameController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: TextFormField(
          autofocus: true,
          controller: usernameController,
          decoration: InputDecoration(
            labelText: GalleryLocalizations.of(context).rallyLoginUsername,
          ),
          validator: (value) {
            if (value.isEmpty || !value.contains('@')) {
              return authMode == AuthMode.Login
                  ? GalleryLocalizations.of(context)
                      .demoTextFieldSigninEmailAddress
                  : GalleryLocalizations.of(context)
                      .demoTextFieldSignupEmailAddress;
            }
          },
        ),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    Key key,
    this.maxWidth,
    this.passwordController,
  }) : super(key: key);

  final double maxWidth;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: GalleryLocalizations.of(context).rallyLoginPassword,
          ),
          validator: (value) {
            if (value.isEmpty || value.length < 6) {
              return GalleryLocalizations.of(context)
                  .demoTextFieldPasswordMustBeLonger;
            }
          },
          obscureText: true,
        ),
      ),
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  const _ConfirmPasswordInput({
    Key key,
    this.authMode,
    this.maxWidth,
    this.passwordController,
  }) : super(key: key);

  final AuthMode authMode;
  final double maxWidth;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: TextFormField(
          decoration: InputDecoration(
            labelText:
                GalleryLocalizations.of(context).rallyLoginConfirmPassword,
          ),
          obscureText: true,
          validator: authMode == AuthMode.Signup
              ? (value) {
                  if (value != passwordController.text) {
                    return GalleryLocalizations.of(context)
                        .demoTextFieldPasswordsDoNotMatch;
                  }
                }
              : null,
        ),
      ),
    );
  }
}

class _ThumbButton extends StatefulWidget {
  _ThumbButton({
    @required this.onTap,
  });

  final VoidCallback onTap;

  @override
  _ThumbButtonState createState() => _ThumbButtonState();
}

class _ThumbButtonState extends State<_ThumbButton> {
  BoxDecoration borderDecoration;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      label: GalleryLocalizations.of(context).rallyLoginLabelLogin,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Focus(
          onKey: (node, event) {
            if (event is RawKeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space) {
                widget.onTap();
                return true;
              }
            }
            return false;
          },
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              setState(() {
                borderDecoration = BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                );
              });
            } else {
              setState(() {
                borderDecoration = null;
              });
            }
          },
          child: Container(
            decoration: borderDecoration,
            height: 120,
            child: ExcludeSemantics(
              child: Image.asset(
                'assets/images/thumb.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    Key key,
    @required this.onTap,
    this.maxWidth,
  }) : super(key: key);

  final double maxWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Row(
          children: [
            Icon(Icons.check_circle_outline, color: StarterColors.buttonColor),
            const SizedBox(width: 12),
            Text(GalleryLocalizations.of(context).rallyLoginRememberMe),
            const Expanded(child: SizedBox.shrink()),
            _FilledButton(
              text: GalleryLocalizations.of(context).rallyLoginButtonLogin,
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  const _GoogleLoginButton({
    Key key,
    @required this.onTap,
    this.maxWidth,
  }) : super(key: key);

  final double maxWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: SizedBox(
          child: _GoogleSigninButton(
            text: GalleryLocalizations.of(context).starterGoogleSigninButton,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}

class _BorderButton extends StatelessWidget {
  const _BorderButton({Key key, @required this.text, @required this.onTap})
      : super(key: key);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: StarterColors.buttonColor,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onPressed: onTap,
      child: Text(text),
    );
  }
}

class _FilledButton extends StatelessWidget {
  const _FilledButton({Key key, @required this.text, @required this.onTap})
      : super(key: key);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: StarterColors.buttonColor,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onPressed: onTap,
      child: Row(
        children: [
          Icon(Icons.lock),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}

class _GoogleSigninButton extends StatelessWidget {
  const _GoogleSigninButton(
      {Key key, @required this.text, @required this.onTap})
      : super(key: key);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: StarterColors.googleButtonColor,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      onPressed: onTap,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                height: 38.0,
                width: 38.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/google-logo.png',
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
