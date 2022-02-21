require('utils')
require('settings')
require('maps')
require('plugins')
require('theme')
require('telescope')
require('nvim-tree')
require('nvim-lspconfig')
require('nvim-compe')
require('nvim-lsp-installer')
require('treesitter')
require('gitsigns')
----------------------------------------------------
-- Readme
----------------------------------------------------
-- Welcome to my humble neovim config.
--
-- The config has the following dependencies
-- 1. Packer: https://github.com/wbthomason/packer.nvim
-- 2. Language Servers: https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md

----------------------------------------------------
-- Utilities
----------------------------------------------------
o = vim.o
g = vim.g
wo = vim.wo
cmd = vim.cmd
default = { noremap = true, silent = true }

function keymap(mode, lhs, rhs, opts)
  if opts == default then
    return vim.api.nvim_set_keymap(mode, lhs, rhs, default)
else
    return vim.api.nvim_set_keymap(mode, lhs, rhs, opts) 
  end
end

function buf_keymap(mode,lhs, rhs, opts)
  if opts == default then
    return vim.api.buf_set_keymap(mode, lhs, rhs, default)
else
    return vim.api.buf_set_keymap(mode, lhs, rhs, opts)
  end
end

----------------------------------------------------
-- Maps
----------------------------------------------------
g.mapleader = ' '
keymap('i', 'jj', '<Esc>', default)
keymap('n', '<C-J>', '<C-W><C-J>', default)
keymap('n', '<C-K>', '<C-W><C-K>', default)
keymap('n', '<C-L>', '<C-W><C-L>', default)
keymap('n', '<C-H>', '<C-W><C-H>', default)

----------------------------------------------------
-- Sets
----------------------------------------------------
o.number = true
o.relativenumber = true
o.shiftwidth = 2
o.tabstop = 2
o.expandtab = true
o.smartindent = true
o.showmatch = true
o.incsearch = true
o.ignorecase = true
wo.wrap = false

----------------------------------------------------
-- Plugins
----------------------------------------------------
return require('packer').startup(function(use)

  ----------------------------------------------------
  -- plugin / packer
  ----------------------------------------------------
  use 'wbthomason/packer.nvim'

  ----------------------------------------------------
  -- plugin / tokyonight
  ----------------------------------------------------
  use { 
    'folke/tokyonight.nvim',

    config = function()
      g.tokyonight_style = "night"
      g.tokyonight_italic_functions = true
      g.tokyonight_sidebars = { "qf", "vista_kind", "terminal",}
      cmd[[colorscheme tokyonight]]
    end

  }

  use 'kyazdani42/nvim-web-devicons'

  ----------------------------------------------------
  -- plugin / telescope
  ----------------------------------------------------
  use {
    'nvim-telescope/telescope.nvim',

    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'}
    },

    config = function()
      keymap('n', '<C-P>', [[<Cmd>lua require('telescope.builtin').find_files()<cr>]], default)
      keymap('n', '<C-F>', [[<Cmd>lua require('telescope.builtin').live_grep()<cr>]], default)
      keymap('n', '<C-B>', [[<Cmd>lua require('telescope.builtin').buffers()<cr>]], default)
      --keymap('n', '<C-H>', [[<Cmd>lua require('telescope.builtin').help_tags()<cr>]], default)
      local actions = require('telescope.actions')

      require('telescope').setup{
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },

        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case'
        },

        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",

        layout_config = {
          horizontal = {
            mirror = false,
          },
          vertical = {
            mirror = false,
          },
        },

        file_sorter =  require'telescope.sorters'.get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
        winblend = 0,
        border = {},
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons = true,
        use_less = true,
        path_display = {},
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
      }
    end

  }

  ----------------------------------------------------
  -- plugin / lspconfig
  ----------------------------------------------------
  use {
    'neovim/nvim-lspconfig',

    config = function()
      local nvim_lsp = require('lspconfig')

      keymap('n', '<Leader>e', '<Cmd>lua vim.diagnostic.open_float()<CR>', default)
      keymap('n', '[d', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', default)
      keymap('n', ']d', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>', default)
      keymap('n', '<Leader>q', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', default)

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        
        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', default)
        buf_keymap(bufnr,'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', default)
        buf_keymap(bufnr,'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', default)
        buf_keymap(bufnr,'n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', default)
        buf_keymap(bufnr,'n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', default)
        buf_keymap(bufnr,'n', '<Leader>wa', '<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', default)
        buf_keymap(bufnr,'n', '<Leader>wr', '<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', default)
        buf_keymap(bufnr,'n', '<Leader>wl', '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', default)
        buf_keymap(bufnr,'n', '<Leader>D', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', default)
        buf_keymap(bufnr,'n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', default)
        buf_keymap(bufnr,'n', '<Leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', default)
        buf_keymap(bufnr,'n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', default)
        buf_keymap(bufnr,"n", "<Leader>f", "<Cmd>lua vim.lsp.buf.formatting()<CR>", default)
      end

      vim.diagnostic.config({
        virtual_text = false
      })

      local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      function PrintDiagnostics(opts, bufnr, line_nr, client_id)
        bufnr = bufnr or 0
        line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
        opts = opts or {['lnum'] = line_nr}

        local line_diagnostics = vim.diagnostic.get(bufnr, opts)
        if vim.tbl_isempty(line_diagnostics) then return end

        local diagnostic_message = ""
        for i, diagnostic in ipairs(line_diagnostics) do
          diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
          print(diagnostic_message)
          if i ~= #line_diagnostics then
            diagnostic_message = diagnostic_message .. "\n"
          end
        end
        vim.api.nvim_echo({{diagnostic_message, "Normal"}}, false, {})
      end

      vim.cmd [[ autocmd CursorHold * lua PrintDiagnostics() ]]

      -- You will likely want to reduce updatetime which affects CursorHold
      -- note: this setting is global and should be set only once
      o.updatetime = 100
      vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

      local servers = { "tsserver" }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
          on_attach = on_attach,
          flags = {
            debounce_text_changes = 150,
          }
        }
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      require'lspconfig'.html.setup {
        capabilities = capabilities,
      }

      require'lspconfig'.cssls.setup {
        capabilities = capabilities,
      }

      require'lspconfig'.tsserver.setup{}
      require'lspconfig'.jsonls.setup{}
      require'lspconfig'.yamlls.setup{}
      require'lspconfig'.dartls.setup{}
    end

  }

  ----------------------------------------------------
  -- plugin / lsp-installer
  ----------------------------------------------------
  use {
    'williamboman/nvim-lsp-installer'
  }

  config = function()
    local lsp_installer = require('nvim-lsp-installer')
    lsp_installer.on_server_ready(function(server)
      local opts = {}
      server:setup(opts)
    end)
  end

  ----------------------------------------------------
  -- plugin / compe
  ----------------------------------------------------
  use { 
    'hrsh7th/nvim-compe',

    config = function()
      o.completeopt = "menuone,noselect"

      require('compe').setup {
        enabled = true;
        autocomplete = true;
        debug = false;
        min_length = 1;
        preselect = 'enable';
        throttle_time = 80;
        source_timeout = 200;
        resolve_timeout = 800;
        incomplete_delay = 400;
        max_abbr_width = 100;
        max_kind_width = 100;
        max_menu_width = 100;

        documentation = {
          border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
          winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
          max_width = 120,
          min_width = 60,
          max_height = math.floor(vim.o.lines * 0.3),
          min_height = 1,
        };

        source = {
          path = true;
          buffer = true;
          calc = true;
          nvim_lsp = true;
          nvim_lua = true;
          vsnip = true;
          ultisnips = true;
          luasnip = true;
        };
      }

      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      local check_back_space = function()
          local col = vim.fn.col('.') - 1
          return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      end
      -- Use (s-)tab to:
      --- move to prev/next item in completion menuone
      --- jump to prev/next snippet's placeholder
      _G.tab_complete = function()
        if vim.fn.pumvisible() == 1 then
          return t "<C-n>"
        elseif vim.fn['vsnip#available'](1) == 1 then
          return t "<Plug>(vsnip-expand-or-jump)"
        elseif check_back_space() then
          return t "<Tab>"
        else
          return vim.fn['compe#complete']()
        end
      end

      _G.s_tab_complete = function()
        if vim.fn.pumvisible() == 1 then
          return t "<C-p>"
        elseif vim.fn['vsnip#jumpable'](-1) == 1 then
          return t "<Plug>(vsnip-jump-prev)"
        else
          -- If <S-Tab> is not working in your terminal, change it to <C-h>
          return t "<S-Tab>"
        end
      end

      keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
      keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
      keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
      keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
    end

  }

  ----------------------------------------------------
  -- plugin / nvim-treesitter
  ----------------------------------------------------
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',

    config = function()
      require('nvim-treesitter').setup {
        ensure_installed = "maintained",
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      }
    end

  }

  ----------------------------------------------------
  -- plugin / lualine
  ----------------------------------------------------
  use {
    'hoob3rt/lualine.nvim',

    requires = {
      'kyazdani42/nvim-web-devicons',
      opt = true
    },

    config = function()
      require('lualine').setup {
        options = {
          theme = 'tokyonight'
        } 
      }
    end

  }

  ----------------------------------------------------
  -- plugin / gitsigns
  ----------------------------------------------------
  use {
    'lewis6991/gitsigns.nvim',

    requires = {
      'nvim-lua/plenary.nvim'
    },

    config = function()
      require('gitsigns').setup {
        signs = {
          add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
          change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
          delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
          topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
          changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        },
        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          interval = 1000,
          follow_files = true
        },
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter_opts = {
          relative_time = false
        },
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000,
        preview_config = {
          -- Options passed to nvim_open_win
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
        yadm = {
          enable = false
        },
      }
    end
  }

  ----------------------------------------------------
  -- plugin / vim-fugitive
  ----------------------------------------------------
  use 'tpope/vim-fugitive'
  
  ----------------------------------------------------
  -- plugin / nvim-tree
  ----------------------------------------------------
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = function() 
      require'nvim-tree'.setup {
        keymap("n", "<Leader>e", ":NvimTreeToggle<cr>", default)
      } 
    end
  }
end)
