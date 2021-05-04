import 'package:flutter_test/flutter_test.dart';
import 'package:movies_bloc/utils/media_query_utils.dart';

void main() {
  test('should get the right count', () {
    expect(getCount(800), 4);
    expect(getCount(600), 2);
    expect(getCount(200), 1);
  });
}
