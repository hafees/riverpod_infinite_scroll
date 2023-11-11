import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

abstract class PaginatedListStatefulWidget<T> extends StatefulWidget {
  const PaginatedListStatefulWidget({
    required this.state,
    required this.itemBuilder,
    required this.notifier,
    super.key,
    this.errorBuilder,
    this.loadingBuilder,
    this.emptyListBuilder,
    this.separatorBuilder,
    this.listViewBuilder,
    this.skeleton,
    this.numSkeletons = 4,
    this.scrollDirection = Axis.vertical,
    this.pullToRefresh = false,
    this.useSliverList = false,
    this.shrinkWrap = false,
    this.customScrollController,
    this.customScrollDelta,
  });
  final AsyncValue<List<T>> state;
  final PaginatedNotifier<T> notifier;
  final Widget Function()? emptyListBuilder;
  final Widget Function(T data) itemBuilder;
  final Widget Function(Object error, StackTrace stackTrace)? errorBuilder;
  final Widget Function()? loadingBuilder;
  final Widget Function(
    BuildContext context,
    List<T> data,
  )? listViewBuilder;
  final Widget? skeleton;
  final int numSkeletons;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final Axis scrollDirection;
  final bool pullToRefresh;
  final bool useSliverList;
  final ScrollController? customScrollController;
  final int? customScrollDelta;
  final bool shrinkWrap;

  @override
  State createState();

  @override
  StatefulElement createElement() => StatefulElement(this);
}
