module web;

import vibe.d;

public class Web
{
    @path("/")
    public void getIndex()
    {
        render!("index.dt");
    }
}