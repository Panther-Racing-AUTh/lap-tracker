import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '/utils/graphql_provider.dart';

/// Wraps the root application with the `graphql_flutter` client.
/// We use the cache for all state management.
class ClientProvider extends StatelessWidget {
  ClientProvider({
    required this.child,
    required String uri
  }) : client = clientFor(
          uri: uri
        );

  final Widget child;
  final ValueNotifier<GraphQLClient> client;

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: child,
    );
  }
}
