Overview:

simple browser window for the oldfiles command. scrollable and searchable.

📦 Installation (with packer.nvim)
To install this plugin using packer.nvim:
```lua
use({'f5aaff/nvim_oldfiles_browser'})
```
If you're using lazy-loading, you can trigger on command:
```lua
use({
  'f5aaff/nvim_oldfiles_browser',
  cmd = { 'OldfilesBrowser' },
})
```
🚀 Usage

Once installed, run the following command in Neovim to launch the oldfiles browser:
```
:OldfilesBrowser
```
Or map it to a key:
```
vim.keymap.set('n', '<leader>of', '<cmd>OldfilesBrowser<CR>', { desc = 'Open oldfiles browser' })
```
🔧 Features

    🔍 Fuzzy search your recently opened files

    🪟 Clean floating window UI

    🖱️ Navigate with arrow keys or j/k

    📁 Opens files directly from the list

📁 File Structure
```
oldfiles_browser/
├── lua/
│   └── oldfiles_browser/
│       ├── init.lua
│       └── ui.lua
```
