import 'package:flutter/material.dart';
import 'package:project_test/data_provider.dart';

class ChannelPage extends Scaffold {
  final DataProvider dataProvider = DataProvider.getInstance();

  ChannelPage({super.key})
      : super(appBar: AppBar(), body: Container());
}
