#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.53)
AC_INIT()

# Checks for programs.
AC_PROG_CC
AC_PROG_MAKE_SET

if test "x$GCC" = "xyes"; then
    CFLAGS="$CFLAGS -Wall"
fi

# Locating Erlang
AM_WITH_ERLANG

# Check for 32-bit or 64-bit Erlang
AC_LANG(Erlang)
AC_RUN_IFELSE(
	    [AC_LANG_PROGRAM([],[dnl
	     halt(case erlang:system_info(wordsize) of
	     8 -> 0; 4 -> 1 end)])],
	    [AC_MSG_NOTICE(found 64-bit Erlang)
	     CBIT=-m64],
	    [AC_MSG_NOTICE(found 32-bit Erlang)
	     CBIT=-m32])

# where to install Erlang applications
AC_ERLANG_SUBST_INSTALL_LIB_DIR

# Checks for typedefs, structures, and compiler characteristics.
#AC_C_CONST

# Checks for library functions.
#AC_FUNC_MALLOC
#AC_HEADER_STDC

# Check Erlang headers are installed
#AC_CHECK_HEADER(erl_driver.h,,[AC_MSG_ERROR([cannot find Erlang header files])])

CFLAGS="$CFLAGS $CBIT"
LD_SHARED="$LD_SHARED $CBIT"

AC_CONFIG_FILES([Makefile
                 c_src/suffixtree/Makefile
                 c_src/gsuffixtree/Makefile])

AC_OUTPUT
