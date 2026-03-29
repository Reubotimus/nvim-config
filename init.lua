-- To remember
-- <leader>ss to chat
-- <leader>st to toggle
-- <leader>sn for a new chat
-- <leader>e for neotree toggle
-- <leader>ff for find files
-- <leader>fg to grep directory
-- <leader>fb to find buffer
-- <leader>fh to find help_tags
-- <leader>gl to expand an error
--
local vim = vim
vim.opt.winborder = "rounded"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.signcolumn = "yes"

vim.g.mapleader = " "
vim.keymap.set("v", "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>y", [["+y]])
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set('n', "<leader>lf", vim.lsp.buf.format)
vim.keymap.set('n', '<leader>p', '"+p')
vim.keymap.set('x', '<leader>p', '"+P')

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.shiftround = true
vim.opt.copyindent = true
vim.opt.preserveindent = true

-- Helper for per-buffer indent settings
local function set_indent(bufnr, width, use_tabs)
  local o = vim.bo[bufnr]
  o.expandtab = not use_tabs
  o.tabstop = width
  o.shiftwidth = width
  o.softtabstop = width
end

-- Filetype overrides
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype

    -- Web
    if ft == "html" or ft == "css" or ft == "scss" or ft == "less"
      or ft == "javascript" or ft == "javascriptreact"
      or ft == "typescript" or ft == "typescriptreact" then
      set_indent(args.buf, 2, false)
      return
    end

    -- C#
    if ft == "cs" then
      set_indent(args.buf, 4, false)
      return
    end

    -- Python
    if ft == "python" then
      set_indent(args.buf, 4, false)
      return
    end

    -- OCaml
    if ft == "ocaml" or ft == "ocamlinterface" then
      set_indent(args.buf, 2, false)
      return
    end
  end,
})
vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/NeogitOrg/neogit" },
	{ src = "https://github.com/folke/flash.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" }
})

-- theme
vim.cmd("colorscheme catppuccin")

-- autocomplete
require("blink.cmp").setup({
	keymap = {
		["<Tab>"] = { "accept", "fallback" },
		["<S-Tab>"] = { "select_next", "fallback" },
		["<Esc>"] = { "hide", "fallback" },
	},
	fuzzy = {
		implementation = "lua",
	},
})

-- mason
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"ts_ls",
		"gopls",
		"lua_ls",
		"pyright",
		"omnisharp",
		"html",
		"cssls",
	},
})

-- lsp configs
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})
vim.cmd.packadd("nvim-lspconfig")
vim.lsp.enable({
	"ts_ls",
	"gopls",
	"ocamllsp",
	"lua_ls",
	"pyright",
	"omnisharp",
	"html",
	"cssls",
})
vim.lsp.config("ocamllsp", {
  cmd = { "ocamllsp" }, -- must resolve from opam switch PATH
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})
vim.lsp.enable("ocamllsp")
vim.keymap.set("n", "gl", vim.diagnostic.open_float)

-- telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Definition (Telescope)" })

-- neotree
require("neo-tree").setup({
	filesystem = {
		follow_current_file = { enabled = true },
		hijack_netrw_behavior = "open_default",
	},
})
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Neo-tree: Toggle" })
vim.keymap.set("n", "<leader>o", "<cmd>Neotree focus<cr>", { desc = "Neo-tree: Focus" })

-- flash
vim.keymap.set({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })

vim.keymap.set({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })

vim.keymap.set("o", "r", function()
  require("flash").remote()
end, { desc = "Remote Flash" })

vim.keymap.set({ "o", "x" }, "R", function()
  require("flash").treesitter_search()
end, { desc = "Treesitter Search" })

vim.keymap.set("c", "<C-s>", function()
  require("flash").toggle()
end, { desc = "Toggle Flash Search" })

-- treesitter
require('nvim-treesitter').install({ 'lua', 'vim', 'vimdoc', 'javascript', 'typescript', 'python', 'tsx' })
