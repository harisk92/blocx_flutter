import 'dart:async';

import 'package:blocx/blocx.dart';
import 'package:flutter/widgets.dart';

typedef Widget BlocWidgetBuilder<S>(BuildContext context, S state);
typedef List<StreamSubscription> ArtifactBuilder(Stream stream);
typedef List AspectBuilder<S>(S state);

class BlocBuilder<A, S> extends StatefulWidget {
  final Bloc<A, S> bloc;
  final BlocWidgetBuilder<S> builder;
  final AspectBuilder<S> aspectsBuilder;
  final ArtifactBuilder artifactBuilder;

  const BlocBuilder({
    Key key,
    @required this.bloc,
    @required this.builder,
    this.aspectsBuilder,
    this.artifactBuilder,
  }) : super(key: key);

  @override
  _BlocBuilderState<A, S> createState() => _BlocBuilderState<A, S>();
}

class _BlocBuilderState<A, S> extends State<BlocBuilder<A, S>> {
  List<StreamSubscription> _subscriptions;

  @override
  void initState() {
    super.initState();
    if (widget.artifactBuilder != null) {
      _subscriptions = widget.artifactBuilder(widget.bloc.artifact);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_subscriptions != null) {
      _subscriptions.forEach((subscription) => subscription.cancel());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      initialData: widget.bloc.initialState,
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return widget.builder(context, snapshot.data);
      },
    );
  }

  Stream<S> get stream => widget.aspectsBuilder != null
      ? widget.bloc.state.distinct(isStateUnchanged)
      : widget.bloc.state;

  bool isStateUnchanged(S oldState, S newState) {
    List oldAspects = widget.aspectsBuilder(oldState);
    List newAspects = widget.aspectsBuilder(newState);

    for (int i = 0; i < oldAspects.length; i++) {
      if (oldAspects[i] != newAspects[i]) {
        return true;
      }
    }
    return false;
  }
}
