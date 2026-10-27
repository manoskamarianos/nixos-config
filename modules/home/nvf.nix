{ lib, ... }:

let
  inherit (lib.generators) mkLuaInline;

  dashboardButton = key: label: cmd:
    mkLuaInline ''require("alpha.themes.dashboard").button(${builtins.toJSON key}, ${builtins.toJSON label}, ${builtins.toJSON cmd})'';
in
{

  programs.nvf = {
    enable = true;
    defaultEditor = true;

    settings.vim = {
      viAlias = false;
      vimAlias = false;

      # ---- options.lua ----
      lineNumberMode = "relNumber";
      options = {
        expandtab = true;
        shiftwidth = 4;
        tabstop = 4;
        softtabstop = 4;
        smartindent = true;
        fillchars = "eob: ";
      };

      clipboard = {
        enable = true;
        registers = "unnamedplus";
      };

      luaConfigRC.shortmess = ''
        vim.opt.shortmess:append "sI" -- Remove starting message from nvim
      '';

      # nvf requires all 16 colors at build time, and this is what installs
      # base16-nvim. Noctalia's template overrides the palette at runtime, so
      # these values only show if that file is missing.
      theme = {
        enable = true;
        name = "base16";
        base16-colors = {
          base00 = "#2e3440";
          base01 = "#3b4252";
          base02 = "#444c5e";
          base03 = "#727d94";
          base04 = "#d8dee9";
          base05 = "#eceff4";
          base06 = "#eceff4";
          base07 = "#eceff4";
          base08 = "#bf616a";
          base09 = "#5e81ac";
          base0A = "#88c0d0";
          base0B = "#8fbcbb";
          base0C = "#96bbe9";
          base0D = "#96e9e7";
          base0E = "#96d6e9";
          base0F = "#bee8f4";
        };
      };

      # Palette comes from noctalia's nvim-base16 template, which writes a
      # module calling base16-colorscheme.setup(). dofile takes an absolute
      # path, so it does not matter that nvf's runtimepath excludes
      # ~/.config/nvim. Guarded: the file does not exist until the template
      # has been applied once.
      luaConfigRC.noctaliaTheme = lib.hm.dag.entryAfter [ "theme" ] ''
        local ok, theme = pcall(dofile, os.getenv("HOME") .. "/.config/nvim/lua/matugen.lua")
        if ok and type(theme) == "table" and theme.setup then
          -- setup() requires base16-colorscheme, so it needs its own pcall:
          -- an error inside it would otherwise abort init.
          pcall(theme.setup)
        end
      '';

      # base16-nvim gives floating windows the same background as the buffer,
      # so Telescope and friends vanish into the editor. Step them up to
      # base01 and give them a visible border. Colors are read from
      # base16-colorscheme at runtime (it stores them on M.colors in setup),
      # so they follow whatever palette was loaded above.
      luaConfigRC.floats = lib.hm.dag.entryAfter [ "noctaliaTheme" ] ''
        local b16 = require("base16-colorscheme").colors
        if b16 then
          local function hl(group, opts) vim.api.nvim_set_hl(0, group, opts) end
          hl("NormalFloat",            { bg = b16.base01 })
          hl("FloatBorder",            { fg = b16.base03, bg = b16.base01 })
          hl("TelescopeNormal",        { bg = b16.base01 })
          hl("TelescopeBorder",        { fg = b16.base03, bg = b16.base01 })
          hl("TelescopePromptNormal",  { bg = b16.base02 })
          hl("TelescopePromptBorder",  { fg = b16.base03, bg = b16.base02 })
          hl("TelescopePromptTitle",   { fg = b16.base04, bg = b16.base02 })
          hl("TelescopeResultsTitle",  { fg = b16.base04, bg = b16.base01 })
          hl("TelescopePreviewTitle",  { fg = b16.base04, bg = b16.base01 })
        end
      '';

      # ---- keymaps.lua ----
      keymaps =
        [
          { mode = "n"; key = "<C-s>"; action = "<cmd>w<CR>"; desc = "general save file"; }
          { mode = "n"; key = "<C-q>"; action = "<cmd>qall!<CR>"; desc = "quit everything"; }
          { mode = "n"; key = "<C-[>"; action = "vim.lsp.buf.references"; lua = true; desc = "lsp references"; }
          { mode = "n"; key = "<leader>?"; action = ''function() require("which-key").show({ global = false }) end''; lua = true; desc = "Buffer Local Keymaps (which-key)"; }
        ];

      # ---- plugins with first-class nvf modules ----
      telescope = {
        enable = true;
        mappings = {
          findFiles = "<leader>ff";
          liveGrep = "<leader>fg";
          buffers = "<leader>fb";
          helpTags = "<leader>fh";
        };
      };

      filetree.nvimTree = {
        enable = true;
        mappings = {
          toggle = "<C-n>";
          focus = "<leader>e";
          refresh = null;
          findFile = null;
        };
        setupOpts = {
          hijack_cursor = true;
          renderer.icons = {
            git_placement = "right_align";
            modified_placement = "after";
            hidden_placement = "after";
          };
        };
      };

      statusline.lualine = {
        enable = true;
        setupOpts.options.disabled_filetypes = [ "NvimTree" ];
      };

      git = {
        gitsigns.enable = true; # barbar dependency
        neogit = {
          enable = true;
          mappings.open = "<leader>gg";
        };
      };

      terminal.toggleterm = {
        enable = true;
        mappings.open = "<leader>t";
        setupOpts.direction = "horizontal";
      };

      binds.whichKey.enable = true;
      autopairs.nvim-autopairs.enable = true;
      mini.icons.enable = true;
      visuals.nvim-web-devicons.enable = true;

      autocomplete.blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
        setupOpts = {
          keymap.preset = "default";
          appearance = {
            use_nvim_cmp_as_default = true;
            nerd_font_variant = "mono";
          };
          sources.default = [ "lsp" "path" "snippets" "buffer" ];
        };
      };

      dashboard.alpha = {
        enable = false;
        theme = null;
        layout = [
          { type = "padding"; val = 2; }
          {
            type = "text";
            opts = { position = "center"; hl = "Type"; };
            val = [
              "       ███╗░░██╗██╗░░░██╗██╗███╗░░░███╗"
              "       ████╗░██║██║░░░██║██║████╗░████║"
              "       ██╔██╗██║╚██╗░██╔╝██║██╔████╔██║"
              "       ██║╚████║░╚████╔╝░██║██║╚██╔╝██║"
              "       ██║░╚███║░░╚██╔╝░░██║██║░╚═╝░██║"
              "       ╚═╝░░╚══╝░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝"
              ""
              "                 █▀█ █▄░█  █▀▄▀█ █▄█            "
              "                 █▄█ █░▀█  █░▀░█ ░█░            "
              ""
              "       ░██╗░░░░░░░██╗░█████╗░██╗░░░██╗"
              "       ░██║░░██╗░░██║██╔══██╗╚██╗░██╔╝"
              "       ░╚██╗████╗██╔╝███████║░╚████╔╝░"
              "       ░░████╔═████║░██╔══██║░░╚██╔╝░░"
              "       ░░╚██╔╝░╚██╔╝░██║░░██║░░░██║░░░"
              "       ░░░╚═╝░░░╚═╝░░╚═╝░░╚═╝░░░╚═╝░░░"
            ];
          }
          { type = "padding"; val = 2; }
          {
            type = "group";
            opts.spacing = 1;
            val = [
              (dashboardButton "n" "   New file" ":ene <BAR> startinsert <CR>")
              (dashboardButton "f" "   Find file" ":cd $HOME | Telescope find_files hidden=true<CR>")
              (dashboardButton "e" "   File Explorer" ":cd $PWD | NvimTreeFocus<CR>")
              (dashboardButton "r" "   Recent" ":Telescope oldfiles<CR>")
              (dashboardButton "N" "   Notes" ":cd $HOME/notes | :e ~/notes/<CR>")
              (dashboardButton "c" "   Nix Configuration" ":cd $HOME/Projects/nix-config | :e nvf.nix<CR>")
              (dashboardButton "R" "   Ripgrep" ":Telescope live_grep<CR>")
              (dashboardButton "q" "   Quit" ":qa<CR>")
            ];
          }
          {
            type = "text";
            opts = { position = "center"; hl = "Number"; };
            val = mkLuaInline ''
              {
                os.date("%a %d %b"),
                os.date("%H:%M"),
                (function() local v = vim.version() return "v" .. v.major .. "." .. v.minor .. "." .. v.patch end)(),
              }
            '';
          }
        ];
      };

      # ---- LSP / treesitter (replaces mason, mason-lspconfig, lspconfig) ----
      lsp.enable = true;
      treesitter.enable = true;
      languages = {
        enableTreesitter = true;
        nix.enable = true;
        lua.enable = true;
        clang.enable = true;
        elixir.enable = true;
        html.enable = true;
        typescript.enable = true;
        yaml.enable = true;
        tex.enable = true;
        markdown = {
          enable = true;
          extensions.render-markdown-nvim.enable = true;
        };
      };
    };
  };
}
