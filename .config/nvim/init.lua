
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
      keymap('n', '<C-H>', [[<Cmd>lua require('telescope.builtin').help_tags()<cr>]], default)
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

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        --Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', default)
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', default)
        buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', default)
        buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', default)
        buf_set_keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', default)
        buf_set_keymap('n', '<Leader>wa', '<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', default)
        buf_set_keymap('n', '<Leader>wr', '<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', default)
        buf_set_keymap('n', '<Leader>wl', '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', default)
        buf_set_keymap('n', '<Leader>D', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', default)
        buf_set_keymap('n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', default)
        buf_set_keymap('n', '<Leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', default)
        buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', default)
        buf_set_keymap('n', '<Leader>e', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', default)
        buf_set_keymap('n', '[d', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', default)
        buf_set_keymap('n', ']d', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>', default)
        buf_set_keymap('n', '<Leader>q', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', default)
        buf_set_keymap("n", "<Leader>f", "<Cmd>lua vim.lsp.buf.formatting()<CR>", default)
      end

      local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

      for type, icon in pairs(signs) do
        local hl = "LspDiagnosticsSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      function PrintDiagnostics(opts, bufnr, line_nr, client_id)
        opts = opts or {}

        bufnr = bufnr or 0
        line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)

        local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, line_nr, opts, client_id)
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
      cmd [[autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})]]


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
    end

  }

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
      require('nvim-treesitter').setup()
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

        numhl = false,
        linehl = false,

        keymaps = {
          -- Default keymap options
          noremap = true,

          ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
          ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

          ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
          ['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
          ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
          ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
          ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
          ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<cr>',
          ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<cr>',

          -- text objects
          ['o ih'] = ':<c-u>lua require"gitsigns.actions".select_hunk()<cr>',
          ['x ih'] = ':<c-u>lua require"gitsigns.actions".select_hunk()<cr>'

        },

        watch_index = {
          interval = 1000,
          follow_files = true,
        },

        current_line_blame = false,
        current_line_blame_delay = 1000,
        current_line_blame_position = 'eol',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- use default
        word_diff = false,
        use_decoration_api = true,
        use_internal_diff = true,

      }
   end
  }

  ----------------------------------------------------
  -- plugin / lsp-trouble
  ----------------------------------------------------
  use {
    'folke/lsp-trouble.nvim',

    requires = 'kyazdani42/nvim-web-devicons', 
    config = function()
      keymap('n','<Leader>xx', '<Cmd>Trouble<cr>',default)
      keymap('n','<Leader>xw', '<Cmd>Trouble lsp_workspace_diagnostics<cr>',default)
      keymap('n','<Leader>xd', '<Cmd>Trouble lsp_document_diagnostics<cr>',default)
      keymap('n','<Leader>xl', '<Cmd>Trouble loclist<cr>',default)
      keymap('n','<Leader>xq', '<Cmd>Trouble quickfix<cr>',default)
      keymap('n','<Leader>gR', '<Cmd>Trouble lsp_references<cr>',default)
      require('trouble').setup()
    end
  }

  ----------------------------------------------------
  -- plugin / vim-fugitive
  ----------------------------------------------------
  use 'tpope/vim-fugitive'

end)
