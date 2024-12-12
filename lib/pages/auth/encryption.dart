import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:pointycastle/api.dart' as pc;
import 'package:pointycastle/asymmetric/oaep.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:pointycastle/pointycastle.dart';

class RSAEncryption {
  late pc.AsymmetricKeyPair<pc.PublicKey, pc.PrivateKey> _keyPair;
  String _publicKey = "";
  String _privateKey = "";

  // Fixed seed components for key generation
  static const String SMARTPHONE_ID = "1234567890"; // Example smartphone ID
  static const String HUID = "HUID123456";          // Example HUID

  RSAEncryption() {
    _refreshKeyPair(); // Generate initial key pair on initialization
  }

  /// Generate RSA Key Pair
  pc.AsymmetricKeyPair<pc.PublicKey, pc.PrivateKey> _generateKeyPair() {
    // Combine deterministic seed components
    final seedInput = utf8.encode(SMARTPHONE_ID + HUID + Random().nextInt(1000).toString());
    final sha256 = SHA256Digest();
    final seed = sha256.process(Uint8List.fromList(seedInput));

    // Secure random generator
    final secureRandom = FortunaRandom()..seed(pc.KeyParameter(seed));

    // RSA Key Pair generation
    final keyParams = RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 12);
    final generator = RSAKeyGenerator()..init(pc.ParametersWithRandom(keyParams, secureRandom));

    return generator.generateKeyPair();
  }

  /// Refresh RSA Key Pair
  void _refreshKeyPair() {
    _keyPair = _generateKeyPair();
    _publicKey = _formatPublicKey(_keyPair.publicKey as RSAPublicKey);
    _privateKey = _formatPrivateKey(_keyPair.privateKey as RSAPrivateKey);
  }

  /// Format Public Key for Display
  String _formatPublicKey(RSAPublicKey publicKey) {
    return "Modulus: ${publicKey.modulus}\nExponent: ${publicKey.exponent}";
  }

  /// Format Private Key for Display
  String _formatPrivateKey(RSAPrivateKey privateKey) {
    return "Modulus: ${privateKey.modulus}\nExponent: ${privateKey.exponent}";
  }

  /// RSA-OAEP Encryption
  Uint8List rsaOaepEncrypt(RSAPublicKey publicKey, String plaintext) {
    final oaepEncoding = OAEPEncoding(pc.AsymmetricBlockCipher("RSA/PKCS1"))
      ..init(true, pc.PublicKeyParameter<RSAPublicKey>(publicKey));

    final plaintextBytes = Uint8List.fromList(utf8.encode(plaintext));
    return oaepEncoding.process(plaintextBytes);
  }

  /// Encrypt the given text using RSA and return the encrypted base64 encoded string
  String encryptText(String plaintext) {
    final encryptedBytes = rsaOaepEncrypt(_keyPair.publicKey as RSAPublicKey, plaintext);
    return base64Encode(encryptedBytes);
  }

  String get publicKey => _publicKey;
  String get privateKey => _privateKey;
}
