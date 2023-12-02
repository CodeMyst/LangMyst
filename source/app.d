import std.stdio;
import std.file;
import std.path;
import vibe.d;

import web;
import rest;

void main()
{
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
    serverSettings.bindAddresses = ["0.0.0.0"];
    serverSettings.port = 5000;

    listenHTTP(serverSettings, router);

    runApplication();
}
