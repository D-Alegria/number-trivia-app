import 'package:flutter/material.dart';

///Created by Demilade Oladugba on 4/8/2020

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Center(child: CircularProgressIndicator()));
  }
}
