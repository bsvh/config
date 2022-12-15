-- Currently empty. Exists so nix home-manager can add required
-- environment variable for setting up terminfo

return {
      set_environment_variables = {
        TERMINFO_DIRS = '${config.home.profileDirectory}/share/terminfo',
        WSLENV = 'TERMINFO_DIRS',
      },
}
