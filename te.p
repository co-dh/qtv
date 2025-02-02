import curses as C

import curses

def initColors(stdscr):
    if C.has_colors():
        C.use_default_colors()
        for i in range(256):
            C.init_pair(i + 1, i, -1)  # Foreground: i, Background: default

def init():
    stdscr = C.initscr()

    # Turn off echoing of keys, and enter cbreak mode,
    # where no buffering is performed on keyboard input
    C.noecho()
    C.cbreak()

    # In keypad mode, escape sequences for special keys
    # (like the cursor keys) will be interpreted and
    # a special value like curses.KEY_LEFT will be returned
    stdscr.keypad(1)

    # Start color, too.  Harmless if the terminal doesn't have
    # color; user can test with has_color() later on.  The try/catch
    # works around a minor bit of over-conscientiousness in the curses
    # module -- the error return from C start_color() is ignorable.
    try:
        C.start_color()
        initColors(stdscr)
    except:
        pass

    C.curs_set(0) # no blinking cursor
    return stdscr

def fini(stdscr):
    stdscr.keypad(0)
    C.echo()
    C.nocbreak()
    C.endwin()

def getAttr():
    return {x:getattr(C,x) for x in dir(C) if x.startswith('A_')}

def getKey():
    return {x:getattr(C,x) for x in dir(C) if x.startswith('KEY_')}

class Foo():
    def f(self, x, y):
        print(type(x), type(y))
        return x+y


def init1():
    return Foo()

