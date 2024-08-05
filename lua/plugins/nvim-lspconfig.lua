local on_attach = require("util.lsp").on_attach
local diagnostic_signs = require("util.lsp").diagnostic_signs

local config = function()
  require("neoconf").setup {}
  local lspconfig = require "lspconfig"
  local cmp_nvim_lsp = require "cmp_nvim_lsp"

  for type, icon in pairs(diagnostic_signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  local capabilities = cmp_nvim_lsp.default_capabilities()

  -- lua
  lspconfig.lua_ls.setup {
    -- capabilities = capabilities,
    on_attach = on_attach,
    settings = { -- custom settings for lua
      Lua = {
        -- make the language server recognize "vim" global
        diagnostics = {
          globals = { "vim" },
        },
        -- workspace = {
        --   -- make language server aware of runtime files
        --   library = {
        --     vim.fn.expand "$VIMRUNTIME/lua",
        --     vim.fn.stdpath("config") .. "/lua"),
        --   },
        -- },
        workspace = {
          library = {
            vim.fn.expand "$VIMRUNTIME/lua",
            vim.fn.expand "$XDG_CONFIG_HOME" .. "/nvim/lua",
          },
        },
      },
    },
  }

  -- python
  lspconfig.pyright.setup {
    -- capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      pyright = {
        disableOrganizeImports = false,
        analysis = {
          useLibraryCodeForTypes = true,
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          autoImportCompletions = true,
        },
      },
    },
  }

  local luacheck = require "efmls-configs.linters.luacheck"
  local stylua = require "efmls-configs.formatters.stylua"

  local black = require "efmls-configs.formatters.black"
  local mypy = require "efmls-configs.linters.mypy"
  local flake8 = require "efmls-configs.linters.flake8"
  -- configure efm server
  lspconfig.efm.setup {
    filetypes = {
      "lua",
      "python",
      -- "json",
      -- "jsonc",
      -- "sh",
      -- "javascript",
      -- "javascriptreact",
      -- "typescript",
      -- "typescriptreact",
      -- "svelte",
      -- "vue",
      -- "markdown",
      -- "docker",
      -- "solidity",
    },
    init_options = {
      documentFormatting = true,
      documentRangeFormatting = true,
      hover = true,
      documentSymbol = true,
      codeAction = true,
      completion = true,
    },
    settings = {
      languages = {
        lua = { luacheck, stylua },
        python = { flake8, black, mypy },
        -- typescript = { eslint_d, prettierd },
        -- json = { eslint_d, fixjson },
        -- jsonc = { eslint_d, fixjson },
        -- sh = { shellcheck, shfmt },
        -- javascript = { eslint_d, prettierd },
        -- javascriptreact = { eslint_d, prettierd },
        -- typescriptreact = { eslint_d, prettierd },
        -- svelte = { eslint_d, prettierd },
        -- vue = { eslint_d, prettierd },
        -- markdown = { alex, prettierd },
        -- docker = { hadolint, prettierd },
        -- solidity = { solhint },
      },
    },
  }
end

return {
  "neovim/nvim-lspconfig",
  config = config,
  lazy = false,
  dependencies = {
    "windwp/nvim-autopairs",
    "williamboman/mason.nvim",
    "creativenull/efmls-configs-nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
  },
}
