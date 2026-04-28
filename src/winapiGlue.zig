const std = @import("std");
const builtin = @import("builtin");
const windows = std.os.windows;

// https://learn.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-waitforsingleobject
pub const WAIT_OBJECT_0 = 0x00000000;
pub const WAIT_TIMEOUT_VAL = 0x00000102;
pub const INFINITE = 0xFFFFFFFF;

// https://learn.microsoft.com/en-us/windows/console/setconsolemode
pub const ENABLE_PROCESSED_OUTPUT: windows.DWORD = 0x0001;
pub const ENABLE_VIRTUAL_TERMINAL_PROCESSING: windows.DWORD = 0x0004;
pub const ENABLE_WINDOW_INPUT: windows.DWORD = 0x0008;
pub const ENABLE_MOUSE_INPUT: windows.DWORD = 0x0010;
pub const ENABLE_VIRTUAL_TERMINAL_INPUT: windows.DWORD = 0x0200;

pub const DISABLE_NEWLINE_AUTO_RETURN: windows.DWORD = 0x0008;

pub fn getConsoleMode(handle: windows.HANDLE) !windows.DWORD {
    var mode: windows.DWORD = 0;

    // nonzero value means success
    if (GetConsoleMode(handle, &mode) == .FALSE) {
        const err = windows.GetLastError();
        return windows.unexpectedError(err);
    }

    return mode;
}

// https://learn.microsoft.com/en-us/windows/console/getconsolemode
// BOOL WINAPI GetConsoleMode(
//   _In_  HANDLE  hConsoleHandle,
//   _Out_ LPDWORD lpMode
// );
extern "kernel32" fn GetConsoleMode(
    hConsoleHandle: windows.HANDLE,
    lpMode: *windows.DWORD,
) callconv(.winapi) windows.BOOL;

pub fn setConsoleMode(handle: windows.HANDLE, mode: windows.DWORD) !void {
    // nonzero value means success
    if (SetConsoleMode(handle, mode) == .FALSE) {
        const err = windows.GetLastError();
        return windows.unexpectedError(err);
    }
}

// https://learn.microsoft.com/en-us/windows/console/setconsolemode
// BOOL WINAPI SetConsoleMode(
//   _In_ HANDLE hConsoleHandle,
//   _In_ DWORD  dwMode
// );
extern "kernel32" fn SetConsoleMode(
    hConsoleHandle: windows.HANDLE,
    dwMode: windows.DWORD,
) callconv(.winapi) windows.BOOL;

pub fn getConsoleScreenBufferInfo(handle: windows.HANDLE) !CONSOLE_SCREEN_BUFFER_INFO {
    var csbi: CONSOLE_SCREEN_BUFFER_INFO = undefined;
    if (GetConsoleScreenBufferInfo(handle, &csbi) == 0) {
        const err = windows.GetLastError();
        return windows.unexpectedError(err);
    }
    return csbi;
}

// https://learn.microsoft.com/en-us/windows/console/getconsolescreenbufferinfo
// BOOL WINAPI GetConsoleScreenBufferInfo(
//   _In_  HANDLE                      hConsoleOutput,
//   _Out_ PCONSOLE_SCREEN_BUFFER_INFO lpConsoleScreenBufferInfo
// );
extern "kernel32" fn GetConsoleScreenBufferInfo(
    hConsoleOutput: windows.HANDLE,
    lpConsoleScreenBufferInfo: *CONSOLE_SCREEN_BUFFER_INFO,
) callconv(.winapi) windows.BOOL;

pub const SMALL_RECT = extern struct {
    Left: windows.SHORT,
    Top: windows.SHORT,
    Right: windows.SHORT,
    Bottom: windows.SHORT,
};

pub const CONSOLE_SCREEN_BUFFER_INFO = extern struct {
    dwSize: windows.COORD,
    dwCursorPosition: windows.COORD,
    wAttributes: windows.WORD,
    srWindow: SMALL_RECT,
    dwMaximumWindowSize: windows.COORD,
};

// https://learn.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-waitforsingleobject
// DWORD WaitForSingleObject(
//   [in] HANDLE hHandle,
//   [in] DWORD  dwMilliseconds
// );
pub extern "kernel32" fn WaitForSingleObject(
    hHandle: windows.HANDLE,
    dwMilliseconds: windows.DWORD,
) callconv(.winapi) windows.DWORD;
