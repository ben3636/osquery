# Hey there, you've found my stash of MacOS IR tools :)
This is a place where I publish my collection of tools, scripts, and queries that I use in incident response with MacOS endpoints.

These tools are designed to quickly scrape information about the machine and potential infection/persistence vectors

These queries use OSquery by Facebook so you'll need to install that to run these tools: https://osquery.io/downloads/official/5.1.0

Happy Hunting :)

-Ben

## Demo Install & Results
[![MacOS IR Tool - Demo Installation and Results](https://img.youtube.com/vi/SCJtRZV3uUs/0.jpg)](https://youtu.be/SCJtRZV3uUs "MacOS IR Tool - Demo Installation and Results")

## Cargo Manifest

- ir.sh
  - This is the raw script that runs the show, use this is you want to pull it apart and see what makes it tick
- MacOS Incident Response.app.zip
  - This is the app version of the tool, this is just a shiny wrapper for the bash script that will be more friendly for less tech-savvy users

> NOTE: If MacOS reports the app version of this tool as damaged, you'll need to open Terminal and run the following command to bypass GateKeeper. The app is self-signed and contains a shell script so MacOS will (as it should) do all it can to prevent you from clicking on dumb shit :)

> `xattr -cr ~/Downloads/MacOS\ Incident\ Response.app`
