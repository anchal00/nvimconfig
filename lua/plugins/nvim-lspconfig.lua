local config = function()
  -- require("neoconf").setup({})
  -- local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local lspconfig = require "lspconfig"

  local diagnostic_signs = { Error = " ", Warn = " ", Hint = "", Info = "" }
  for type, icon in pairs(diagnostic_signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  -- local capabilities = cmp_nvim_lsp.default_capabilities()

  -- lua
  lspconfig.lua_ls.setup {
    -- capabilities = capabilities,
    -- on_attach = on_attach,
    settings = { -- custom settings for lua
      Lua = {
        -- make the language server recognize "vim" global
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          -- make language server aware of runtime files
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.stdpath "config" .. "/lua"] = true,
          },
        },
      },
    },
  }

  local luacheck = require "efmls-configs.linters.luacheck"
  local stylua = require "efmls-configs.formatters.stylua"

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
        -- python = { flake8, black },
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

  -- auto-format on save
  local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = lsp_fmt_group,
    callback = function()
      local efm = vim.lsp.get_clients { name = "efm" }

      if vim.tbl_isempty(efm) then
        return
      end

      vim.lsp.buf.format { name = "efm" }
    end,
  })
end

return {
  "neovim/nvim-lspconfig",
  config = config,
  lazy = false,
  dependencies = {
    "windwp/nvim-autopairs",
    "williamboman/mason.nvim",
    "creativenull/efmls-configs-nvim",
    -- "hrsh7th/nvim-cmp",
    -- "hrsh7th/cmp-buffer",
    -- "hrsh7th/cmp-nvim-lsp",
  },
}
