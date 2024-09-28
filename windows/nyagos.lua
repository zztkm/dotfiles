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


-- alias 設定
nyagos.alias["cp"] = "copy"
nyagos.alias["gs"] = "git status"
nyagos.alias["nv"] = "nvim"


-- NYAGOS プロンプトに git のブランチ名を表示する
-- refs: <https://outofmem.hatenablog.com/entry/2016/01/27/014352>
nyagos.env.prompt='$L'.. nyagos.getenv('COMPUTERNAME') .. ':$P$G'
share.org_prompter=nyagos.prompt

nyagos.prompt = function(this)
    local prompt_message = this
    -- プロンプトにgit_branch_nameを表示する
    local git_branch_name = nyagos.eval('git rev-parse --abbrev-ref HEAD 2>nul')
    if (git_branch_name ~= '') then
        -- もちろんgit_branch_nameに適当な色をつけたりしてもOK
        prompt_message = prompt_message .. ' [' .. git_branch_name .. ']'
    end

    -- ここで改行をくっつける
    prompt_message = prompt_message .. '$_$$$s'

    return share.org_prompter('$e[36;40;1m'..prompt_message..'$e[37;1m')
end
