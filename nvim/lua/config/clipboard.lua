vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
        ["+"] = "clip.exe",
        ["*"] = "clip.exe",
    },
    paste = {
        -- ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring():gsub("\r", ""))',
        -- ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring():gsub("\r", ""))',
        ["+"] = "powershell.exe -noprofile -command Get-Clipboard",
        ["*"] = "powershell.exe -noprofile -command Get-Clipboard",
    },
    cache_enabled = 0,
}
