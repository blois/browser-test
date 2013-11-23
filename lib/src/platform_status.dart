library browser_test.platform_status;

import 'dart:html' as dom;

class PlatformStatus {
  final Iterable<ExpectedStatus> statuses;
  final PlatformConstraint constraint;
  final String reason;

  PlatformStatus(this.constraint, status, this.reason):
      this.statuses = status is Iterable ? status : [status];

  bool get isActive {
    return constraint.isActive;
  }

  bool get canPass => isActive && statuses.contains(PASS);
  bool get canFail => isActive && statuses.contains(FAIL);

  String toString() {
    var result = '$constraint: [${statuses.join(",")}]';
    if (reason != null) {
      result = result + ' reason: $reason';
    }
    return result;
  }
}

const FAIL = const ExpectedStatus('fail');
const PASS = const ExpectedStatus('pass');
//const TIMEOUT = const ExpectedStatus._('timeout');

class ExpectedStatus {
  final String _status;
  const ExpectedStatus(this._status);
}


class Platform {
  final String name;
  final bool isActive;
  final RegExp versionPattern;
  Platform(this.name, this.isActive, this.versionPattern);

  int get currentVersion {
    if (!isActive) {
      return null;
    }
    var match = versionPattern.firstMatch(dom.window.navigator.userAgent);
    if (match == null) {
      return null;
    }
    return int.parse(match[1]);
  }

  String toString() => name;

  static final ie = new Platform('IE', _Device.isIE,
      new RegExp('MSIE ([0-9]+)'));
  static final chrome = new Platform('Chrome', _Device.isChrome,
      new RegExp('Chrome/([0-9]+)'));
  static final firefox = new Platform('Firefox', _Device.isFirefox,
      new RegExp('Firefox/([0-9]+)'));
  static final safari = new Platform('Safari', _Device.isWebKit,
      new RegExp(' Version/([0-9]+)'));
  static final dartium = new Platform('Dartium', _Device.isDartium,
      new RegExp('Chrome/([0-9]+)'));
}

class PlatformConstraint {
  final Platform platform;
  final String constraint;
  final bool isActive;

  PlatformConstraint.any(Platform platform) :
    this.platform = platform,
    this.constraint = '*',
    this.isActive = platform.isActive;

  PlatformConstraint.version(Platform platform, int version) :
    this.platform = platform,
    this.constraint = '=$version',
    this.isActive = platform.currentVersion == version;

  PlatformConstraint.lessThan(Platform platform, int version) :
    this.platform = platform,
    this.constraint = '<$version',
    this.isActive = _versionLessThan(platform, version);

  String toString() {
    return '$platform$constraint';
  }

  static bool _versionLessThan(Platform platform, int version) {
    var currentVersion = platform.currentVersion;
    if (currentVersion == null) {
      return false;
    }
    return currentVersion < version;
  }
}


class _Device {
  static String get userAgent => dom.window.navigator.userAgent;

  static bool get isOpera => userAgent.contains("Opera", 0);
  static bool get isIE => !isOpera && userAgent.contains("Trident/");
  static bool get isFirefox => _isFirefox = userAgent.contains("Firefox");
  static bool get isWebKit => !isOpera && userAgent.contains("WebKit/");
  static bool get isChrome => isWebKit && userAgent.contains("Chrome/");
  static bool get isDartium => isChrome && (1.0 is int);
}
