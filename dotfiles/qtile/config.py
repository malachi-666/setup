import os
import subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

mod = "mod4"
terminal = "kitty"

keys = [
    # Window Management
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),

    # System and Execution
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "r", lazy.spawn("rofi -show drun"), desc="Launch rofi"),
    Key([mod], "b", lazy.spawn("qutebrowser"), desc="Launch qutebrowser"),
]

groups = [Group(i) for i in "123456789"]
for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(), desc=f"Switch to group {i.name}"),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True), desc=f"Move to group {i.name}"),
    ])

layouts = [
    layout.MonadTall(border_focus="#5e81ac", border_normal="#4c566a", border_width=2, margin=8),
    layout.Max(),
]

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(active="#eceff4", inactive="#4c566a", highlight_method="line", this_current_screen_border="#81a1c1"),
                widget.Prompt(),
                widget.WindowName(foreground="#88c0d0"),
                widget.Chord(chords_colors={"launch": ("#ff0000", "#ffffff")}, name_transform=lambda name: name.upper()),
                widget.Systray(),
                widget.Memory(format='RAM: {MemUsed: .0f}{mm} / {MemTotal: .0f}{mm}', foreground="#ebcb8b"),
                widget.CPU(format='CPU: {load_percent}%', foreground="#a3be8c"),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p", foreground="#b48ead"),
            ],
            24,
            background="#2e3440",
        ),
    ),
]

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    *layout.Floating.default_float_rules,
    Match(wm_class="confirmreset"),
    Match(wm_class="makebranch"),
    Match(wm_class="maketag"),
    Match(wm_class="ssh-askpass"),
    Match(title="branchdialog"),
    Match(title="pinentry"),
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wmname = "LG3D"

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~')
    subprocess.call([f'{home}/.config/qtile/autostart.sh'])
