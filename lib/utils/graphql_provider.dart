import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

String? uuidFromObject(Object object) {
  if (object is Map<String, Object>) {
    final String? typeName = object['__typename'].toString();
    final String? id = object['id'].toString();
    if (typeName != null && id != null) {
      return <String>[typeName, id].join('/');
    }
  }
  return null;
}

ValueNotifier<GraphQLClient> clientFor({
  required String uri,
  String? subscriptionUri,
}) {
  // Link link = authLink.concat(HttpLink(uri));
  String _token = 'k';
  //final AuthLink authLink = AuthLink(getToken: () => _token);
  final entr = <String, String>{
    'x-hasura-admin-secret':
        '7UmxtmfpEDJ9IO9Q4b9ChBhZoj27pM14uwB3pEPzgCGf0elD83gdgxMIMANflyMl'
  };
  Link httpLink = HttpLink(uri, defaultHeaders: entr);
  //Link link = HttpLink(uri);
  if (subscriptionUri != null) {
    final WebSocketLink websocketLink = WebSocketLink(
      subscriptionUri,
      config: SocketClientConfig(
        initialPayload: () async {
          //_token = await authLink.getToken().toString();
          print('TOKEN::::: ' + _token);
          return {
            'headers': entr,
          };
        },
        autoReconnect: false,
      ),
    );
    httpLink = Link.split(
        (request) => request.isSubscription, websocketLink, httpLink);
  }
  return ValueNotifier<GraphQLClient>(
    GraphQLClient(
      cache: GraphQLCache(store: HiveStore()),
      link: httpLink,
    ),
  );
}
