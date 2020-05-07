import 'package:flutter/material.dart';
import 'package:timetrackerfluttercourse/common_widgets/custom_raised_button.dart';

class FormSubmitBUtton extends CustomRaisedButton {
  FormSubmitBUtton({
    @required String text,
    VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          height: 44.0,
          color: Colors.lightBlue,
          borderRadius: 4.0,
          onPressed: onPressed,
        );
}
