- Use `snake_case`
- Always in past tense
```gdscript
signal button_clicked
signal door_opened
```

- Use parentheses if the signals have parameters
```gdscript
signal points_updated(before, after)
```

- Append `_started` or `_finished` if the signal corresponds to the beginning or the end of an action
```gdscript
signal transition_started(animation)
signal transition_finished
```

