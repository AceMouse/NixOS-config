{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  home = {
    username = "asmus";
    homeDirectory = "/home/asmus";
  };

  home.packages = with pkgs; [
    vesktop # Third-party Discord

    # Clipboard utilities
    # Needed to make Vim use global clipboard
    wl-clipboard

    # Screenshot
    swappy
    grim
    slurp

    # Backlight control
    light

    pavucontrol # Audio control gui
    feh # Image Viewer
    mpv # Media Player

    material-design-icons # Icons
  ];

  programs = {
    git = {
      enable = true;
      userName = "AceMouse";
      userEmail = "62022703+AceMouse@users.noreply.github.com";
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };

    firefox.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };

    # Terminal Emulator
    foot.enable = true;
    foot.settings = {
      main = {
        font = "monospace:size=11";
        dpi-aware = "yes";
      };
      colors = {
        alpha = 0.9;

        # Kanagawa Dragon
        foreground = "c5c9c5";
        background = "181616";

        selection-foreground = "C8C093";
        selection-background = "2D4F67";

        regular0 = "0d0c0c";
        regular1 = "c4746e";
        regular2 = "8a9a7b";
        regular3 = "c4b28a";
        regular4 = "8ba4b0";
        regular5 = "a292a3";
        regular6 = "8ea4a2";
        regular7 = "C8C093";

        bright0 = "a6a69c";
        bright1 = "E46876";
        bright2 = "87a987";
        bright3 = "E6C384";
        bright4 = "7FB4CA";
        bright5 = "938AA9";
        bright6 = "7AA89F";
        bright7 = "c5c9c5";

        "16" = "b6927b";
        "17" = "b98d7b";
      };
    };
  };

  # GPG & Password Store
  programs.password-store.enable = true;
  programs.gpg.enable = true;
  services.pass-secret-service.enable = true;
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry-gtk2;
    extraConfig = ''
      allow-preset-passphrase
    '';
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.dracula-theme;
      name = "Dracula";
    };
    iconTheme = {
      package = pkgs.dracula-icon-theme;
      name = "Dracula";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  # Idle Daemon
  services.hypridle.enable = true;
  services.hypridle.settings = {
    general = {
      after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
    };

    listener = [
      {
        timeout = 300;
        on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
      }
      {
        timeout = 360;
        on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
  };

  # Lock Screen
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 5;
        hide_cursor = false;
        no_fade_in = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 2;
          blur_size = 2;
        }
      ];

      label = {
        monitor = "";
        text = "           へ            ╱|<br/>૮  -   ՛ )  ♡   (`   -  7.  <br/>/   ⁻  ៸|         |、⁻〵<br/>乀 (ˍ, ل ل         じしˍ,)ノ";
        text_align = "center";
        color = "rgba(243, 241, 141, 1.0)";
        font_size = 12;
        font_family = "Noto Sans";
        rotate = 0; # degrees, counter-clockwise

        position = "0, 80";
        halign = "center";
        valign = "center";
      };

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 2;
          placeholder_text = "Password...";
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    extraConfig = ''
      monitor=,preferred,auto,1

      input {
        kb_layout = dk,us
        kb_options = grp:alt_caps_toggle
        repeat_rate = 25
        repeat_delay = 200

        sensitivity = -0.3
        accel_profile = flat
      }

      cursor {
        no_warps = true
      }

      misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        enable_anr_dialog = false
      }

      general {
        border_size = 1
        gaps_in = 0
        gaps_out = 0

        col.active_border = rgb(606060)
        col.inactive_border = rgb(0f0f0f)

        layout = dwindle
      }

      windowrulev2 = noborder, onworkspace:w[t1]
      windowrulev2 = noanim, onworkspace:w[t1]
      windowrulev2 = noborder, fullscreen:1

      decoration {
        rounding = 0
        shadow {
          enabled = false
        }
        blur {
          enabled = true
          size = 4
          passes = 2
        }
      }

      ecosystem {
        no_update_news = true
        no_donation_nag = true
      }

      # Animations
      animations {
        enabled = true
      }
      animation=workspaces,1,1,default
      animation=windows,1,1,default,slide
      animation = fade, 0

      # Bindings
      $mainMod = SUPER

      bind = $mainMod SHIFT, Q, killactive
      bind = $mainMod, F, fullscreen
      bind = $mainMod, M, fullscreen, 1
      bind = $mainMod, D, exec, rofi -show drun
      bind = $mainMod, Return, exec, foot
      bind = $mainMod, V, togglefloating
      bind = $mainMod, B, exec, firefox

      bind = $mainMod SHIFT, S, exec, grim -g "$(slurp)" - | swappy -f -

      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # Move active window with arrow keys
      bind = $mainMod SHIFT, left, movewindow, l
      bind = $mainMod SHIFT, right, movewindow, r
      bind = $mainMod SHIFT, up, movewindow, u
      bind = $mainMod SHIFT, down, movewindow, d

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      # Volume button that allows press and hold, volume limited to 100%
      binde = , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
      binde = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

      # Brightness button that allows press and hold
      binde = , XF86MonBrightnessUp, exec, ${pkgs.light}/bin/light -A 5
      binde = , XF86MonBrightnessDown, exec, ${pkgs.light}/bin/light -U 5

      # Switch workspaces with mainMod + [0-9]
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

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
      bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
      bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
      bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
      bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
      bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
      bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
      bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
      bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
      bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10

      # Layer Rule
      layerrule = blur,gtk-layer-shell
    '';
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    extraConfig = {
      modi = "drun,run,filebrowser,window";
      show-icons = true;
      display-drun = "APPS";
      display-run = "RUN";
      display-filebrowser = "FILES";
      display-window = "WINDOW";
      drun-display-format = "{name}";
      window-format = "{w} · {c} · {t}";
    };
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          font = "JetBrains Mono Nerd Font 10";
          background = mkLiteral "#180F39";
          background-alt = mkLiteral "#32197D";
          foreground = mkLiteral "#FFFFFF";
          selected = mkLiteral "#FF00F1";
          active = mkLiteral "#9878FF";
          urgent = mkLiteral "#7D0075";
        };

        window = {
          transparency = "real";
          location = mkLiteral "center";
          anchor = mkLiteral "center";
          fullscreen = false;
          width = mkLiteral "1000px";
          x-offset = mkLiteral "0px";
          y-offset = mkLiteral "0px";
          enabled = true;
          border-radius = mkLiteral "15px";
          cursor = "default";
          background-color = mkLiteral "@background";
        };

        mainbox = {
          enabled = true;
          spacing = mkLiteral "0px";
          background-color = mkLiteral "transparent";
          orientation = mkLiteral "horizontal";
          children = [
            "imagebox"
            "listbox"
          ];
        };

        imagebox = {
          padding = mkLiteral "20px";
          background-color = mkLiteral "transparent";
          #background-image = mkLiteral ("url(" + "\"${../../dotfiles/assets/rofi.png}\"" + ", height)");
          orientation = mkLiteral "vertical";
          children = [
            "inputbar"
            "dummy"
            "mode-switcher"
          ];
        };

        listbox = {
          spacing = mkLiteral "20px";
          padding = mkLiteral "20px";
          background-color = mkLiteral "transparent";
          orientation = mkLiteral "vertical";
          children = [
            "message"
            "listview"
          ];
        };

        dummy = {
          background-color = mkLiteral "transparent";
        };

        inputbar = {
          enabled = true;
          spacing = mkLiteral "10px";
          padding = mkLiteral "15px";
          border-radius = mkLiteral "10px";
          background-color = mkLiteral "@background-alt";
          text-color = mkLiteral "@foreground";
          children = [
            "textbox-prompt-colon"
            "entry"
          ];
        };

        textbox-prompt-colon = {
          enabled = true;
          expand = false;
          str = "";
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        entry = {
          enabled = true;
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
          cursor = mkLiteral "text";
          placeholder = "Search";
          placeholder-color = mkLiteral "inherit";
        };

        mode-switcher = {
          enabled = true;
          spacing = mkLiteral "20px";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@foreground";
        };

        button = {
          padding = mkLiteral "15px";
          border-radius = mkLiteral "10px";
          background-color = mkLiteral "@background-alt";
          text-color = mkLiteral "inherit";
          cursor = mkLiteral "pointer";
        };

        "button selected" = {
          background-color = mkLiteral "@selected";
          text-color = mkLiteral "@foreground";
        };

        listview = {
          enabled = true;
          columns = 1;
          lines = 8;
          cycle = true;
          dynamic = true;
          scrollbar = false;
          layout = mkLiteral "vertical";
          reverse = false;
          fixed-height = true;
          fixed-columns = true;
          spacing = mkLiteral "10px";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@foreground";
          cursor = "default";
        };

        element = {
          enabled = true;
          spacing = mkLiteral "15px";
          padding = mkLiteral "8px";
          border-radius = mkLiteral "10px";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@foreground";
          cursor = mkLiteral "pointer";
        };
        "element normal.normal" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };
        "element normal.urgent" = {
          background-color = mkLiteral "@urgent";
          text-color = mkLiteral "@foreground";
        };
        "element normal.active" = {
          background-color = mkLiteral "@active";
          text-color = mkLiteral "@foreground";
        };
        "element selected.normal" = {
          background-color = mkLiteral "@selected";
          text-color = mkLiteral "@foreground";
        };
        "element selected.urgent" = {
          background-color = mkLiteral "@urgent";
          text-color = mkLiteral "@foreground";
        };
        "element selected.active" = {
          background-color = mkLiteral "@urgent";
          text-color = mkLiteral "@foreground";
        };
        element-icon = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
          size = mkLiteral "32px";
          cursor = mkLiteral "inherit";
        };
        element-text = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
          cursor = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };

        message = {
          background-color = mkLiteral "transparent";
        };

        textbox = {
          padding = mkLiteral "15px";
          border-radius = mkLiteral "10px";
          background-color = mkLiteral "@background-alt";
          text-color = mkLiteral "@foreground";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };

        error-message = {
          padding = mkLiteral "15px";
          border-radius = mkLiteral "20px";
          background-color = mkLiteral "@background";
          text-color = mkLiteral "@foreground";
        };
      };
  };

  # Hide Desktop Entries
  xdg.desktopEntries = {
    "thunar-bulk-rename" = {
      name = "Bulk Rename";
      noDisplay = true;
    };
    "thunar-settings" = {
      name = "File Manager Settings";
      noDisplay = true;
    };
    "thunar-volman-settings" = {
      name = "Removable Drives and Media";
      noDisplay = true;
    };
  };
}
