module detect;

import std.process;
import std.file;
import std.path;
import std.uuid;
import std.array;
import std.string;
import std.stdio : writeln;

public string detectSnippet(string snippet) @safe
{
    string name;

    do
    {
        name = randomUUID().toString();
    } while (exists(chainPath(tempDir(), name)));

    write(chainPath(tempDir(), name), snippet);

    auto cmd = execute(["guesslang", chainPath(tempDir(), name).array()]);
    string res = "Unknown";

    if (cmd.status != 0)
    {
        throw new Exception("Failed detecting the language.");
    }

    if (cmd.output.length < "Programming language: ".length + 1)
    {
        throw new Exception("Unexpected output from running the detection command");
    }

    res = cmd.output["Programming language: ".length..$].strip();

    remove(chainPath(tempDir(), name));

    return res;
}