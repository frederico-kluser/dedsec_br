import 'dart:math';

class DedsecUser {
  final String seed;
  final String style;
  final String pseudonym;
  final String city;

  const DedsecUser({
    required this.seed,
    this.style = 'identicon',
    required this.pseudonym,
    this.city = 'SP',
  });

  DedsecUser copyWith({String? seed, String? pseudonym, String? city}) =>
      DedsecUser(
        seed: seed ?? this.seed,
        pseudonym: pseudonym ?? this.pseudonym,
        city: city ?? this.city,
      );

  static String randomSeed([Random? rng]) {
    final r = rng ?? Random();
    const chars = 'abcdef0123456789';
    final buf = StringBuffer();
    for (var i = 0; i < 6; i++) {
      buf.write(chars[r.nextInt(chars.length)]);
    }
    return buf.toString();
  }

  static String pseudonymFromSeed(String seed, [String city = 'SP']) {
    final tail = seed.substring(seed.length - 4);
    return 'Cidadão_${city}_$tail';
  }

  factory DedsecUser.fresh() {
    final seed = randomSeed();
    return DedsecUser(seed: seed, pseudonym: pseudonymFromSeed(seed));
  }
}
