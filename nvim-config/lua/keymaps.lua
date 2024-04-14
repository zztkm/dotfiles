local telebuiltin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', telebuiltin.find_files, {})
vim.keymap.set('n', '<leader>fg', telebuiltin.live_grep, {})
vim.keymap.set('n', '<leader>fb', telebuiltin.buffers, {})
vim.keymap.set('n', '<leader>fh', telebuiltin.help_tags, {})

