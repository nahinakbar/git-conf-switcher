# Git Config Switcher
This command line tool help you switch between many git configs. Mostly switching the name and email addresses.

## Configuration format
The configuration has to be in a JSON format in a file placed in folder $HOME/.config/git-ids
Here is a sample config:
`nahin-web.json`
`{
    "email" : "71415182+nahin-web@users.noreply.github.com",
    "name" : "Nahin AKbar"
}`

## Usage
`--list` Shows available configs
`--switch <config name>` Switch to one of the available configs
`--help` Shows the help text