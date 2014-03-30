neobundle Cookbook
==================
本レシピは次のことを行う
・NeoBundleInstall および .vimrc の配置

Requirements
------------
OS: Linux(Ubuntu)

Attributes
----------
User : 作成対象のユーザ
Group : 作成対象のグループ

Usage
-----
#### neobundle::default

Just include `neobundle` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[neobundle]"
  ],
  "neobundle":{
	  "user" : "<user-name>"
	  "group" : "<group-name>"
  }
}
```


