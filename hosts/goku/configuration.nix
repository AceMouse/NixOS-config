{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/disko/btrfs.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "goku"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  nixpkgs.config.allowUnfree = true;

  # Firmware Updater
  services.fwupd.enable = true;

  # Thermal Management
  services.thermald.enable = true;

  # inotify
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = "524288";
    "fs.inotify.max_user_instances" = "524288";
  };

  # Increase amount of files we can have open
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "16384";
    }
  ];

  #console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "dk";
  #  useXkbConfig = true; # use xkb.options in tty.
  #};

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Display Manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users.asmus = {
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    imports = [
      ./home.nix
      inputs.hyprland.homeManagerModules.default
    ];

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.05";
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.asmus = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "1234";
  };

  # SSH
  programs.ssh.startAgent = true; # gpg-agent emulates ssh-agent. So we can use both SSH and GPG keys.

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      tumbler
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-volman
    ];
  };
  programs.xfconf.enable = true;
  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    ffmpegthumbnailer

    zip
    unzip
    btop
    spice-vdagent
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Nix Settings
  nix.settings = {
    auto-optimise-store = true;
    builders-use-substitutes = true;
    substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    experimental-features = "nix-command flakes";
  };

  # Configure Disko VM
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;
  virtualisation.vmVariantWithDisko = {
    virtualisation = {
      cores = 8;
      memorySize = 8096;
      #qemu.options = [
      #  "-enable-kvm"
      #  "-device"
      #  "virtio-gpu-gl"
      #  "-display"
      #  "spice-app,gl=on"
      #  "-vga"
      #  "none"
      #  "-cpu"
      #  "host"
      #  "-mem-prealloc"
      #  "-spice"
      #  "unix=on,ipv4=off,ipv6=off,disable-ticketing=on"
      #];
      qemu.options = [
        "-enable-kvm"
        "-vga virtio"
        "-display gtk"
      ];
      writableStoreUseTmpfs = false;

      fileSystems."/var/log".neededForBoot = true;
      fileSystems."/swap".neededForBoot = true;
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
