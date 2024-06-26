{ config, lib, inputs, pkgs, ... }:
let
  rice = config.rice;
in
{
  home.packages = [

      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      
      pkgs.wl-screenrec

      pkgs.hyprpicker

      (pkgs.writeShellScriptBin "graceful-logout" ''
      #!/bin/sh
      HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
      hyprctl --batch "$HYPRCMDS" >> /tmp/hypr/hyprexitwithgrace.log 2>&1
      hyprctl dispatch exit
      '')
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # xwayland.enable = true;
    systemd.enable = true;

    plugins = [
      #pkgs.hyprlandPlugins.borders-plus-plus
      #pkgs.hyprlandPlugins.hy3
      
      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      pkgs.hyprlandPlugins.hyprbars
      
      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      pkgs.hyprlandPlugins.hyprexpo
      
      #pkgs.hyprlandPlugins.hyprtrails
      #pkgs.hyprlandPlugins.hyprwinwrap
    ];
  
    settings = {
      
      monitor = [
        ",highres,auto,1"
        # position desktop monitors (when plugged in)
        "HDMI-A-1,2560x1440@60,0x0,1"
        "DP-2,2560x1440@60,2560x0,1"
      ];

      #xwayland = {
        # force_zero_scaling = true;
      #};

      workspace = [
        # left = odd, right = even
        "1, monitor:HDMI-A-1" 
        "2, monitor:DP-2"
        "3, monitor:HDMI-A-1"
        "4, monitor:DP-2"
        "5, monitor:HDMI-A-1"
        "6, monitor:DP-2"
        "7, monitor:HDMI-A-1"
        "8, monitor:DP-2"
        "9, monitor:HDMI-A-1"
        "10, monitor:DP-2"
      ];

      exec-once = [
        "/etc/nixos/dotfiles/hypr/scripts/start.sh"
        "hypridle"
        "nwg-dock-hyprland -d -f -w 20"
      ];

      exec = [
        "/etc/nixos/dotfiles/hypr/scripts/start-waybar.sh"
        # check if laptop is plugged in
        "/etc/nixos/dotfiles/hypr/scripts/external.sh"
        # set the cursor size/theme
        "gsettings set org.gnome.desktop.interface cursor-size $XCURSOR_SIZE"
        "gsettings set org.gnome.desktop.interface cursor-theme $XCURSOR_THEME"
        # TODO: read further on setting this automatically (via configuration.nix ?)
        ". ~/.nix-profile/etc/profile.d/hm-session-vars.sh"
        # start conky
        "kill -9 $(pidof conky); sleep 1; conky"
      ];

      # Set programs that you use
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$browser" = "brave";
      "$menu" = "nwg-drawer";
      #"$menu" = "rofi -show drun -show-icons";

      input = {
        follow_mouse = 1;

        touchpad = {
          natural_scroll = "yes";
        };
        
        accel_profile = "adaptive";
        
        force_no_accel = 0;
        
        kb_layout = "us";
      };

      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          rounding = 10;

          blur = {
              enabled = true;
              size = 3;
              passes = 1;
          };

          drop_shadow = "yes";
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
          enabled = "yes";
          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
      };

      dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = "yes"; # you probably want this
      };

      master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          #new_is_master = true
          #new_status = "inherit";
          no_gaps_when_only = 1;
      };

      gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = "off";
      };

      misc = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
      };


      plugin = {
          
        hyprexpo = {
          columns = 3;
          gap_size = 5;
          bg_col = "rgb(111111)";
          workspace_method = "center current"; # [center/first] [workspace] e.g. first 1 or center m+1

          enable_gesture = "true"; # laptop touchpad
          gesture_fingers = 3;  # 3 or 4
          gesture_distance = 300; # how far is the "max"
          gesture_positive = true; # positive = swipe down. Negative = swipe up.
        };

        hyprbars = {
          bar_height = 28;
          bar_color = "rgb(48, 52, 70)";
          "col.text" = "rgb(c6d0f5)";
          bar_text_size = 11;
          bar_text_font = "Jetbrains Mono Nerd Font Mono Bold";
          bar_button_padding = 12;
          bar_padding = 10;
          bar_part_of_window = true;
          
          #bar_precedence_over_border = true; # flicker problem 
          
          "hyprbars-button" = [
            # color, size, icon, command
            "rgb(e78284), 16, , hyprctl dispatch killactive"
            "rgb(e5c890), 16, , hyprctl dispatch fullscreen 1"
            "rgb(a6d189), 16, , hyprctl dispatch togglefloating"
            #"0, 18, , hyprctl dispatch killactive"
            #"0, 18, , hyprctl dispatch fullscreen 2"
            #"0, 18, , hyprctl dispatch togglefloating"
          ];

        };

      };

      windowrule = [
        "animation popin,^(smile)$" # sets the animation style for kitty"
      ];


      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      windowrulev2 = [
        "suppressevent maximize, class:.*" # You'll probably like this.

        "stayfocused,class:(Rofi)"  # menu
        "forceinput,class:(Rofi)"   #

        "float,class:(smile)"       # 
        "stayfocused,class:(smile)" # emoji picker
        "forceinput,class:(smile)"  #

        # "rounding 10,class:(smile)" # emoji picker
      ];

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      
      "$mainMod" = "SUPER";

      bind = [

        # launcher
        "$mainMod, ESC, exec, nwg-drawer"       

        # emoji picker 🤣
        "$mainMod SHIFT, Equal, exec, smile"

        # color picker
        "$mainMod SHIFT, Minus, exec, hyprpicker -a"
        
        # overview
        "$mainMod, Tab, hyprexpo:expo, toggle"
        # lock screen
        "$mainMod SHIFT, Delete, exec, pidof hyprlock || hyprlock"
        # brightness control
        ",XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more

        "$mainMod, Return, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, W, exec, $browser"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, T, togglefloating,"
        "$mainMod, D, exec, $menu"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod, J, togglesplit," # dwindle

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod SHIFT, PRINT, exec, grim -g \"$(slurp)\" - | swappy -f -"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Example special workspace (scratchpad)
        #bind = $mainMod, S, togglespecialworkspace, magic
        #bind = $mainMod SHIFT, S, movetoworkspace, special:magic


        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        
        # game mode is super fun
        "$mainMod, F1, exec, /etc/nixos/dotfiles/hypr/scripts/gamemode.sh"
        
        # power menu
        "$mainMod SHIFT, Q, exec, rofi -show p -modi p:rofi-power-menu"

        # display key
        "$mainMod, 235, exec, /etc/nixos/dotfiles/hypr/scripts/toggle-display.sh"
      ];

      bindl = [
        ",switch:on:[1a50230],exec,hyprctl keyword monitor \"eDP-1, disable\""
        ",switch:off:[1a50230],exec,hyprctl keyword monitor \"eDP-1, 1920x1080, 0x0, 1\""
      ];

      #  "bindl=,switch:on:[1a50230],exec,hyprctl keyword monitor \"eDP-1, disable\""
      #  "bindl=,switch:off:[1a50230],exec,hyprctl keyword monitor \"eDP-1, 1920x1080, 0x0, 1\""
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel= [
        ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

    };
  };

  home.file = {  
    # the bar
    ".config/waybar" = {
      source = /etc/nixos/dotfiles/waybar;
      recursive = true;
    };

    # gestures
    ".config/libinput-gestures.conf".source = /etc/nixos/dotfiles/libinput-gestures.conf;

    # shell scripts
    ".config/hypr/scripts" = {
      source = /etc/nixos/dotfiles/hypr/scripts;
      recursive = true;
    };

    # lock streen config
    ".config/hypr/hypridle.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || hyprlock       # avoid starting multiple hyprlock instances.
        before_sleep_cmd = loginctl lock-session    # lock before suspend.
        after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
    }

    listener {
        timeout = 150                                # 2.5min.
        on-timeout = brightnessctl -s set 10         # set monitor backlight to minimum, avoid 0 on OLED monitor.
        on-resume = brightnessctl -r                 # monitor backlight restore.
    }

    # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
    listener { 
        timeout = 150                                          # 2.5min.
        on-timeout = brightnessctl -sd rgb:kbd_backlight set 0 # turn off keyboard backlight.
        on-resume = brightnessctl -rd rgb:kbd_backlight        # turn on keyboard backlight.
    }

    listener {
        timeout = 300                                 # 5min
        on-timeout = loginctl lock-session            # lock screen when timeout has passed
    }

    listener {
        timeout = 330                                 # 5.5min
        on-timeout = hyprctl dispatch dpms off        # screen off when timeout has passed
        on-resume = hyprctl dispatch dpms on          # screen on when activity is detected after timeout has fired.
    }

    listener {
        timeout = 1800                                # 30min
        on-timeout = systemctl suspend                # suspend pc
    }
    '';

    ".config/hypr/hyprlock.conf".text = ''
    background {
        path = /etc/nixos/lockscreen.jpg
        blur_passes = 1 
        contrast = 0.8916
        brightness = 0.8172
        vibrancy = 0.1696
        vibrancy_darkness = 0.0
    }

    # GENERAL
    general {
        no_fade_in = false
    }

    input-field {
        size = 300, 42
        outline_thickness = 3
        rounding = 12
        outer_color = rgb(665c54)
        inner_color = rgb(3c3836)
        font_color = rgb(ebdbb2)
        check_color = rgb(d79921)
        fail_color = rgb(cc241d)
        fade_on_empty = false
        placeholder_text =
        fail_text = ☠☠☠☠☠☠☠☠☠☠☠☠☠☠
        font_size = 128 
        font_family = JetBrains Mono Nerd Font Mono bold
    }

    label {
        text = cmd[update:1000]date +"%I:%M %p"
        color = rgb(ebdbb2)
        font_size = 64 
        font_family = JetBrains Mono Nerd Font Mono Semibold
        position = 0, 60
        halign = center
        valign = center
    }
    '';
  };
}
