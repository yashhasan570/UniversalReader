local _ = require("gettext")
return {
    fullname = _("HTTP Universal Reader Inspector"),
    description = _([[Allow browsing Universal Reader internal objects over HTTP. This is aimed at developers, and may pose some security risks. Only enable this on networks you can trust.]]),
}
