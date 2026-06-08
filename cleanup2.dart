import 'dart:io';
import 'dart:convert';

void main() async {
  var file = File('analyze_utf8.json');
  var content = file.readAsStringSync();
  Map<String, dynamic> data;
  try {
    data = json.decode(content);
  } catch (e) {
    // try removing potential BOM or extra leading metadata 
    var prefix = content.indexOf('{');
    if (prefix != -1) {
      data = json.decode(content.substring(prefix));
    } else {
      print('Could not parse JSON: \$e');
      return;
    }
  }

  var diagnostics = data['diagnostics'] as List<dynamic>? ?? [];
  
  var unusedImports = diagnostics.where((d) => d['code'] == 'unused_import').toList();
  var unusedLocalVars = diagnostics.where((d) => d['code'] == 'unused_local_variable').toList();
  
  // group by file
  var filesToEdit = <String, Set<int>>{};
  for (var d in unusedImports) {
    var loc = d['location'];
    var path = loc['file'] as String;
    var line = loc['startLine'] as int;
    filesToEdit.putIfAbsent(path, () => <int>{}).add(line);
  }

  for (var entry in filesToEdit.entries) {
    var path = entry.key;
    var linesToRemove = entry.value.toList()..sort((a, b) => b.compareTo(a));
    
    var f = File(path);
    if (!f.existsSync()) continue;
    var lines = f.readAsLinesSync();
    
    for (var l in linesToRemove) {
      lines.removeAt(l - 1);
    }
    
    f.writeAsStringSync(lines.join('\n') + '\n');
    print('Cleaned \$path');
  }

  // Any curly brace missing was already manually fixed.
  // Wait, let's also remove unused_local_variable lines if they are standalone declarations
  var varsToEdit = <String, Set<int>>{};
  for (var d in unusedLocalVars) {
     var loc = d['location'];
     varsToEdit.putIfAbsent(loc['file'], () => <int>{}).add(loc['startLine']);
  }
  for (var entry in varsToEdit.entries) {
    var path = entry.key;
    var linesToRemove = entry.value.toList()..sort((a, b) => b.compareTo(a));
    var f = File(path);
    if (!f.existsSync()) continue;
    var lines = f.readAsLinesSync();
    // basic removal 
    for (var l in linesToRemove) {
      var text = lines[l - 1].trim();
      if (text.startsWith('var ') || text.startsWith('final ') || text.startsWith('String ') || text.startsWith('int ') || text.startsWith('bool ')) {
         lines.removeAt(l - 1);
      }
    }
    f.writeAsStringSync(lines.join('\n') + '\n');
  }
}
