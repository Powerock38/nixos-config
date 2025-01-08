{ config, pkgs, ... }:

{
  home.username = "powerock";
  home.homeDirectory = "/home/powerock";

  xsession.numlock.enable = true;

  # IMPERMANENCE
  home.persistence."/nix/persist/home/powerock" = {
    directories = [
      "CONFIGURATION"
      "Documents"
      "Downloads"
      "Pictures"
      "Music"
      "Videos"

      # important stuff
      ".gnupg"
      ".ssh"
      ".local/share/keyrings"
      ".local/share/direnv"

      # apps
      # ".local/share/fish"
      ".mozilla/firefox"
      ".cache/mozilla/firefox"
      ".vscode"
      ".config/Code"
      ".config/discord"
      { directory = ".local/share/Steam"; method = "symlink"; }
    ];
    files = [
    ];
    allowOther = true;
  };

  ############
  # PACKAGES #
  ############
  home.packages = with pkgs; [
    (writeShellScriptBin "nixosrebuild" ''
      find ~ -name *.backupHomeManager -delete
      sudo nix-collect-garbage -d
      sudo nixos-rebuild switch --flake ~/CONFIGURATION#default
    '')
    nixpkgs-fmt
    gnomeExtensions.dash-to-panel
    vscode.fhs
    discord
    vlc
    spotify
    rustup
  ];
  programs.firefox.enable = true;
  programs.git = {
    enable = true;
    userName = "Matteo Pappalardo";
    userEmail = "mat.papp@free.fr";
  };
  programs.fish.enable = true;


  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          pkgs.gnomeExtensions.system-monitor.extensionUuid
          pkgs.gnomeExtensions.dash-to-panel.extensionUuid
        ];
        favorite-apps = [
          "org.gnome.Nautilus.desktop"
          "org.gnome.Console.desktop"
          "firefox.desktop"
        ];
        last-selected-power-profile = "performance";
      };

      "org/gnome/desktop/wm/preferences" = {
        num-workspaces = "1";
      };

      "org/gnome/mutter" = {
        edge-tiling = true;
      };
    };
  };


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Environment variables
  home.sessionVariables = { };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
