📦 Installation (with packer.nvim)

To install this plugin using packer.nvim:
```lua
use({
  'yourusername/themeinator',  -- replace with your GitHub repo
  config = function()
    require('themeinator').setup()
  end
})
```
If you're using lazy-loading, you can trigger on command:
```lua
use({
  'yourusername/themeinator',
  cmd = { 'OldfilesBrowser' },
  config = function()
    require('themeinator').setup()
  end
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

themeinator/
├── lua/
│   └── themeinator/
│       ├── init.lua
│       └── ui.lua

