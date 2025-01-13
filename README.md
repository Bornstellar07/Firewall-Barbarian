# Firewall-Barbarian
Just scripts I created to waste less time blocking programs in Windows' firewall.
Mostly working, but in need of further testing.

The scripts are used through an instance of cmd or Powershell launched as administrator. They are easier to use when referenced in the path environment variable.<br/>

- <h3>The "firewallRulesManager.bat" script blocks or unblocks a single program.</h3>
<h4>Parameters:</h4>
1- "block" or "unblock". Must be specified.<br/>
2- program name. Must be in active directory. Must be specified.<br/>
3- "--in" or "--out". For targetting inbound or outbound traffic. If unspecified, both inbound and outbound traffic are targeted.<br/>

- <h3>The "firewallRulesManagerDir.bat" script blocks or unblocks every program ("*.exe") it finds in a directory, subdirectories included.</h3>
<h4>Parameters:</h4>
1- "block" or "unblock". Must be specified.<br/>
2- directory name. Must be in active directory. If unspecified, active directory targeted instead.<br/>
3- "--in" or "--out". For targetting inbound or outbound traffic. If unspecified, both inbound and outbound traffic are targeted.

<h3>Notes/Warnings:</h3>
- The "unblock" will only work on rules created by this tool or using the format "In_%program_path%" for inbound traffic rules and "Out_%program_path% for outbound traffic rules.<br/>
- The "firewallRulesManagerDir.bat" will not work on directories named "--in" or "--out".
