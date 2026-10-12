{ config, lib, ... }:

let
  inherit (lib.generators) mkLuaInline;

  c = config.lib.stylix.colors.withHashtag;

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

      # base16-nvim gives floating windows the same background as the buffer,
      # so Telescope and friends vanish into the editor. Step them up to
      # base01 and give them a visible border.
      luaConfigRC.floats = ''
        local function hl(group, opts) vim.api.nvim_set_hl(0, group, opts) end
        hl("NormalFloat",            { bg = "${c.base01}" })
        hl("FloatBorder",            { fg = "${c.base03}", bg = "${c.base01}" })
        hl("TelescopeNormal",        { bg = "${c.base01}" })
        hl("TelescopeBorder",        { fg = "${c.base03}", bg = "${c.base01}" })
        hl("TelescopePromptNormal",  { bg = "${c.base02}" })
        hl("TelescopePromptBorder",  { fg = "${c.base03}", bg = "${c.base02}" })
        hl("TelescopePromptTitle",   { fg = "${c.base04}", bg = "${c.base02}" })
        hl("TelescopeResultsTitle",  { fg = "${c.base04}", bg = "${c.base01}" })
        hl("TelescopePreviewTitle",  { fg = "${c.base04}", bg = "${c.base01}" })
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
