import 'dart:js_interop';
import 'package:web/web.dart' as web;

/// Unlocks the Web Audio API context so sounds can play without a user tap.
/// Called once when the notification carousel initialises.
void unlockWebAudio() {
  try {
    // Create a new AudioContext
    final ctx = web.AudioContext();

    // Resume the context (required in some browsers)
    ctx.resume();

    // Create and immediately play a silent buffer.
    // This "primes" the audio engine so subsequent plays work autoplay.
    final buffer = ctx.createBuffer(1, 1, 22050);
    final source = ctx.createBufferSource();
    source.buffer = buffer;
    source.connect(ctx.destination);
    source.start();
  } catch (_) {
    // Silent fail – sound just won't play if browser blocks it
  }
}