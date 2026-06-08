import 'dart:io';

void main() {
  var dir = Directory('.');
  for (var file in dir.listSync(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      var content = file.readAsStringSync();
      var newContent = content.replaceAll(RegExp(r'\{Key\?\s*key\s*,\s*'), '{super.key, ');
      newContent = newContent.replaceAll(RegExp(r'\{Key\?\s*key\}'), '{super.key}');
      newContent = newContent.replaceAll(RegExp(r'\s*:\s*super\(\s*key\s*:\s*key\s*\)'), '');
      
      newContent = newContent.replaceAllMapped(RegExp(r'\.withOpacity\(([^)]+)\)'), (match) => '.withValues(alpha: ${match.group(1)})');
      
      if (content != newContent) {
        file.writeAsStringSync(newContent);
        print('Updated \${file.path}');
      }
    }
  }
}
