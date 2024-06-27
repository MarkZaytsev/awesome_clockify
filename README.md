<div align="center">
    <h1>Awesome Clockify</h1>
</div>

A plugin for AwesomeWM to display [Clockify](https://clockify.me) timer and to toggle it with a shortcut.

## Contents ##
1. [Installation](#installation)
2. [Clockify API Token](#clockify_token)
3. [Setup](#setup)
4. [Controller](#controller)
5. [Widget](#widget)
6. [Debug](#debug)
7. [TODO](#todo)

<a name="installation"></a>
## Installation ##

Clone this repository to your `~/.config/awesome` directory 
```
git -C ~/.config/awesome/ clone git@github.com:MarkZaytsev/awesome_clockify.git --depth 1 
```
or clone to another directory and simply create a link
```
cd your_directory
git clone git@github.com:MarkZaytsev/awesome_clockify.git --depth 1 
ln -s your_directory/awesome_clockify ~/.config/awesome/
```
You might need also install `luarocks`, because the plugin is using `ssl.https` package in order to work with clockify WebAPI via https.
### Ubuntu
```
sudo apt install luarocks
```
### Fedora
```
sudo dnf install luarocks
```
Or a similar command on other distros.
<a name="clockify_token"></a>
## Clockify API Token ##
Go to https://app.clockify.me/user/preferences#advanced and generate an API key.

If you want to use non-default workspace, go to https://app.clockify.me/workspaces, click on preferred workspace and copy its id from address line.
It will look something like `https://app.clockify.me/workspaces/65e67dd7d123487fcbabe2/settings` where `65e67dd7d123487fcbabe2` is workspace id. Plugin will auto-detect your default workspace if none provided.

<a name="setup"></a>
## Setup ##
Edit your `rc.lua` file:
```lua
local ClockifyClient = require("awesome_clockify.src.clockify_client")
local ClockifyController = require("awesome_clockify.src.controller")
local clockify_widget = require("awesome_clockify.src.widget")

...

local clockify_controller = ClockifyController:new{
    clockify_client = ClockifyClient:new {
        api_key = "your_clockify_api_key",
        -- optional
        workspace_id = "your_workspase_id",
        -- optional
        user_id = "your_user_id"
    }
}

...

s.mytasklist, -- Middle widget
	{ -- Right widgets
    	layout = wibox.layout.fixed.horizontal,
        ...
        clockify_widget{
            controller = clockify_controller
        },
```
More on optional parameters for ClockifyClient in [Debug](#debug)

Shortcut:
```lua
awful.key({ modkey, "Shift", "Control" }, "g", function() clockify_controller:toggle_timer() end,
	{description = "Clockify Toggle", group = "Time tracking"}),
```

Then reload awesomewm.
<a name="controller"></a>
## Controller ##
Parapmetes:
| Name | Default | Description |
|---|---|---|
| `api_key` | nil | Your API key for Clockify service |
| `workspace_id` | nil | Workspace id for retrieving and adding new entries. Optional, see [Debug](#debug) |
| `user_id` | nil | Your user id in given workspace. Optional, see [Debug](#debug) |
| `is_active_time_display_required` | false | If `true` then only active entry time displayed while timer is running. Otherwise total today time displayed including active timer. |
<a name="widget"></a>
## Widget ##
Widget parapmetes:
| Name | Default | Description |
|---|---|---|
| `controller` | nil | Instance of ClockifyController. Mandatory. |
| `width` | `110` | Width of the widged. Optional. |

You don't have to use widget if you want just to work with web API. For example you can create a controller and use it to toggle timer via shortcut. Or you can use `rest_client.lua` or `clockify_client.lua` for you own widget or logic.
<a name="debug"></a>
## Debug ##
Project has various test scripts in debug directory. They are designed to execute as stand-alone scripts. Execute them from parent directory of `awesome_clockify` repo. Otherwise lua will fail to find submodules. By executing tests you can test your API key and see what responses you get from web API.
To start testing, paste you API key in `debug/credentials.lua` in `api_key` field. Then run `get_user.lua`.

```lua
cd ~/.config/awesome
lua awesome_clockify/debug/tests/get_user.lua
```
You will get `id` (your user id) and `default_workspace_id`. Paste them to `debug/credentials.lua` as well.
You can also use them in `rc.lua` as parameters for `ClockifyClient`. Otherwise client will call this API on initalization every time you reload awesomewm. Not a big deal really.
You can execute other tests in the same way.
<a name="todo"></a>
## TODO ##
- Optionally display entry text, project or tags
- Notification if timer is not running for 5 min.
- Option to pause this feature in runtime. By click on clock?
- Option to close the widget? By click?
- Show last entry when timer stopped instead of today's total?
- Async calls to API?
- Icons?
- Check with interval that timer is started/stopped outside of the plugin. Sync if needed. WebHook is not an option
