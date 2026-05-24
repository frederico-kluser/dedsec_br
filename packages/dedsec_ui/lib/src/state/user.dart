import 'dart:math';

/// Anonymous local identity. Pseudonym stays stable; only the avatar seed
/// rotates on regenerate (same rule as the React prototype).
class DedsecUser {
  final String seed;
  final String style; // dicebear style
  final String pseudonym;
  final String city;

  const DedsecUser({
    required this.seed,
    required this.style,
    required this.pseudonym,
    required this.city,
  });

  DedsecUser copyWith({String? seed, String? style, String? pseudonym, String? city}) =>
      DedsecUser(
        seed: seed ?? this.seed,
        style: style ?? this.style,
        pseudonym: pseudonym ?? this.pseudonym,
        city: city ?? this.city,
      );

  factory DedsecUser.fresh({String city = 'SP'}) {
    final seed = randomSeed();
    return DedsecUser(
      seed: seed,
      style: 'identicon',
      pseudonym: pseudonymFromSeed(seed, city),
      city: city,
    );
  }
}

final _rng = Random();
const _seedChars = 'abcdef0123456789';

String randomSeed() {
  final b = StringBuffer();
  for (var i = 0; i < 6; i++) {
    b.write(_seedChars[_rng.nextInt(_seedChars.length)]);
  }
  return b.toString();
}

String pseudonymFromSeed(String seed, [String city = 'SP']) {
  final tail = seed.length >= 4 ? seed.substring(seed.length - 4) : seed;
  return 'Cidadão_${city}_$tail';
}
