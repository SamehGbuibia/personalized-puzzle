import 'package:puzzle_mvvm/app/app_prefs.dart';
import 'package:puzzle_mvvm/app/di.dart';
import 'package:puzzle_mvvm/domain/repositry/repositry.dart';

class RepositoryImplementer extends Repository {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  List<String> _data = [];
  @override
  addPuzzle(String puzzle) {
    _data.add(puzzle);
    _appPreferences.setData(_data);
  }

  @override
  List<String> getData() {
    return _data;
  }

  @override
  initialData() {
    _data = _appPreferences.getData();
  }
}
