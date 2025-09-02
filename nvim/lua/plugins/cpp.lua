return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "cpp" } },
	},
	{
		"p00f/clangd_extensions.nvim",
		lazy = true,
		opts = {
			inlay_hints = { inline = false },
			ast = {
				role_icons = {
					type = "",
					declaration = "",
					expression = "",
					specifier = "",
					statement = "",
					["template argument"] = "",
				},
				kind_icons = {
					Compound = "",
					Recovery = "",
					TranslationUnit = "",
					PackExpansion = "",
					TemplateTypeParm = "",
					TemplateTemplateParm = "",
					TemplateParamObject = "",
				},
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		-- Setup clangd directly here for lspconfig plugin to use on startup
		config = function()
			local lspconfig = require("lspconfig")
			local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")

			lspconfig.clangd.setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, {
				filetypes = { "c", "cpp", "cxx", "cc" },
				keys = {
					{ "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
				},
				root_dir = function(fname)
					return require("lspconfig.util").root_pattern(
						"Makefile",
						"configure.ac",
						"configure.in",
						"config.h.in",
						"meson.build",
						"meson_options.txt",
						"build.ninja",
						".git"
					)(fname)
				end,
				capabilities = {
					offsetEncoding = { "utf-16" },
				},
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				init_options = {
					usePlaceholders = true,
					completeUnimported = true,
					clangdFileStatus = true,
				},
			}))
		end,
	},
}
