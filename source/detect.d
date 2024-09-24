module detect;

import std.process;
import std.file;
import std.path;
import std.uuid;
import std.array;
import std.string;

public string detectSnippet(string snippet) @safe
{
    string name;

    do
    {
        name = randomUUID().toString();
    } while (exists(chainPath(tempDir(), name)));

    write(chainPath(tempDir(), name), snippet);

    auto cmd = execute(["guesslang-bun", chainPath(tempDir(), name).array()]);
    string res = "Unknown";

    if (cmd.status != 0)
    {
        throw new Exception("Failed detecting the language.");
    }

    res = cmd.output.strip();

    remove(chainPath(tempDir(), name));

    return res;
}
