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

-- git command hook
nyagos.complete_for.git = function(args)
    while #args > 2 and args[2]:sub(1,1) == "-" do
        table.remove(args,2)
    end
    if #args == 2 then
        return nyagos.fields([[
          add                 fsck-objects        rebase
          add--interactive    gc                  receive-pack
          am                  get-tar-commit-id   reflog
          annotate            grep                relink
          apply               gui                 remote
          archimport          gui--askpass        remote-ext
          archive             gui--askyesno       remote-fd
          bisect              gui.tcl             remote-ftp
          bisect--helper      hash-object         remote-ftps
          blame               help                remote-http
          branch              http-backend        remote-https
          bundle              http-fetch          repack
          cat-file            http-push           replace
          check-attr          imap-send           request-pull
          check-ignore        index-pack          rerere
          check-mailmap       init                reset
          check-ref-format    init-db             rev-list
          checkout            instaweb            rev-parse
          checkout-index      interpret-trailers  revert
          cherry              log                 rm
          cherry-pick         ls-files            send-email
          citool              ls-remote           send-pack
          clean               ls-tree             sh-i18n--envsubst
          clone               mailinfo            shortlog
          column              mailsplit           show
          commit              merge               show-branch
          commit-tree         merge-base          show-index
          config              merge-file          show-ref
          count-objects       merge-index         stage
          credential          merge-octopus       stash
          credential-manager  merge-one-file      status
          credential-store    merge-ours          stripspace
          credential-wincred  merge-recursive     submodule
          cvsexportcommit     merge-resolve       submodule--helper
          cvsimport           merge-subtree       subtree
          cvsserver           merge-tree          svn
          daemon              mergetool           symbolic-ref
          describe            mktag               tag
          diff                mktree              unpack-file
          diff-files          mv                  unpack-objects
          diff-index          name-rev            update-index
          diff-tree           notes               update-ref
          difftool            p4                  update-server-info
          difftool--helper    pack-objects        upload-archive
          fast-export         pack-redundant      upload-pack
          fast-import         pack-refs           var
          fetch               patch-id            verify-commit
          fetch-pack          prune               verify-pack
          filter-branch       prune-packed        verify-tag
          fmt-merge-msg       pull                web--browse
          for-each-ref        push                whatchanged
          format-patch        quiltimport         worktree
          fsck                read-tree           write-tree	switch]])
    end
    if args[#args]:sub(1,1) == "-" then
        if args[2] == "commit" then
            return { "--amend" , "-a" , "--cleanup","--dry-run" }
        end
    end
    return nil
end

-- gpg-agent を起動する
nyagos.rawexec{"gpgconf", "--launch", "gpg-agent"}

