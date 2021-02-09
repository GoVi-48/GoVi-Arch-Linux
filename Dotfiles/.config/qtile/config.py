# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List  # noqa: F401
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import socket
import webbrowser

mod = "mod4"
terminal = guess_terminal()


@lazy.function
def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)


@lazy.function
def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)


# ================================= SHORTCUTS =================================  #
keys = [
    # Switch between windows in current stack pane
    Key([mod], "k", lazy.layout.down(),),
    Key([mod], "j", lazy.layout.up(),),

    # Move windows up or down in current stack
    Key([mod, "control"], "k", lazy.layout.shuffle_down(),),
    Key([mod, "control"], "j", lazy.layout.shuffle_up(),),

    # Window grow Right
    Key([mod, "control"], "Right",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),),

    # Window grow Light
    Key([mod, "control"], "Left",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease(),
        lazy.layout.add(),),

    # Window grow Right
    Key([mod, "control"], "Up",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(), ),

    # Window grow Light
    Key([mod, "control"], "Down",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.decrease(),
        lazy.layout.add(), ),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.next(),),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate(),),

    # Toggle between split and unsplit sides of stack.
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(),),

    # Kill Window
    Key([mod], "w", lazy.window.kill(),),

    # Terminal
    Key([mod], "t", lazy.spawn(terminal),),

    # Run Command
    Key([mod], "r", lazy.spawncmd(),),

    # Restart Shutdown
    Key([mod, "control"], "r", lazy.restart(),),
    Key([mod, "control"], "q", lazy.shutdown(),),

]


# ================================= GROUPS =================================  #
groups = [Group(i) for i in "123456"]

# Switch Groups
for i in groups:
    keys.extend([
        # mod + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen()),

        # mod + n = Next group, mod + p = Previous group
        Key([mod], "n", lazy.screen.next_group()),
        Key([mod], "p", lazy.screen.prev_group()),

        # mod + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.

        # mod + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window".format(i.name)),w.togroup(i.name),
        #   desc="move focused window to group {}".format(i.name)),
    ])


# ================================= LAYOUTS =================================  #
layout_theme = {"border_width": 3,
                "margin": 11,
                "border_focus": "#86ACE0",
                "border_normal": "#305673"
                }
layouts = [
    layout.Max(),
    layout.MonadTall(**layout_theme),
    # layout.Bsp(),
    # layout.Floating(),
    # layout.Stack(num_stacks=2),
    # layout.Columns(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]


# ================================= WIDGETS =================================  #
def logout(qtile):
    qtile.cmd_spawn('kill -9 -1')


def pavucontrol(qtile):
    qtile.cmd_spawn('pavucontrol')


# def check_network():
#    try:
#        socket.create_connection(('Google.com', 80))
#        network = '~/Pictures/GoVi-Theme/Icons/GoVi_gtk-Icons/apps/64/eth_on'
#    except OSError:
#        network = '~/Pictures/GoVi-Theme/Icons/GoVi_gtk-Icons/apps/64/eth_off'


# def open_url():
#    webbrowser.open_new_tab('https://www.speedtest.net/')


widget_defaults = dict(
    background='#21242B',
    foreground='#dfdfdf',
    font='Source Code Pro',
    fontsize=15,
    margin=5,
    padding=3,)

extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Image(filename='~/Pictures/GoVi-Theme/GoVi_gtk/GoVi_gtk-Icons/apps/64/archlinux.png',
                             margin=0,
                             mouse_callbacks={'Button1': logout}),
                widget.CurrentLayoutIcon(scale=0.7),
                widget.GroupBox(),
                widget.Prompt(),
                widget.TaskList(borderwidth=2, border="#5C718E", fontsize=14, max_title_width=300,),
                widget.Systray(),
                # widget.Image(filename=network()),
                #              mouse_callbacks={'Button1': open_url()}),
                widget.Image(filename='~/Pictures/GoVi-Theme/GoVi_gtk/GoVi_gtk-Icons/panel/audio-volume-zero-panel.svg',
                             mouse_callbacks={'Button1': pavucontrol}),
                widget.Clock(fontsize=17,),
            ],
            32,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None  # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
