import 'package:flutter/material.dart';
import 'package:go_linguage/features/home/data/models/home_model.dart';
import 'package:go_linguage/features/user_info/data/models/api_user_model.dart';

ValueNotifier<int> userAvatar = ValueNotifier(1);
ValueNotifier<int> userGoPoint = ValueNotifier(0);
ValueNotifier<HomeResponseModel?> homeData = ValueNotifier(null);
ValueNotifier<UserResopnseModel?> userData = ValueNotifier(null);
