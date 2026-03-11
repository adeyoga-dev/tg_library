# Task Proposals from Codebase Review

## 1) Typo fix task
**Task:** Replace the greeting text `"Hallo"` with `"Halo"` (or your preferred product-standard greeting) in the profile header on `BodyScreen`.

**Why:** The current spelling looks like an accidental typo in the UI and can reduce perceived polish.

**Source:** `lib/page/body_screen.dart` shows `"Hallo, ..."` in the header text.

---

## 2) Bug fix task
**Task:** Guard async `setState` calls with `mounted` checks in `BodyScreen` (`_loadUser()` and `_fetchDocuments()`).

**Why:** These methods `await` asynchronous work and then call `setState`. If the widget is disposed before completion, this can trigger `setState() called after dispose()` at runtime.

**Source:** `lib/page/body_screen.dart` has asynchronous methods that call `setState` after `await`.

---

## 3) Code comment / documentation discrepancy task
**Task:** Rewrite `test/widget_test.dart` header comments to match the real app behavior (authentication gate + document center), not the default Flutter counter example.

**Why:** The current comments describe a counter app interaction (`+` button / increment flow), but this project does not implement that UI.

**Source:** `test/widget_test.dart` still contains default counter app explanatory comments.

---

## 4) Test improvement task
**Task:** Replace the default counter smoke test with a realistic app-level test for `AuthGate` routing behavior (e.g., unauthenticated users see `WelcomeScreen`, authenticated users navigate to `BodyScreen` via mocked storage).

**Why:** The existing test asserts counter text and `Icons.add`, which do not exist in this app, so the test is low-value and likely failing.

**Source:** `test/widget_test.dart` currently checks for counter values and taps `Icons.add`.
