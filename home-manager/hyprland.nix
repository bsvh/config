{ pkgs, lib, config, default, ... }:

lib.mkIf (config.desktops.hyprland.enable == true) {
  home.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  services = {
    gammastep = {
      enable = true;
      provider = "geoclue2";
    };
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
      }
    ];
    timeouts = [
      {
        timeout = 1200;
        command = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
      }
      {
        timeout = 1210;
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
    ];
  };

  # start swayidle as part of hyprland, not sway
  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];

  programs.swaylock.settings = {
    clock = true;
    font = "Montserrat";  
    ignore-empty-password = true;
    indicator = true;
    image = "~/pictures/wallpaper/wallpaper.jpg";
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = ''
    monitor=eDP-1,preferred,3440x0,1.5
    monitor=DP-4,3440x1440,0x0,1
    monitor=,preferred,auto,1

    wsbind=1,DP-4
    wsbind=2,DP-4
    wsbind=3,DP-4
    wsbind=4,DP-4
    wsbind=5,DP-4
    wsbind=6,DP-4
    wsbind=7,DP-4
    wsbind=8,DP-4
    wsbind=9,DP-4
    wsbind=10,eDP-1

    exec-once = systemctl --user import-environment
    exec-once = waybar & hyprpaper
    exec-once = mako
    exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland


    input {
        kb_layout = us
        follow_mouse = 1
        touchpad {
            natural_scroll = no
        }
        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
    }

    general {
        gaps_in = 5
        gaps_out = 5
        border_size = 2
        col.active_border = rgba(1affffee)
        col.inactive_border = rgba(595959aa)

        layout = dwindle
    }

    decoration {
        rounding = 10
        blur = yes
        blur_size = 3
        blur_passes = 1
        blur_new_optimizations = on

        drop_shadow = yes
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
    }

    animations {
        enabled = yes

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 4, myBezier
        animation = windowsOut, 1, 5, default, popin 80%
        animation = border, 1, 10, default
        animation = fade, 1, 5, default
        animation = workspaces, 1, 3, default
    }

    dwindle {
        pseudotile = yes
        preserve_split = yes
    }

    master {
        new_is_master = true
    }

    gestures {
        workspace_swipe = on
    }


    $mainMod = SUPER

    bind = $mainMod, Return, exec, kitty
    bind = $mainMod SHIFT, C, killactive,
    bind = $mainMod SHIFT, Q, killactive,
    bind = $mainMod SHIFT, E, exit,
    bind = $mainMod, E, exec, dolphin
    bind = $mainMod, V, togglefloating, 
    bind = $mainMod, R, exec, wofi --show drun
    bind = $mainMod, P, pseudo, # dwindle
    bind = $mainMod, S, togglesplit, # dwindle
    bind = $mainMod, G, togglegroup
    bind = $mainMod, N, changegroupactive, f
    bind = $mainMod SHIFT, N, changegroupactive, b

    # Move focus with mainMod + arrow keys
    bind = $mainMod, H, movefocus, l
    bind = $mainMod, L, movefocus, r
    bind = $mainMod, K, movefocus, u
    bind = $mainMod, J, movefocus, d

    bind = $mainMod SHIFT, H, movewindow, l
    bind = $mainMod SHIFT, L, movewindow, r
    bind = $mainMod SHIFT, K, movewindow, u
    bind = $mainMod SHIFT, J, movewindow, d


    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1
    bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow  
  '';

  home.packages = with pkgs; [
    grim
    light
    slurp
    swaylock-effects
    waybar
    wl-clipboard
    wlogout
    wlr-randr
    wofi
  ];
}
