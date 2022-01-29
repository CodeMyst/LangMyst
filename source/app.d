import std.stdio;
import std.file;
import std.path;
import vibe.d;

import web;
import rest;

const string CONFIG_PATH = "config.json";

void main()
{
    if (!exists(CONFIG_PATH))
    {
        writeln("ERROR: Missing config.json");
        return;
    }

    Json config = parseJsonString(readText(CONFIG_PATH));

    auto router = new URLRouter();

    // redirect api requests with a trailing slash
    router.any("/*", (HTTPServerRequest req, HTTPServerResponse res) {
		import std.algorithm : startsWith;
		if (req.requestURI.startsWith("/api/") && req.requestURI[$-1] == '/')
		{
			res.redirect(req.requestURI[0..$-1], 307);
		}
	});

    router.registerWebInterface(new Web());
    router.registerRestInterface(new Rest());

    auto fsettings = new HTTPFileServerSettings();
    fsettings.serverPathPrefix = "/static";

    router.get("/static/*", serveStaticFiles("static/", fsettings));

    auto serverSettings = new HTTPServerSettings();
    serverSettings.bindAddresses = ["127.0.0.1"];
    serverSettings.port = config["port"].get!ushort();

    listenHTTP(serverSettings, router);

    runApplication();
}
