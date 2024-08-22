const std = @import("std");
const io = @import("std").io;
const os = @import("std").os;
const Allocator = @import("std").mem.Allocator;

const clang = @cImport({
    @cInclude("stdlib.h");
    // @cInclude("sgtty.h");
});

pub const zinput = struct {
    pub const Terminal = struct {
        setToRaw: *const fn () void,
        setToCooked: *const fn () void,
    };

    const NotImplementedError = error{NotImplemented};

    pub inline fn getTerminal() NotImplementedError!Terminal {
        switch (@import("builtin").target.os.tag) {
            // zls ignore
            .windows => {
                _ = @cImport({
                    @cInclude("windows.h");
                });
                return NotImplementedError;
            },
            .linux, .macos => {
                const UnixTerminal = struct {
                    fn raw() void {
                        _ = clang.system("stty raw");
                    }
                    fn cooked() void {
                        _ = clang.system("stty cooked");
                    }
                    pub const self = Terminal{
                        .setToRaw = raw,
                        .setToCooked = cooked,
                    };
                };
                return UnixTerminal.self;
            },
            else => NotImplementedError,
        }
    }

    pub const Reader = std.fs.File.Reader;

    var read_file: std.fs.File = undefined;
    var io_reader: Reader = undefined;

    var buffer: []u8 = undefined;
    var alloc: *Allocator = undefined;
    var terminal: Terminal = undefined;

    pub const debug = struct {
        pub fn printBuf() void {
            std.debug.print("|", .{});
            for (buffer) |key| {
                if (key < 47 or key > 127) continue;
                std.debug.print("{c} ", .{key});
            }
            std.debug.print("|\n\r", .{});
        }
    };

    /// Set up. Terminal WILL BE SET TO RAW MODE!
    pub fn init(allocator: *Allocator) !void {
        read_file = io.getStdIn();
        io_reader = read_file.reader();
        alloc = allocator;

        buffer = allocator.alloc(u8, 4096) catch unreachable;

        // clang.sgttyb;
        terminal = try getTerminal();
        terminal.setToRaw();
    }

    pub fn update() void {
        _ = io_reader.read(buffer) catch {
            std.debug.print("Failed to read into buffer :(", .{});
            return;
        };
        // std.debug.print("{s}", .{buffer});
    }

    pub fn getKeys() []u8 {
        return buffer;
    }

    pub fn deinit() void {
        alloc.free(buffer);
        terminal.setToCooked();
    }

    pub const keys = struct {
        pub const NULL: u8 = 0;
        pub const SOH: u8 = 1;
        pub const STX: u8 = 2;
        pub const ETX: u8 = 3;
        pub const EOT: u8 = 4;
        pub const ENQ: u8 = 5;
        pub const ACK: u8 = 6;
        pub const BEL: u8 = 7;
        pub const BACKSPACE: u8 = 8;
        pub const HORTIZONTAL_TAB: u8 = 9;
        pub const LINE_FEED: u8 = 10;
        pub const VERTICAL_TAB: u8 = 11;
        pub const FROM_FEED: u8 = 12;
        pub const ENTER: u8 = 13;
        pub const SHIFT_OUT: u8 = 14;
        pub const SHIFT_IN: u8 = 15;
        pub const DLE: u8 = 16;
        pub const DC1: u8 = 17;
        pub const DC2: u8 = 18;
        pub const DC3: u8 = 19;
        pub const DC4: u8 = 20;
        pub const NAK: u8 = 21;
        pub const SYN: u8 = 22;
        pub const ETB: u8 = 23;
        pub const CANCEL: u8 = 24;
        pub const EM: u8 = 25;
        pub const SUB: u8 = 26;
        pub const ESCAPE: u8 = 27;
        pub const FS: u8 = 28;
        pub const GS: u8 = 29;
        pub const RS: u8 = 30;
        pub const US: u8 = 31;
        pub const SPACE: u8 = 32;
        pub const EXCLAMATION_MARK: u8 = 33;
        pub const DOUBLE_QUOTE: u8 = 34;
        pub const HASHTAG: u8 = 35;
        pub const DOLLARSIGN: u8 = 36;
        pub const PERCENTAGE: u8 = 37;
        pub const ANDSIGN: u8 = 38;
        pub const SINGLE_QUOTE: u8 = 39;
        pub const ROUND_BRACKET_START: u8 = 40;
        pub const ROUND_BRACKET_END: u8 = 41;
        pub const STAR_SIGN: u8 = 42;
        pub const PLUS_SIGN: u8 = 43;
        pub const COMA: u8 = 44;
        pub const MINUS_SIGN: u8 = 45;
        pub const DOT: u8 = 46;
        pub const SLASH_SIGN: u8 = 47;
        pub const NUMBER_0: u8 = 48;
        pub const NUMBER_1: u8 = 49;
        pub const NUMBER_2: u8 = 50;
        pub const NUMBER_3: u8 = 51;
        pub const NUMBER_4: u8 = 52;
        pub const NUMBER_5: u8 = 53;
        pub const NUMBER_6: u8 = 54;
        pub const NUMBER_7: u8 = 55;
        pub const NUMBER_8: u8 = 56;
        pub const NUMBER_9: u8 = 57;
        pub const COLON: u8 = 58;
        pub const SEMI_COLON: u8 = 59;
        pub const LARGER_SIGN: u8 = 60;
        pub const EQUAL_SIGN: u8 = 61;
        pub const SMALLER_SIGN: u8 = 62;
        pub const QUESTION_MARK: u8 = 63;
        pub const AT_SIGN: u8 = 64;
        pub const A: u8 = 65;
        pub const B: u8 = 66;
        pub const C: u8 = 67;
        pub const D: u8 = 68;
        pub const E: u8 = 69;
        pub const F: u8 = 70;
        pub const G: u8 = 71;
        pub const H: u8 = 72;
        pub const I: u8 = 73;
        pub const J: u8 = 74;
        pub const K: u8 = 75;
        pub const L: u8 = 76;
        pub const M: u8 = 77;
        pub const N: u8 = 78;
        pub const O: u8 = 79;
        pub const P: u8 = 80;
        pub const Q: u8 = 81;
        pub const R: u8 = 82;
        pub const S: u8 = 83;
        pub const T: u8 = 84;
        pub const U: u8 = 85;
        pub const V: u8 = 86;
        pub const W: u8 = 87;
        pub const X: u8 = 88;
        pub const Y: u8 = 89;
        pub const Z: u8 = 90;
        pub const SQUARE_BRACKET_START: u8 = 91;
        pub const BACKSLASH: u8 = 92;
        pub const SQUARE_BRACKET_END: u8 = 93;
        pub const CIRCUMFLEX: u8 = 94;
        pub const UNDERSCORE: u8 = 95;
        pub const GRAVE_ACCENT: u8 = 96;
        pub const a: u8 = 97;
        pub const b: u8 = 98;
        pub const c: u8 = 99;
        pub const d: u8 = 100;
        pub const e: u8 = 101;
        pub const f: u8 = 102;
        pub const g: u8 = 103;
        pub const h: u8 = 104;
        pub const i: u8 = 105;
        pub const j: u8 = 106;
        pub const k: u8 = 107;
        pub const l: u8 = 108;
        pub const m: u8 = 109;
        pub const n: u8 = 110;
        pub const o: u8 = 111;
        pub const p: u8 = 112;
        pub const q: u8 = 113;
        pub const r: u8 = 114;
        pub const s: u8 = 115;
        pub const t: u8 = 116;
        pub const u: u8 = 117;
        pub const v: u8 = 118;
        pub const w: u8 = 119;
        pub const x: u8 = 120;
        pub const y: u8 = 121;
        pub const z: u8 = 122;
        pub const CURLY_BRACKET_START: u8 = 123;
        pub const VERTICAL_BAR: u8 = 124;
        pub const CURLY_BRACKET_END: u8 = 125;
        pub const SWUNG_DASH: u8 = 126;
        pub const DELETE: u8 = 127;
    };
};
