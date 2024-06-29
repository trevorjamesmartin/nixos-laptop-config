# theme.nix
{ pkgs, ...}:
let
  # edit catppuccin here
  catppuccin_flavor = "frappe";
  catppuccin_accent = "blue";
  catppuccin_kvantum_theme = "Catppuccin-Frappe-Blue";
  
  # todo: check how we build these names
  catppuccin_name = "catppuccin-${catppuccin_flavor}-${catppuccin_accent}-standard+default";
  catppuccin_cursor_name = "catppuccin-${catppuccin_flavor}-${catppuccin_accent}-cursors";
in
{
  home.packages = with pkgs; [
    catppuccin
    catppuccin-gtk
    catppuccin-qt5ct
    catppuccin-cursors
    tmuxPlugins.catppuccin
  ];

  # general settings
  catppuccin = {
    enable = true;
    flavor = "${catppuccin_flavor}";
    accent = "${catppuccin_accent}";
  };

  programs.tmux = {
    catppuccin.enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    sensibleOnTop = true;
    # This should either be screen-256color or tmux-256color where it exists
    terminal = "tmux-256color";

    extraConfig = ''
      set -g status on
      set -g mouse on

      # Where this shows 'alacritty' - the value should be whatever $TERM is outside tmux
      set-option -ga terminal-overrides ",alacritty:Tc"

      # Catppuccin options
      set -g @catppuccin_host 'on'
      set -g @catppuccin_window_tabs_enabled 'on'
    '';
  };

  # gtk settings
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-${catppuccin_flavor}-${catppuccin_accent}-standard+default";
      package = pkgs.catppuccin-gtk;
    };
 
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme=1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme=1;
    };
    
    iconTheme = {
      name = "Papirus-Dark";
    }; 
  };

  # qt settings
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      package = pkgs.catppuccin-kvantum;
      name = "kvantum";
    };
  };

  # Generate kvantum 
  xdg.configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
    General.theme = catppuccin_kvantum_theme;
  };

  # link (missing?) gtk4 files
  home.file.".config/gtk-4.0/gtk-dark.css".source = "${pkgs.catppuccin-gtk}/share/themes/${catppuccin_name}/gtk-4.0/gtk-dark.css";
  #home.file.".config/gtk-4.0/assets" = {
  #  recursive = true;
  #  source = "${pkgs.catppuccin-gtk}/share/themes/${catppuccin_name}/gtk-4.0/assets";
  #};
  home.sessionVariables = {
    # I'm setting these environment variables for hyprcursor to use
    XCURSOR_THEME = "catppuccin-${catppuccin_flavor}-${catppuccin_accent}-cursors";
    XCURSOR_SIZE  = 64;
    HYPRCURSOR_THEME = "catppuccin-${catppuccin_flavor}-${catppuccin_accent}-cursors";
    #HYPRCURSOR_SIZE = 64;
    
    # pretty 
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
  };

}
