## Godot-FilteredEdits

Extends base nodes `LineEdit` and `TextEdit` with `FilteredLineEdit` and `FilteredTextEdit`, respectively, to filter user input. It also allows numeric text value clamping.

If you download the full repository, you will get a small showcase project.

---

Features:
- **Filtering**. Filters user input according to `filter_mode`. Filter modes:
  - `none`: no filter.
  - `no-num`: no 0-9 characters.
  - `+0i`: positive or zero integer.
  - `i`: integer.
  - `+0f` positive or zero float.
  - `f` float.
- **Clamping**.`FilteredLineEdit.clamp_text`, `FilteredTextEdit.clamp_line`, `FilteredTextEdit.clamp_lines` to clamp values.
- **Autocompletion**. If there is no text and you press `-`/`.` (in the right `filter_mode`) it will write `-0`/`0.` respectively. Similarly, if you delete `0` from `-0`/`0.` the `-`/`.` will also be deleted.

Notes:
- You might also find useful `LineEdit.virtual_keyboard_enabled` and `LineEdit.virtual_keyboard_type`. `TextEdit.virtual_keyboard_enabled` is there but `TextEdit.virtual_keyboard_type` is not (Godot 4.1), see [this](https://github.com/godotengine/godot-proposals/issues/7449). Also, consider that the user could use the physical keyboard to introduce undesired characters.
- "." and "-" count as characters in `FilteredLineEdit.max_length`.
- I [requested](https://github.com/godotengine/godot-proposals/issues/7193) filter features to be implemented in base Godot, that would require changing base node signals. Meanwhile, I created this workaround.

#### Known issues

- Won't fix issue [Limitation: select all text and press `-`/`.`](https://github.com/acgc99/Godot-FilteredEdits/issues/15#issue).
- There are some bugs, check issues and open a new one if you find untracked bugs.

---

### Assets

All non-Godot icons has been downloaded form [Pictogrammers](https://pictogrammers.com/docs/general/license/).
