local present, al = pcall(require, "aerial")

if not present then
	return
end

al.setup({
	backends = { "treesitter", "lsp", "markdown" },
	layout = {
		min_width = 50,
		placement = "edge",
        default_direction = "prefer_right",
	},
	-- close_behavior = "auto",
	attach_mode = "global",
	-- close_on_select = true,
	show_guides = true,
})

-- require("telescope").setup({
-- 	extensions = {
-- 		aerial = {
-- 			default_selection_index = 1,
-- 			-- Display symbols as <root>.<parent>.<symbol>
-- 			show_nesting = {
-- 				["_"] = false, -- This key will be the default
-- 				json = true, -- You can set the option for specific filetypes
-- 				yaml = true,
-- 			},
-- 		},
-- 	},
-- })
