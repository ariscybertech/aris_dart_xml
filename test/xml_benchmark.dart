library xml_benchmark;

import 'package:xml/xml.dart';
import 'xml_examples.dart';

double benchmark(Function function, [int warmup = 5, int milliseconds = 2500]) {
  var count = 0;
  var elapsed = 0;
  var watch = new Stopwatch();
  while (warmup-- > 0) {
    function();
  }
  watch.start();
  while (elapsed < milliseconds) {
    function();
    elapsed = watch.elapsedMilliseconds;
    count++;
  }
  return elapsed / count;
}

String characterData() {
  var string = '''a&bc<def"gehi'jklm>nopqr''';
  var builder = new XmlBuilder();
  builder.processing('xml', 'version="1.0"');
  builder.element('character', nest: () {
    for (var i = 0; i < 20; i++) {
      builder.text(string + string + string + string + string + string);
      builder.element('foo', nest: () {
        builder.attribute('key', string + string + string + string);
      });
    }
  });
  return builder.build().toString();
}

final benchmarks = {
  'books': booksXml,
  'shiporder': shiporderXsd,
  'decoding': characterData(),
};

void main() {
  var builder = new XmlBuilder();
  builder.processing('xml', 'version="1.0"');
  builder.element('benchmarks', nest: () {
    for (var name in benchmarks.keys) {
      builder.element(name, nest: () {
        final source = benchmarks[name];
        builder.text(benchmark(() => parse(source)));
      });
    }
  });
  print(builder.build().toXmlString(pretty: true));
}
