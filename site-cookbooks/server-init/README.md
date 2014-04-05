server-init Cookbook
==================
本レシピは次のことを行う
 ・ローカルユーザ、ローカルグループの作成

Requirements
------------
OS: Linux(Ubuntu)

Attributes
----------
User : 作成対象のユーザ
Group : 作成対象のグループ

Usage
-----
#### server-init::default

Just include `server-init` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[server-init]"
  ],
  "server-init":{
	  "user" : "<user-name>"
	  "group" : "<group-name>"
  }
}
```


