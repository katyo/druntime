/**
 * D header file for C99.
 *
 * $(C_HEADER_DESCRIPTION pubs.opengroup.org/onlinepubs/009695399/basedefs/_time.h.html, _time.h)
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License: Distributed under the
 *      $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0).
 *    (See accompanying file LICENSE)
 * Authors:   Sean Kelly,
 *            Alex Rønne Petersen
 * Source:    $(DRUNTIMESRC core/stdc/_time.d)
 * Standards: ISO/IEC 9899:1999 (E)
 */

module core.stdc.time;

version (Posix)
    public import core.sys.posix.stdc.time;
else version (Windows)
    public import core.sys.windows.stdc.time;
else version (CRuntime_Newlib)
{
    private import core.stdc.config;

    version (RISCV32) enum isRISCV = true;
    else version (RISCV64) enum isRISCV = true;
    else enum isRISCV = false;

    version (ARM) enum isARM = true;
    else version (AArch64) enum isARM = true;
    else enum isARM = false;

    enum isRTEMS = false;
    enum isVISIUM = false;

    extern (C):
    @trusted: // There are only a few functions here that use unsafe C strings.
    nothrow:
    @nogc:

    ///
    struct tm
    {
        int     tm_sec;     /// seconds after the minute - [0, 60]
        int     tm_min;     /// minutes after the hour - [0, 59]
        int     tm_hour;    /// hours since midnight - [0, 23]
        int     tm_mday;    /// day of the month - [1, 31]
        int     tm_mon;     /// months since January - [0, 11]
        int     tm_year;    /// years since 1900
        int     tm_wday;    /// days since Sunday - [0, 6]
        int     tm_yday;    /// days since January 1 - [0, 365]
        int     tm_isdst;   /// Daylight Saving Time flag
    }

    ///
    alias long time_t;
    ///
    alias c_ulong clock_t;

    static if (isRTEMS || isVISIUM || isRISCV) enum clock_t CLOCKS_PER_SEC = 1000_000;
    static if (isARM) enum clock_t CLOCKS_PER_SEC = 100;
    else enum clock_t CLOCKS_PER_SEC = 1_000;

    clock_t clock();
}
else
    static assert(0, "unsupported system");

private import core.stdc.config;

extern (C):
@trusted: // There are only a few functions here that use unsafe C strings.
nothrow:
@nogc:

///
pure double  difftime(time_t time1, time_t time0); // MT-Safe
///
@system time_t  mktime(scope tm* timeptr); // @system: MT-Safe env locale
///
time_t  time(scope time_t* timer);

///
@system char*   asctime(const scope tm* timeptr); // @system: MT-Unsafe race:asctime locale
///
@system char*   ctime(const scope time_t* timer); // @system: MT-Unsafe race:tmbuf race:asctime env locale
///
@system tm*     gmtime(const scope time_t* timer); // @system: MT-Unsafe race:tmbuf env locale
///
@system tm*     localtime(const scope time_t* timer); // @system: MT-Unsafe race:tmbuf env locale
///
@system size_t  strftime(scope char* s, size_t maxsize, const scope char* format, const scope tm* timeptr); // @system: MT-Safe env locale
