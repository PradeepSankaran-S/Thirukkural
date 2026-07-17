import '../models/paal_model.dart';
import '../models/iyal_model.dart';
import '../models/athigaram_model.dart';
import '../models/kural_model.dart';
import '../services/local_json_service.dart';
import '../../core/constants/asset_paths.dart';

class ThirukkuralRepository {
  // Singleton Pattern
  static final ThirukkuralRepository _instance = ThirukkuralRepository._internal();
  factory ThirukkuralRepository() => _instance;
  ThirukkuralRepository._internal();

  final LocalJsonService _jsonService = LocalJsonService();

  List<PaalModel> _paals = [];
  List<IyalModel> _iyals = [];
  List<AthigaramModel> _athigarams = [];
  List<Kural> _kurals = [];

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) return;

    // Load Paals
    final rawPaals = await _jsonService.loadJson(AssetPaths.paalJson);
    _paals = (rawPaals as List).map((e) => PaalModel.fromJson(e)).toList();

    // Load Iyals
    final rawIyals = await _jsonService.loadJson(AssetPaths.iyalJson);
    _iyals = (rawIyals as List).map((e) => IyalModel.fromJson(e)).toList();

    // Load Athigarams
    final rawAthigarams = await _jsonService.loadJson(AssetPaths.athigaramJson);
    _athigarams = (rawAthigarams as List).map((e) => AthigaramModel.fromJson(e)).toList();

    // Load Kurals
    final rawKuralsMap = await _jsonService.loadJson(AssetPaths.kuralJson);
    final kuralModel = KuralModel.fromJson(rawKuralsMap as Map<String, dynamic>);
    _kurals = kuralModel.kural ?? [];

    _isInitialized = true;
  }

  List<PaalModel> getPaals() {
    return _paals;
  }

  List<IyalModel> getIyalsForPaal(int paalId) {
    // Standard Thirukkural Iyal grouping mapping:
    // Aram (paalId: 1) -> Iyal 1 to 4
    // Porul (paalId: 2) -> Iyal 5 to 11
    // Inbam (paalId: 3) -> Iyal 12 to 13
    if (paalId == 1) {
      return _iyals.where((iyal) => iyal.iyalNo != null && iyal.iyalNo! >= 1 && iyal.iyalNo! <= 4).toList();
    } else if (paalId == 2) {
      return _iyals.where((iyal) => iyal.iyalNo != null && iyal.iyalNo! >= 5 && iyal.iyalNo! <= 11).toList();
    } else if (paalId == 3) {
      return _iyals.where((iyal) => iyal.iyalNo != null && iyal.iyalNo! >= 12 && iyal.iyalNo! <= 13).toList();
    }
    return [];
  }

  List<AthigaramModel> getAthigaramsForIyal(int iyalNo) {
    // Standard Thirukkural Athigaram (Chapter) mapping:
    // 1 (Payiraviyal): Ch 1-4
    // 2 (Illaraviyal): Ch 5-24
    // 3 (Thuravaraviyal): Ch 25-37
    // 4 (Oozhiyal): Ch 38
    // 5 (Arasiyal): Ch 39-63
    // 6 (Amaichiyal): Ch 64-73
    // 7 (Araniyal): Ch 74-75
    // 8 (Koozhiyal): Ch 76-78
    // 9 (Padaiyil): Ch 79-80
    // 10 (Natpiyal): Ch 81-92
    // 11 (Kudiyiyal): Ch 93-108
    // 12 (Kalaviyal): Ch 109-115
    // 13 (Karpiyal): Ch 116-133
    int start = 0;
    int end = 0;

    switch (iyalNo) {
      case 1:
        start = 1; end = 4;
        break;
      case 2:
        start = 5; end = 24;
        break;
      case 3:
        start = 25; end = 37;
        break;
      case 4:
        start = 38; end = 38;
        break;
      case 5:
        start = 39; end = 63;
        break;
      case 6:
        start = 64; end = 73;
        break;
      case 7:
        start = 74; end = 75;
        break;
      case 8:
        start = 76; end = 78;
        break;
      case 9:
        start = 79; end = 80;
        break;
      case 10:
        start = 81; end = 92;
        break;
      case 11:
        start = 93; end = 108;
        break;
      case 12:
        start = 109; end = 115;
        break;
      case 13:
        start = 116; end = 133;
        break;
      default:
        return [];
    }

    return _athigarams.where((a) {
      if (a.athigaramNo == null) return false;
      final no = int.tryParse(a.athigaramNo.toString()) ?? 0;
      return no >= start && no <= end;
    }).toList();
  }

  List<Kural> getKuralsForAthigaram(int athigaramNo) {
    return _kurals.where((k) {
      if (k.number == null) return false;
      final calcAthigaram = ((k.number! - 1) ~/ 10) + 1;
      return calcAthigaram == athigaramNo;
    }).toList();
  }

  Kural? getKuralByNumber(int number) {
    return _kurals.firstWhere(
      (k) => k.number == number,
      orElse: () => Kural(number: number),
    );
  }

  List<Kural> searchKurals(String query) {
    if (query.isEmpty) return [];

    // Check if query is just a number
    final number = int.tryParse(query.trim());
    if (number != null && number >= 1 && number <= 1330) {
      final k = getKuralByNumber(number);
      return k != null && k.line1 != null ? [k] : [];
    }

    final lowerQuery = query.toLowerCase();
    return _kurals.where((k) {
      final line1 = k.line1?.toLowerCase() ?? '';
      final line2 = k.line2?.toLowerCase() ?? '';
      final translation = k.translation?.toLowerCase() ?? '';
      final explanation = k.explanation?.toLowerCase() ?? '';
      final mv = k.mv?.toLowerCase() ?? '';
      final sp = k.sp?.toLowerCase() ?? '';
      final mk = k.mk?.toLowerCase() ?? '';
      final trans1 = k.transliteration1?.toLowerCase() ?? '';
      final trans2 = k.transliteration2?.toLowerCase() ?? '';

      return line1.contains(lowerQuery) ||
          line2.contains(lowerQuery) ||
          translation.contains(lowerQuery) ||
          explanation.contains(lowerQuery) ||
          mv.contains(lowerQuery) ||
          sp.contains(lowerQuery) ||
          mk.contains(lowerQuery) ||
          trans1.contains(lowerQuery) ||
          trans2.contains(lowerQuery);
    }).toList();
  }

  List<Kural> getFavoriteKurals(List<int> numbers) {
    return _kurals.where((k) => k.number != null && numbers.contains(k.number!)).toList();
  }
}
