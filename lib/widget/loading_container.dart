import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool cover;

  const LoadingContainer(
      {key, @required this.child, @required this.isLoading, this.cover = false})
      : super(key: key);

  Widget get _loadView {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return !cover
        ? !isLoading
            ? child
            : _loadView
        : Stack(
            children: [child, isLoading ? _loadView : null],
          );
  }
}
