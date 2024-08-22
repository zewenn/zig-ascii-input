> [!CAUTION]
> This library is **DEPRECATED** and will not be supported further.

# Zig Termnal Input Library
> [!WARNING]
> This library currently only supports Linux and MacOS

## How to use?
```zig
zinput.init(&allocator);
```
> [!IMPORTANT]
> This will set the terminal to **RAW** mode, make sure to call `zinput.deinit()` to change it back to cooked mode!
```zig
for (zinput.getKeys()) |key| switch (key) {
    zinput.keys.ESCAPE => break :game_loop,
    else => {},
};
```
By calling the `zinput.getKeys()` function, you will get a `u8` buffer with all the keys pressed on that frame.
> [!WARNING]
> This only works with new keypresses, only one key can be held down.