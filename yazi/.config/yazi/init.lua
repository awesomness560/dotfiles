-- Log navigation in Yazi to the Zoxide database
require("zoxide"):setup({
	update_db = true,
})

-- Apply the custom folder rules plugin
require("folder-rules"):setup()
