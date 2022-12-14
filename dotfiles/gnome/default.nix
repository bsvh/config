
{config, pkgs, lib, ...}:
with lib.hm.gvariant;
let
  desktop = config.desktops.gnome;
in
lib.mkIf (desktop.enable == true) {
  services.gpg-agent.pinentryFlavor = "gnome3";
  home.packages = with pkgs.gnomeExtensions; [
    adjust-display-brightness
    appindicator
    dash-to-dock
    #gsconnect
    improved-workspace-indicator
    just-perfection
    night-theme-switcher
    pop-shell
    rounded-window-corners
    pkgs.adw-gtk3
  ];

  gtk.theme = {
    name = "adw-gtk3";
    package = pkgs.adw-gtk3;
  };

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      per-window = false;
      sources = [ (mkTuple [ "xkb" "us" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ] ++ (
        if desktop.swapEscape then [ "caps:swapescape" ] else []
      );
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      text-scaling-factor = 1.0;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 900;
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Shift><Super>c" "<Alt>F4" ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      switch-applications = [];
      switch-applications-backward = [];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      toggle-maximized = [ "<Shift><Super>m" ];
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = false;
      dynamic-workspaces = false;
      edge-tiling = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ "<Shift><Super>h" ];
      toggle-tiled-right = [ "<Shift><Super>l" ];
    };


    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      control-center = [ "AudioMedia" ];
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "${desktop.terminalCommand}";
      name = "Open Terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Shift><Super>t";
      command = "env LIGHT_TERMINAL_THEME=1 ${desktop.terminalCommandLight}";
      name = "Open Terminal (Light Colorscheme)";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-timeout = 2700;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [ 
        "appindicatorsupport@rgcjonas.gmail.com"
        "dash-to-dock@micxgx.gmail.com"
        "gsconnect@andyholmes.github.io"
        "gnome-extension-brightness@bruno.englert.gitlab.com"
        "improved-workspace-indicator@michaelaquilina.github.io"
        "nightthemeswitcher@romainvigier.fr"
        "pop-shell@system76.com"
        "rounded-window-corners@yilozt"
        "just-perfection-desktop@just-perfection"
      ];
      welcome-dialog-last-shown-version = "43.2";
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = true;
      background-opacity = 0.8;
      custom-theme-shrink = false;
      dash-max-icon-size = 32;
      disable-overview-on-startup = true;
      dock-position = "BOTTOM";
      height-fraction = 0.9;
      hot-keys = false;
      intellihide-mode = "ALL_WINDOWS";
      middle-click-action = "launch";
      multi-monitor = true;
      preferred-monitor = -2;
      preferred-monitor-by-connector = "eDP-1";
      preview-size-scale = 0.0;
      shift-click-action = "minimize";
      shift-middle-click-action = "launch";
      show-mounts = false;
      show-trash = false;
    };

    "org/gnome/shell/extensions/improved-workspace-indicator" = {
      panel-position = "left";
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
      activities-button=false;
      app-menu = false;
      app-menu-label = true;
      panel-button-padding-size = 5;
      panel-indicator-padding-size = 5;
      ripple-box = false;
      show-apps-button = true;
      workspace-popup = false;
    };

    "org/gnome/shell/extensions/nightthemeswitcher/time" = {
      nightthemeswitcher-ondemand-keybinding = [ "" ];
    };

    "org/gnome/shell/extensions/pop-shell" = {
      active-hint = true;
      active-hint-border-radius = mkUint32 15;
      gap-outer = mkUint32 1;
      gap-inner = mkUint32 1;
      tile-by-default = true;
      smart-gaps = false; # Buggy with active hints.
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
    };

    "org/gnome/software" = {
      first-run = false;
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };
  };
}
