
import 'dart:math' as math;
import 'package:flutter/material.dart';

IconData getCenterIcon(double expected, double spent) {
  if (spent > expected) return Icons.thumb_down;
  if (spent < expected) return Icons.thumb_up;
  return Icons.balance;
}

double getRemaining(double initial, double spent) => initial - spent;

double getGray(double spent, double expected) => math.min(spent, expected);

double getRed(double spent, double expected) => math.max(0.0, spent - expected);

double getGreen(double expected, double spent) => math.max(0.0, expected - spent);