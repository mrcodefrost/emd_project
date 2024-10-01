import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Logger logg = Logger();

void prettyPrintJson(String input) {
  const JsonDecoder decoder = JsonDecoder();
  const JsonEncoder encoder = JsonEncoder.withIndent('  ');
  final dynamic object = decoder.convert(input);
  final dynamic prettyString = encoder.convert(object);
  prettyString.split('\n').forEach((dynamic element) => debugPrint(element));
}
