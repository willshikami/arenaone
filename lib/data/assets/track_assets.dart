class TrackAssets {
  static const String _base = 'assets/tracks';

  static const String albertPark = '$_base/albert_park.webp';
  static const String americas = '$_base/americas.webp';
  static const String bahrain = '$_base/bahrain.webp';
  static const String baku = '$_base/baku.webp';
  static const String catalunya = '$_base/catalunya.webp';
  static const String hungaroring = '$_base/hungaroring.webp';
  static const String interlagos = '$_base/interlagos.webp';
  static const String jeddah = '$_base/jeddah.webp';
  static const String madrid = '$_base/madrid.webp';
  static const String marinaBay = '$_base/marina_bay.webp';
  static const String miami = '$_base/miami.webp';
  static const String monaco = '$_base/monaco.webp';
  static const String monza = '$_base/monza.webp';
  static const String redBullRing = '$_base/red_bull_ring.webp';
  static const String rodriguez = '$_base/rodriguez.webp';
  static const String shanghai = '$_base/shanghai.webp';
  static const String silverstone = '$_base/silverstone.webp';
  static const String spa = '$_base/spa.webp';
  static const String suzuka = '$_base/suzuka.webp';
  static const String vegas = '$_base/vegas.webp';
  static const String villeneuve = '$_base/villeneuve.webp';
  static const String yasMarina = '$_base/yas_marina.webp';
  static const String zandvoort = '$_base/zandvoort.webp';

  static String getTrackAsset(String stadiumName) {
    final name = stadiumName.toLowerCase();
    if (name.contains('bahrain')) return bahrain;
    if (name.contains('yas marina')) return yasMarina;
    if (name.contains('jeddah')) return jeddah;
    if (name.contains('albert park')) return albertPark;
    if (name.contains('americas')) return americas;
    if (name.contains('baku')) return baku;
    if (name.contains('catalunya')) return catalunya;
    if (name.contains('hungaroring')) return hungaroring;
    if (name.contains('interlagos')) return interlagos;
    if (name.contains('madrid')) return madrid;
    if (name.contains('marina bay')) return marinaBay;
    if (name.contains('miami')) return miami;
    if (name.contains('monaco')) return monaco;
    if (name.contains('monza')) return monza;
    if (name.contains('red bull ring')) return redBullRing;
    if (name.contains('rodriguez')) return rodriguez;
    if (name.contains('shanghai')) return shanghai;
    if (name.contains('silverstone')) return silverstone;
    if (name.contains('spa')) return spa;
    if (name.contains('suzuka')) return suzuka;
    if (name.contains('vegas')) return vegas;
    if (name.contains('villeneuve')) return villeneuve;
    if (name.contains('zandvoort')) return zandvoort;
    
    // Default fallback
    return bahrain;
  }
}
