{ config, pkgs, ... }:

{
  home.username = "mxi";
  home.homeDirectory = "/home/mxi";
  home.stateVersion = "24.05";

  # User specific packages.
  # Zero global python packages via Nix. `uv` handles python.
  home.packages = with pkgs; [
    uv
    neovim
    pkgs.emacs
    git gh ripgrep fd fzf starship navi

    # GUI and theming tools for the "ready out of the box" feel
    rofi
    feh
    kitty
  ];

  # Basic Git config
  programs.git = {
    enable = true;
    userName = "Paradigm User";
    userEmail = "user@paradigm.local";
  };

  # Nushell as default
  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config = {
        show_banner: false,
      }
    '';
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };

  # Declaratively define Qtile configuration for instant readiness
  home.file.".config/qtile/config.py".text = ''
import os
import subprocess
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

mod = "mod4"
terminal = "kitty"

# CATPPUCCIN MACCHIATO COLOR PALETTE
colors = {
    "rosewater": "#f4dbd6",
    "flamingo": "#f0c6c6",
    "pink": "#f5bde6",
    "mauve": "#c6a0f6",
    "red": "#ed8796",
    "maroon": "#ee99a0",
    "peach": "#f5a97f",
    "yellow": "#eed49f",
    "green": "#a6da95",
    "teal": "#8bd5ca",
    "sky": "#91d7e3",
    "sapphire": "#7dc4e4",
    "blue": "#8aadf4",
    "lavender": "#b7bdf8",
    "text": "#cad3f5",
    "subtext1": "#b8c0e0",
    "subtext0": "#a5adcb",
    "overlay2": "#939ab7",
    "overlay1": "#8087a2",
    "overlay0": "#6e738d",
    "surface2": "#5b6078",
    "surface1": "#494d64",
    "surface0": "#363a4f",
    "base": "#24273a",
    "mantle": "#1e2030",
    "crust": "#181926",
}

keys = [
    # Pentesting Fast-Keys (Athena/PwnOS inspired)
    Key([mod, "shift"], "p", lazy.spawn("kitty -e nmap"), desc="Launch Nmap in terminal"),
    Key([mod, "shift"], "w", lazy.spawn("wireshark"), desc="Launch Wireshark"),
    Key([mod, "shift"], "b", lazy.spawn("burpsuite"), desc="Launch Burpsuite"),
    Key([mod, "shift"], "a", lazy.spawn("kitty -e aichat"), desc="Launch AI Orchestrator"),
    Key([mod, "shift"], "m", lazy.spawn("kitty -e msfconsole"), desc="Launch Metasploit"),

    # Window Focus
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    # Window Actions
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawn("rofi -show drun"), desc="Spawn a command using rofi"),
]

groups = [Group(i) for i in "123456789"]
for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(), desc="Switch to group {}".format(i.name)),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True), desc="Switch to & move focused window to group {}".format(i.name)),
    ])

layouts = [
    layout.Columns(
        border_focus_stack=[colors["maroon"], colors["red"]],
        border_focus=colors["mauve"],
        border_normal=colors["surface0"],
        border_width=4,
        margin=8
    ),
    layout.Max(),
]

widget_defaults = dict(
    font="FiraCode Nerd Font",
    fontsize=14,
    padding=3,
    foreground=colors["text"],
    background=colors["base"]
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    active=colors["text"],
                    inactive=colors["overlay0"],
                    highlight_method="line",
                    highlight_color=[colors["surface0"], colors["surface1"]],
                    this_current_screen_border=colors["mauve"],
                    this_screen_border=colors["mauve"],
                    other_current_screen_border=colors["surface2"],
                    other_screen_border=colors["surface2"],
                ),
                widget.Prompt(foreground=colors["green"]),
                widget.WindowName(foreground=colors["subtext0"]),
                widget.Chord(
                    chords_colors={"launch": (colors["red"], colors["text"])},
                    name_transform=lambda name: name.upper(),
                ),
                widget.Systray(),
                widget.CPU(format='CPU {load_percent}%', foreground=colors["peach"]),
                widget.Memory(format='RAM {MemUsed: .0f}{mm}', foreground=colors["pink"]),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p", foreground=colors["blue"]),
                widget.QuickExit(default_text='[X]', countdown_format='[{}]', foreground=colors["red"]),
            ],
            28,
            background=colors["base"],
            opacity=0.9,
            margin=[0, 0, 0, 0],
        ),
    ),
]

# Mouse behavior
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
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
    border_focus=colors["red"],
    border_normal=colors["surface0"]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "LG3D"
  '';

  # Declaratively define Kitty configuration
  home.file.".config/kitty/kitty.conf".text = ''
    font_family      FiraCode Nerd Font
    bold_font        auto
    italic_font      auto
    bold_italic_font auto
    font_size 12.0

    # Aesthetic Padding & Animations
    window_padding_width 12
    background_opacity 0.90
    cursor_shape beam
    cursor_blink_interval 0.5

    # Macchiato Theme styling (Catppuccin)
    foreground              #CAD3F5
    background              #24273A
    selection_foreground    #24273A
    selection_background    #F4DBD6

    cursor                  #F4DBD6
    cursor_text_color       #24273A

    url_color               #F4DBD6

    active_border_color     #B7BDF8
    inactive_border_color   #6E738D
    bell_border_color       #EED49F

    wayland_titlebar_color  system
    macos_titlebar_color    system

    active_tab_foreground   #181926
    active_tab_background   #C6A0F6
    inactive_tab_foreground #CAD3F5
    inactive_tab_background #1E2030
    tab_bar_background      #181926

    # Colors for marks
    mark1_foreground #24273A
    mark1_background #B7BDF8
    mark2_foreground #24273A
    mark2_background #C6A0F6
    mark3_foreground #24273A
    mark3_background #7DC4E4

    # Standard Colors
    color0 #494D64
    color8 #5B6078
    color1 #ED8796
    color9 #ED8796
    color2 #A6DA95
    color10 #A6DA95
    color3 #EED49F
    color11 #EED49F
    color4 #8AADF4
    color12 #8AADF4
    color5 #F5BDE6
    color13 #F5BDE6
    color6 #8BD5CA
    color14 #8BD5CA
    color7 #B8C0E0
    color15 #A5ADCB
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
