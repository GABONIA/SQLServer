//// Example of application catching confidential data, using SSNs

public class CatchData
{
 public static string stripSSNs(string search)
 {
  string final = Regex.Replace(search, @"\d{3}[^\d]\d{2}[^\d]\d{4}", "");
  final = Regex.Replace(final, @"\d{9}", "");
  return final;
 }

 public static string preventSSNs(string entry)
 {
  Match formatted_ssn = Regex.Match(entry.ToLower().Trim(), @"\d{3}[^\d]\d{2}[^\d]\d{4}");
  Match straight_ssn = Regex.Match(entry.ToLower().Trim(), @"[^\d]\d{9}[^\d]");

  if (formatted_ssn.Value != "" || straight_ssn.Value != "")
  {
   return "We've detected an SSN.  Please do not enter an SSN.";
  }
  else if (entry.Length == 9 && (Regex.Match(entry.ToLower().Trim(), @"\d{9}").Value != ""))
  {
   return "We've detected an SSN.  Please do not enter an SSN.";
  }
  else
  {
   return entry;
  }
 }
}
