public static class StringLibrary
{
    public static string SubToMain(string j)
    {
        string p = j.Substring((j.IndexOf("[") + 1), (j.IndexOf("]") - (j.IndexOf("[") + 1)));
        return p;
    }
}
