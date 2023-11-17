import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

class PaginatedListBuilder<T> extends StatefulWidget {
  const PaginatedListBuilder({
    required this.state,
    required this.notifier,
    required this.errorBuilder,
    required this.initialLoadingBuilder,
    required this.listViewBuilder,
    super.key,
  });
  final AsyncValue<List<T>> state;
  final PaginatedNotifier<T> notifier;
  final Widget Function(Object error, StackTrace stackTrace) errorBuilder;
  final Widget Function() initialLoadingBuilder;
  final Widget Function(
    BuildContext context,
    List<T> data,
  ) listViewBuilder;

  @override
  State<PaginatedListBuilder<T>> createState() =>
      _PaginatedListBuilderState<T>();
}

class _PaginatedListBuilderState<T> extends State<PaginatedListBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    return widget.state.when(
      data: (List<T> data) => widget.listViewBuilder.call(context, data),
      error: (error, stackTrace) {
        if (widget.notifier.hasData()) {
          return widget.listViewBuilder
              .call(context, widget.notifier.getCurrentData());
        }
        return widget.errorBuilder.call(error, stackTrace);
      },
      loading: () {
        if (widget.notifier.hasData()) {
          return widget.listViewBuilder
              .call(context, widget.notifier.getCurrentData());
        }
        return widget.initialLoadingBuilder.call();
      },
    );
  }
}
