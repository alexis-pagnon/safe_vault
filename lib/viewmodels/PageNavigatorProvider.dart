
import 'package:flutter/material.dart';
import 'package:safe_vault/models/database/Password.dart';

class PageNavigatorProvider extends ChangeNotifier {
  final PageController _pageController = PageController();

  Password? _passwordToUpdate;
  int _currentPage = 0;
  int _filterPassword = 0;
  int _filterNote = 0;

  int get currentPage => _currentPage;
  int get filterPassword => _filterPassword;
  int get filterNote => _filterNote;
  PageController get pageController => _pageController;
  Password? get passwordToUpdate => _passwordToUpdate;


  /// Navigate to a specific page in the PageView.<br>
  /// @param pageIndex The index of the page to navigate to.
  void jumpToPage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }


  // Called by PageView
  void onPageChanged(int index) {
    _currentPage = index;


    // Any passive navigation to the form = CREATE mode
    if (index == 2 && _passwordToUpdate == null) {
      // already create, do nothing
    }

    // Leaving the modification of a password -> wipe sensitive state
    if (index != 2) {
      _passwordToUpdate = null;
    }

    notifyListeners();
  }


  void jumpToUpdatePassword(Password password) {
    _passwordToUpdate = password;
    notifyListeners();
    jumpToPage(2);
  }


  void updateFilterPassword(int filterIndex) {
    _filterPassword = filterIndex;
    notifyListeners();
  }


  void updateFilterNote(int filterIndex) {
    _filterNote = filterIndex;
    notifyListeners();
  }


  void reset() {
    _passwordToUpdate = null;
    _currentPage = 0;
    _filterPassword = 0;
    _filterNote = 0;
    notifyListeners();
  }



  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}