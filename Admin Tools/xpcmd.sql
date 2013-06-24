-- Enable xp_cmdshell (very useful with a new install)

sp_configure 'show advanced options', 1
RECONFIGURE

sp_configure 'xp_cmdshell',1
RECONFIGURE
