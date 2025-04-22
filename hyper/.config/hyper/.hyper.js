module.exports = {
  config: {
    // hyper version
    updateChannel: "stable",
    // default font size in pixels for all tabs
    fontSize: 15,
    // font family with optional fallbacks
    fontFamily: "FiraCode Nerd Font",
    // default font weight: 'normal' or 'bold'
    fontWeight: "normal",
    // font weight for bold characters: 'normal' or 'bold'
    fontWeightBold: 700,
    // line height as a relative unit
    lineHeight: 1,
    // letter spacing as a relative unit
    letterSpacing: 0,
    // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
    cursorColor: "rgba(248,28,229,0.8)",
    // terminal opacity
    opacity: 0.8,
    // terminal text color under BLOCK cursor
    cursorAccentColor: "#fffaaa",
    // `'BEAM'` for |, `'UNDERLINE'` for _, `'BLOCK'` for █
    cursorShape: "BLOCK",
    // set to `true` (without backticks and without quotes) for blinking cursor
    cursorBlink: false,
    // color of the text
    foregroundColor: "#fff",
    // border color (window, tabs)
    borderColor: "none",
    // custom CSS to embed in the main window
    css: "",
    // custom CSS to embed in the terminal window
    termCSS: "",
    // set custom startup directory (must be an absolute path)
    workingDirectory: "~/Developer",
    // if you're using a Linux setup which show native menus, set to false
    // default: `true` on Linux, `true` on Windows, ignored on macOS
    showHamburgerMenu: false,
    // set to `false` (without backticks and without quotes) if you want to hide the minimize, maximize and close buttons
    // additionally, set to `'left'` if you want them on the left, like in Ubuntu
    // default: `true` (without backticks and without quotes) on Windows and Linux, ignored on macOS
    showWindowControls: false,
    // custom padding (CSS format, i.e.: `top right bottom left`)
    padding: "0px 0px 0px 5px",
    // the full list. if you're going to provide the full color palette,
    // including the 6 x 6 color cubes and the grayscale map, just provide
    // an array here instead of a color map object
    colors: {
      black: "#282828",
      red: "#cc241d",
      green: "#98971a",
      yellow: "#d79921",
      blue: "#458588",
      magenta: "#b16286",
      cyan: "#689d6a",
      white: "#a89984",
      lightBlack: "#928374",
      lightRed: "#fb4934",
      lightGreen: "#b8bb26",
      lightYellow: "#fabd2f",
      lightBlue: "#83a598",
      lightMagenta: "#d3869b",
      lightCyan: "#8ec07c",
      lightWhite: "#ebdbb2",
      limeGreen: "#32CD32",
      lightCoral: "#F08080",
    },
    // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
    // - Example: `C:\\cygwin64\\bin\\bash.exe`
    shell: "/bin/zsh",
    // for setting shell arguments (i.e. for using interactive shellArgs: `['-i']`)
    // by default `['--login']` will be used
    shellArgs: ["--login"],
    // for environment variables
    env: {},
    // Supported Options:
    //  1. 'SOUND' -> Enables the bell as a sound
    //  2. false: turns off the bell
    bell: false,
    // An absolute file path to a sound file on the machine.
    // bellSoundURL: '/path/to/sound/file',
    // if `true` (without backticks and without quotes), selected text will automatically be copied to the clipboard
    copyOnSelect: true,
    // if `true` (without backticks and without quotes), hyper will be set as the default protocol client for SSH
    defaultSSHApp: true,
    // if `true` (without backticks and without quotes), on right click selected text will be copied or pasted if no
    // selection is present (`true` by default on Windows and disables the context menu feature)
    quickEdit: false,
    // choose either `'vertical'`, if you want the column mode when Option key is hold during selection (Default)
    // or `'force'`, if you want to force selection regardless of whether the terminal is in mouse events mode
    // (inside tmux or vim with mouse mode enabled for example).
    macOptionSelectionMode: "vertical",
    // Whether to use the WebGL renderer. Set it to false to use canvas-based
    // rendering (slower, but supports transparent backgrounds)
    webGLRenderer: false,
    // keypress required for weblink activation: [ctrl|alt|meta|shift]
    // todo: does not pick up config changes automatically, need to restart terminal :/
    webLinksActivationKey: "",
    // if `false` (without backticks and without quotes), Hyper will use ligatures provided by some fonts
    disableLigatures: false,
    // set to true to disable auto updates
    disableAutoUpdates: false,
    // hyper border radius 0
    borderRadius: "0px",
    // for advanced config flags please refer to https://hyper.is/#cfg
    hyperBorder: {
      borderColors: ["#fc1da7", "#fba506"],
      borderWidth: "3px",
    },
    overlay: {
      alwaysOnTop: true,
      animate: true,
      hasShadow: false,
      hideDock: false,
      hideOnBlur: false,
      hotkeys: ["Option+Space"],
      position: "top",
      primaryDisplay: false,
      resizable: true,
      startAlone: false,
      startup: false,
      size: 0.4,
      tray: true,
      unique: false,
    },
  },
  plugins: [
    "hyper-one-dark",
    "hyper-opacity",
    "hyperborder",
    "hyperlinks",
    "hyperterm-overlay",
  ],
  // in development, you can create a directory under
  // `~/.hyper_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: [],
  keymaps: {
    // Example
    // 'window:devtools': 'cmd+alt+o',
  },
};
//# sourceMappingURL=config-default.js.map
