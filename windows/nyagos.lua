-- NYAGOS の設定を反映するときは、このファイルを %USERPROFILE%\.nyagos にコピーして利用する

-- 参考: https://qiita.com/JugnautOnishi/items/f55058c2f6669a18076a
function chomp(src)
    return string.gsub(src, "[\r\n]+$", "")
end

-- ghq で管理しているリポジトリを peco で選択して cd する
function pecoli()
    local dir = nyagos.eval("ghq list -p | peco")
    if (dir ~= nil) then
        nyagos.exec("cd " .. '"' .. chomp(dir) .. '"')
    end
end

-- pecoli へのキーバインドを設定
nyagos.bindkey("C-]", function(this) pecoli() end)
