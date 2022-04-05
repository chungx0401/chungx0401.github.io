---
title: "「經驗の潭」 Reflog﹕Git Reset Hard 的急救法！"
date:  "2022-04-05T00:00:00+00:00"
categories:
  - blog
tags:
  - git
  - 經驗の潭
---
## 前言 ##

前些天裏，在工作完成後，筆者在使用git時不小心hard reset了，丟失了commit，最後用git-reflog花了好一番功夫才把commit恢復，特以此文記錄解決方法和分享相關經驗。

## 背景 ##
在使用git時，筆者透過```git push```將commit上傳後遇到了以下錯誤。

```bash
$ git push origin master
To [SOME_GIT_URL_HERE]
 ! [rejected]        master -> master (non-fast-forward)
error: failed to push some refs to [SOME_GIT_URL_HERE]
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

意思是指local branch不夠update，因此無法push。 

正常情況下，使用```git pull```把local branch更新，再```git push```就可以解決問題了，但是由於筆者已經在local branch commit過了，這樣做會多創建了一個merge request，因此當時的想法是先把commit復原，再進行操作。

做法如下﹕
1. 先把commit復原
2. 使用```git stash save```把changes暫存
3. 使用```git pull```把local branch更新
4. 使用```git stash pop```把changes取出
5. 使用```git commit```
6. 使用```git push```


在Google大神的幫助下，筆者找到了把commit復原的方法，就是使用```git reset```。

> 正確做法﹕
```bash
$ git reset --soft HEAD~1
```

但是筆者當時錯誤運行了另一句命令。

> 錯誤做法﹕
```bash
$ git reset --hard HEAD~1
```

運行過後，commit、changes和新建的檔案都不見了，筆者才發現出事。

## 解決方法 ##

出了事後，筆者立即向Google大神求救，最終找到了逃生門﹕git-reflog。

### Git Reflog ###
Reflog的全寫是Reference Log。跟據官方文件，在每次進行git相關的操作時，每一個stage都會被記錄，默認保留30日。

### 實際操作 ###
1. 使用```git reflog```查看所有git的記錄
   ```bash
   $ git reflog
   b7057a9 HEAD@{0}: reset: moving to b7057a9
   98abc5a HEAD@{1}: commit: more stuff added to foo
   b7057a9 HEAD@{2}: commit (initial): initial commit
   ```
2. 找到你想要回復的commit，並記錄它的SHA-1。
   > 假設你想回復
   ```bash
   98abc5a HEAD@{1}: commit: more stuff added to foo
   ```
3. 使用```git reset```回復commit
   ```bash
   $ git reset --hard 98abc5a
   ```


## 後記 ##
這次的困境，全因筆者的不小心所導致。當發現文件不見了的一瞬間，筆者真是當場崩潰，差點懷疑人生。所幸調整心態後，能找到正確的解決方法，不然又要重做。經過這次事件，筆者深深明白到**Backup**的重要性，以後在做相關操作時要特別注意！

## 參考 ##
1. [Git-Reflog官方文件][1]
2. [恢复 git reset -hard 的误操作][2]

---
[1]: https://git-scm.com/docs/git-reflog
[2]: https://www.cnblogs.com/mliudong/archive/2013/04/08/3007303.html
---