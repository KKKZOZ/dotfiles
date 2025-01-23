return {
  {
  'projekt0n/github-nvim-theme',
  name = 'github-theme',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('github-theme').setup({
      -- ...
    })

    vim.cmd('colorscheme github_light')
  end,
  },

  -- lua function library
  {"nvim-lua/plenary.nvim"},

  -- cmp plugins
  {"hrsh7th/nvim-cmp"},
  {"hrsh7th/cmp-buffer"},
  {"hrsh7th/cmp-path"},
  {"hrsh7th/cmp-cmdline"},
  {"saadparwaiz1/cmp_luasnip"},
  {"hrsh7th/cmp-nvim-lsp"},
  {"hrsh7th/cmp-nvim-lua"},

  -- snippets
  {"L3MON4D3/LuaSnip"},
  {"rafamadriz/friendly-snippets"},

  -- LSP
  {"neovim/nvim-lspconfig"},
  {"williamboman/mason.nvim"},
  {"williamboman/mason-lspconfig.nvim"},
  {"jose-elias-alvarez/null-ls.nvim"},

  -- Telescope
  {"nvim-telescope/telescope.nvim"},
  {"nvim-telescope/telescope-media-files.nvim"}
}
