import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:timetrackerfluttercourse/Animation/FadeAnimation.dart';
import 'package:timetrackerfluttercourse/app/sign_in/email_sign_in_page.dart';
import 'package:timetrackerfluttercourse/app/sign_in/sign_in_bloc.dart';
import 'package:timetrackerfluttercourse/app/sign_in/social_sign_in_button.dart';
import 'package:timetrackerfluttercourse/app/sign_in/sign_in_button.dart';
import 'package:timetrackerfluttercourse/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetrackerfluttercourse/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.bloc}) : super(key: key);
  final SignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth: auth),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>(
        builder: (context, bloc, _) => SignInPage(bloc: bloc),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    } 
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return _buildContent(context, snapshot.data);
          }),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.fill)),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 30,
                    width: 80,
                    height: 200,
                    child: FadeAnimation(
                        1,
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/light-1.png'))),
                        )),
                  ),
                  Positioned(
                    left: 140,
                    width: 80,
                    height: 150,
                    child: FadeAnimation(
                        1.3,
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/light-2.png'))),
                        )),
                  ),
                  Positioned(
                    right: 40,
                    top: 40,
                    width: 80,
                    height: 150,
                    child: FadeAnimation(
                        1.5,
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/clock.png'))),
                        )),
                  ),
                  Positioned(
                    child: FadeAnimation(
                        1.6,
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/logo.png'))),
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SocialSignInButton(
                    assetName: 'images/google-logo.png',
                    text: 'Sign in with Google',
                    textColor: Colors.black87,
                    color: Colors.white,
                    onPressed:
                        isLoading ? null : () => _signInWithGoogle(context),
                  ),
                  SizedBox(height: 8.0),
                  SignInButton(
                    text: 'Sign in with Email',
                    textColor: Colors.white,
                    color: Colors.lightBlue,
                    onPressed: () => _signInWithEmail(context),
                  ),
                  SizedBox(height: 8.0),
                  SizedBox(
                    height: 50.0,
                    child: _buildHeader(isLoading),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      '',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
