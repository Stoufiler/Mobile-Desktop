class QueueService {
  final List<dynamic> _items = [];
  int _currentIndex = -1;

  List<dynamic> get items => List.unmodifiable(_items);

  dynamic get currentItem =>
      (_currentIndex >= 0 && _currentIndex < _items.length)
          ? _items[_currentIndex]
          : null;

  int get currentIndex => _currentIndex;
  bool get hasNext => _currentIndex < _items.length - 1;
  bool get hasPrevious => _currentIndex > 0;

  void setQueue(List<dynamic> items, {int startIndex = 0}) {
    _items
      ..clear()
      ..addAll(items);
    _currentIndex = items.isEmpty ? -1 : startIndex.clamp(0, _items.length - 1);
  }

  void addItems(List<dynamic> items) {
    _items.addAll(items);
  }

  void next() {
    if (hasNext) _currentIndex++;
  }

  void previous() {
    if (hasPrevious) _currentIndex--;
  }

  void clear() {
    _items.clear();
    _currentIndex = -1;
  }
}
