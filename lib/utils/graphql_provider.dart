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
  required String uri
}) {
  // Link link = authLink.concat(HttpLink(uri));
  final entr = <String, String>{'x-hasura-admin-secret': '7UmxtmfpEDJ9IO9Q4b9ChBhZoj27pM14uwB3pEPzgCGf0elD83gdgxMIMANflyMl'};
  HttpLink httpLink = HttpLink(uri, defaultHeaders: entr);

  return ValueNotifier<GraphQLClient>(
    GraphQLClient(
      cache: GraphQLCache(store: HiveStore()),
      link: httpLink,
    ),
  );
}
