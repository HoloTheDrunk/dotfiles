return {
  plugins = {
    {
      "catppuccin/nvim",
      as = "catppuccin",
      config = function()
        require("catppuccin").setup {}
      end,
      lazy = false,
    },
    {
      "sainnhe/sonokai",
      init = function() -- init function runs before the plugin is loaded
        vim.g.sonokai_style = "shusia"
      end,
    },
    {
      "diepm/vim-rest-console",
      lazy = false,
    },
    {
      "andweeb/presence.nvim",
      lazy = false,
    },
    {
      "pest-parser/pest.vim",
      lazy = false,
    }
  },
  mappings = {
    n = {
      L = {
        function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
        desc = "Next buffer"
      },
      H = {
        function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
        desc = "Previous buffer"
      },
    }
  },
  lsp = {
    config = {
      clangd = {
        capabilities = { offsetEncoding = "utf-8" }
      }
    }
  },
}
