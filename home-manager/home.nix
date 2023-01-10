{ config, pkgs, lib, inputs, outputs, ... }:

let
  user = "bsvh";
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
    amsmath
    capt-of
    dvipng
    dvisvgm
    hyperref
    mathtools
    physics
    ulem
    wrapfig;
  });
in
{
  imports = [ 
    ../dotfiles
    ../scripts
  ];
  nixpkgs = {
    overlays = [
      inputs.emacs-overlay.overlay
      outputs.overlays.modifications
      outputs.overlays.additions
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  home.sessionVariables = {
    RUSTUP_HOME = "$HOME/.local/sdk/rust/rustup";
    CARGO_HOME = "$HOME/.local/sdk/rust/cargo";
    QT_QPA_PLATFORM = "wayland;xcb";
    NIXOS_OZONE_WL = "1";
    EDITOR = "hx";
    DIRENV_LOG_FORMAT="";
  };
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/desktop";
    documents = "${config.home.homeDirectory}/documents";
    download = "${config.home.homeDirectory}/downloads";
    music = "${config.home.homeDirectory}/music";
    pictures = "${config.home.homeDirectory}/pictures";
    videos = "${config.home.homeDirectory}/videos";
    templates = "${config.home.homeDirectory}/templates";
    publicShare = "${config.home.homeDirectory}/public";
  };
  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };
  home.packages = with pkgs; [
    bacon
    cachix
    fd
    fff
    ffmpeg-full
    fzf
    gcc
    hack-font
    hack-ligatured
    htop
    httm
    iosevka-bin
    just
    mediainfo
    meld
    mitscheme
    pandoc
    ripgrep
    rustup
    rust-analyzer
    sioyek
    tex
    timg
    yubikey-touch-detector
    wezterm
  ];
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    if test "$TERM" != dumb -a \( -z "$INSIDE_EMACS" -o "$INSIDE_EMACS" = vterm \)
        eval (/home/bsvh/.nix-profile/bin/starship init fish)
    end
    enable_transience
    set -e LIBVA_DRIVERS_PATH LIBGL_DRIVERS_PATH LD_LIBRARY_PATH __EGL_VENDOR_LIBRARY_FILENAMES
  '';
  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacsPgtk;
  programs.helix.enable = true;
  programs.helix.package = inputs.helix.packages."x86_64-linux".default;
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Brendan Van Hook";
    userEmail = "brendan@vastactive.com";
    diff-so-fancy.enable = true;
    extraConfig = {
      merge.tool = "meld";
      mergetool.meld = {
        cmd = ''
          meld "$LOCAL" "$BASE" "$REMOTE" --output "$MERGED"
        '';
      };
    };
  };
  programs.neovim = {
    enable = true;
    coc.enable = true;
    coc.settings = {
      "coc.preferences.formatOnSaveFiletypes" = [ "rust" "c" "json" ];
    };
    plugins = with pkgs.vimPlugins; [
      vim-monokai-pro
      vim-tmux-navigator

      # Languages
      coc-clangd
      coc-css
      coc-lua
      coc-json
      coc-html
      coc-pyright
      coc-rust-analyzer
      coc-sh
      coc-toml
      coc-yaml
      vim-nix

      # GUI
      coc-fzf
      fzf-vim
      
      
    ];
    extraPackages = with pkgs; [
      clang
      clang-tools
    ];
    extraConfig = ''
      set relativenumber
      set number
      set splitbelow
      set splitright
      set nowrap
      set signcolumn=yes
      set tabstop=4 shiftwidth=4 softtabstop=4

      """ Colorscheme
      colorscheme monokai_pro
      hi Normal guibg=NONE ctermbg=NONE
      hi LineNr guibg=NONE ctermbg=NONE
      hi SignColumn guibg=NONE ctermbg=NONE
      hi Comment cterm=italic
      hi! link CocInlayHint Comment
      hi! link EndOfBuffer Normal

      set incsearch ignorecase smartcase hlsearch

      map <Space> <Leader>

      " FZF
      nmap <leader><tab> <plug>(fzf-maps-n)
      noremap <silent> <leader>ff :Files<CR>
      noremap <silent> <leader>fb :Buffers<CR>
      noremap <silent> <leader>fp :Files ~/projects<CR>
      noremap <silent> <leader>gf :GFiles<CR>
      noremap <silent> <leader>gs :GFiles?<CR>
      noremap <silent> <leader>gc :Commits<CR>
      noremap <silent> <leader>gb :BCommits<CR>
      noremap <leader>sr :Rg      
      
      " Space unhighlights search
      noremap <silent> <leader><Space> :silent noh<Bar>echo<CR>

      """ Coc
      nmap <silent> gd <Plug>(coc-definition)
      nmap <silent> gy <Plug>(coc-type-definition)
      nmap <silent> gi <Plug>(coc-implementation)
      nmap <silent> gr <Plug>(coc-references)  
      nmap <leader>rn <Plug>(coc-rename)
      xmap <leader>q  <Plug>(coc-format-selected)
      nmap <leader>q  <Plug>(coc-format-selected)
      " Mappings for CoCList
      " Show all diagnostics
      nnoremap <silent><nowait> <leader>ca  :<C-u>CocList diagnostics<cr>
      " Manage extensions
      nnoremap <silent><nowait> <leader>ce  :<C-u>CocList extensions<cr>
      " Show commands
      nnoremap <silent><nowait> <leader>cc  :<C-u>CocList commands<cr>
      " Find symbol of current document
      nnoremap <silent><nowait> <leader>co  :<C-u>CocList outline<cr>
      " Search workspace symbols
      nnoremap <silent><nowait> <leader>ss  :<C-u>CocList -I symbols<cr>
      " Do default action for next item
      nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
      " Do default action for previous item
      nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>

      autocmd CursorHold * silent call CocActionAsync('highlight')
      set statusline^=%{coc#status()}%{get(b:,'coc_current_function',''')}

      inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
      inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
            inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<C-g>u\<TAB>"

      """ Language Specific Formatting
      autocmd FileType xml setlocal tabstop=2 shiftwidth=2
      autocmd FileType xml setlocal tabstop=2 shiftwidth=2
      autocmd FileType c,cpp,h,hpp  setlocal tabstop=8 shiftwidth=8 
    '';
  };
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };
  programs.starship = {
    enable = true;
    # Disabled here b/c need transient prompt needs to be run after starship
    # Enabled manually in fish.interactiveShellInit
    enableFishIntegration = false;
  };
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g mouse on
    '';
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
    ];
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      formulahendry.auto-rename-tag
      formulahendry.auto-close-tag
      kamikillerto.vscode-colorize
      matklad.rust-analyzer
      redhat.vscode-yaml
      ritwickdey.liveserver
      vscodevim.vim
    ];
  };

  xdg.configFile."stop-gnome-ssh" = {
    target = "autostart/gnome-keyring-ssh.desktop";
    text = ''
      [Desktop Entry]
      Type=Application
      Name=SSH Key Agent
      Comment=Prevent gnome-keyring from using ssh
      OnlyShowIn=GNOME;Unity;MATE;
      Hidden=true
    '';
  };

  systemd.user.services."yubikey-touch-detector" = {
    Unit = {
      Description = "Start yubikey-touch-detector";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service= {
      ExecStart = "${pkgs.yubikey-touch-detector}/bin/yubikey-touch-detector -libnotify";
      Type = "simple";
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      font_size = "10.0";
      font_family = "Hack NF FC Ligatured";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      hide_window_decorations = true;
      window_padding_width = "6";
      confirm_os_window_close = "0";
      background = "#222222";
    };
    theme = "Monokai";
  };

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "22.11";
}
