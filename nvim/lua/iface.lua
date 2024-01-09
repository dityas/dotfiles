require("lualine").setup {
    sections = {
        lualine_a = {"mode"},
        lualine_b = {"filename"},
        lualine_c = {},
        lualine_x = {"encoding"},
        lualine_y = {"progress"},
        lualine_z = {"location"}
    },
    tabline = {
        lualine_a = {"buffers"},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    }
}
