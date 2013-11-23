(function(scope) {

  var dartCode = [
    'library test_runner;',
    '',
    'import "dart:html" as dom;',
    'import "package:browser_test/browser_test.dart";',
    'import "package:browser_test/mocha_display.dart";',
    '$imports',
    '',
    'main() {',
    '  useBrowserConfiguration();',
    '  $invocations',
    '}'
  ].join('\n');

  function mochaRunner(tests) {
    var imports = [];
    var invocations = [];
    if (document.querySelector('#mocha')) {
      invocations.push('  new MochaDisplay(dom.querySelector("#mocha"));');
    }
    for (var i = 0; i < tests.length; ++i) {
      imports.push('import "' + tests[i] + '" as test_lib' + i + ";");
      invocations.push('  group("' + tests[i] + '", () {');
      invocations.push('    test_lib' + i + '.main();');
      invocations.push('});');
    }
    var code = dartCode.replace('$imports', imports.join('\n'));
    code = code.replace('$invocations', invocations.join('\n'));
    var dartScript = document.createElement('script');
    dartScript.textContent = code;
    dartScript.type = 'application/dart';
    document.body.appendChild(dartScript);
  }

  scope.mochaRunner = mochaRunner;
})(this);
