import 'package:blocx/blocx.dart';
import 'package:blocx_flutter/src/bloc_builder.dart';
import 'package:flutter/widgets.dart';

abstract class BlocWidget<A, S> extends StatelessWidget {
  final Bloc<A, S> bloc;

  const BlocWidget({Key key, @required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<A, S>(
      bloc: bloc,
      artifactBuilder: (stream) => artifacts(stream),
      aspectsBuilder: (state) => aspects(state),
      builder: (BuildContext context, state) {
        return buildWidget(context, state);
      },
    );
  }

  Widget buildWidget(BuildContext context, S state);

  List aspects(S state) => null;

  List artifacts(Stream<A> artifact) => null;
}
