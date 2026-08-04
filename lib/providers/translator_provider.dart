import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/language.dart';
import '../models/translation_history.dart';
import '../services/translation_service.dart';

enum TranslationStatus { idle, loading, success, error }

class TranslatorProvider extends ChangeNotifier {
  Language _sourceLang = Language.autoDetect;
  Language _targetLang = Language.supportedLanguages[0]; // English
  String _inputText = '';
  String _outputText = '';
  TranslationStatus _status = TranslationStatus.idle;
  List<TranslationHistory> _history = [];
  bool _isSpeaking = false;

  Language get sourceLang => _sourceLang;
  Language get targetLang => _targetLang;
  String get inputText => _inputText;
  String get outputText => _outputText;
  TranslationStatus get status => _status;
  List<TranslationHistory> get history => _history;
  bool get isSpeaking => _isSpeaking;
  bool get isLoading => _status == TranslationStatus.loading;

  TranslatorProvider() {
    _loadHistory();
  }

  void setSourceLang(Language lang) {
    _sourceLang = lang;
    notifyListeners();
    if (_inputText.isNotEmpty) translate();
  }

  void setTargetLang(Language lang) {
    _targetLang = lang;
    notifyListeners();
    if (_inputText.isNotEmpty) translate();
  }

  void swapLanguages() {
    if (_sourceLang == Language.autoDetect) return;
    final temp = _sourceLang;
    _sourceLang = _targetLang;
    _targetLang = temp;
    final tempText = _inputText;
    _inputText = _outputText;
    _outputText = tempText;
    notifyListeners();
    if (_inputText.isNotEmpty) translate();
  }

  void setInputText(String text) {
    _inputText = text;
    if (text.isEmpty) {
      _outputText = '';
      _status = TranslationStatus.idle;
      notifyListeners();
    }
  }

  Future<void> translate() async {
    if (_inputText.trim().isEmpty) return;

    _status = TranslationStatus.loading;
    _outputText = '';
    notifyListeners();

    final result = await TranslationService.translate(
      text: _inputText,
      sourceLang: _sourceLang.code,
      targetLang: _targetLang.code,
    );

    _outputText = result['translation'] ?? '';
    _status = _outputText.isNotEmpty
        ? TranslationStatus.success
        : TranslationStatus.error;

    if (_status == TranslationStatus.success) {
      _saveToHistory();
    }

    notifyListeners();
  }

  void setIsSpeaking(bool val) {
    _isSpeaking = val;
    notifyListeners();
  }

  Future<void> _saveToHistory() async {
    if (_outputText.isEmpty || _inputText.isEmpty) return;

    final entry = TranslationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sourceText: _inputText,
      translatedText: _outputText,
      sourceLang: _sourceLang.code,
      targetLang: _targetLang.code,
      sourceLangName: _sourceLang.name,
      targetLangName: _targetLang.name,
      timestamp: DateTime.now(),
    );

    _history.insert(0, entry);
    if (_history.length > 50) _history = _history.take(50).toList();

    final prefs = await SharedPreferences.getInstance();
    final jsonList = _history.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('translation_history', jsonList);

    notifyListeners();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('translation_history') ?? [];
    _history = jsonList
        .map((e) => TranslationHistory.fromJson(json.decode(e) as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('translation_history');
    notifyListeners();
  }

  void deleteHistoryItem(String id) async {
    _history.removeWhere((e) => e.id == id);
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _history.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('translation_history', jsonList);
    notifyListeners();
  }
}
