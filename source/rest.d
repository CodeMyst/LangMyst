module rest;

import vibe.d;

import detect;

private struct DetectRequest
{
    public string[] snippets;
}

private struct DetectResponse
{
    public string[] languages;
}

@path("/api/")
public interface IRest
{
    DetectResponse getDetect(@viaBody() DetectRequest request) @safe;
}

public class Rest : IRest
{
    public DetectResponse getDetect(DetectRequest request)
    {
        enforceHTTP(request.snippets.length > 0, HTTPStatus.badRequest, "At least one snippet must be provided.");

        string[] langs;

        foreach (snippet; request.snippets)
        {
            langs ~= detectSnippet(snippet);
        }

        return DetectResponse(langs);
    }
}
