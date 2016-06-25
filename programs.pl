#!/usr/bin/perl
  
  # index.pl
  use CGI;
  use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
  use CGI::Session ( '-ip_match' );
  use DBI;
  require "xpl/config.pl";
  
  $session = CGI::Session->load();
  $q = new CGI;
  
  $cook = $q->param('cook');
  
  $db_name = 'DBI:mysql:' . $config{MysqlDB};
  $dbh = DBI->connect($db_name, $config{MysqlUser}, $config{MysqlPass}) || die "Could not connect to database: $DBI::errstr";
  $sth = $dbh->prepare( "SELECT * FROM affiliates WHERE cook = ?" );
  $sth->execute( $cook );
  $sth->bind_columns( \$id, \$name, \$password, \$affid, \$email, \$cook );
  $sth->fetch();
  
  
  if($session->is_expired)
  {
    print $q->header(-cache_control=>"no-cache, no-store, must-revalidate");
    print "Your has session expired. Please login again.";
	print "<br/><a href='login.pl>Login</a>";
  }
  elsif($session->is_empty)
  {
    #print $q->header(-cache_control=>"no-cache, no-store, must-revalidate");
    print "Status: 301 Moved\nLocation: login.pl\n\n";
  }
  else
  {
    print $q->header(-cache_control=>"no-cache, no-store, must-revalidate");
	indexalltab();
  }
  
  
sub indexalltab
{
 print <<THEHTMLINDEX;
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml" lang="fr"><HEAD><META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<TITLE>$config{NetName} - User Information</TITLE>
    <LINK rel="stylesheet" type="text/css" href="style/style3.css" media="all">
    
</HEAD><BODY>

<DIV id="top_nav">
	<DIV class="content">
    
        <UL>
            <LI><A href="index.pl?cook=$cook" title="Home" class="Home">Home</A></LI>
            <LI><A href="tools.pl?cook=$cook" title="tools">Tools</A></LI>
            <LI><A href="stats.pl?cook=$cook" title="Report">Report</A></LI>
            <LI><A href="programs.pl?cook=$cook" title="Account">Account</A></LI>
            <LI><A href="help.pl?cook=$cook" title="Support">Support</A></LI>
            <LI><A href="#" title=""></A></LI>
            <LI><A href="login.pl?action=logout" title="Log Out">Log Out</A></LI>
        </UL>
        
    </DIV>
</DIV>
<center>

<br><br><br>
<b>
<h2>[ Account Summary ]</h2>
<br>

<DIV id="main">
<DIV class="content">
<DIV id="pages">
<DIV id="home">
<DIV>
</DIV>
<br><br>
<h3>Contact Information</h3><br>
<font color=black>Username:</font> $name <br>
<font color=black>AffID:</font> $affid <br>
<font color=black>Email:</font> $email <br><br>

<br><br>
</DIV>
</DIV>
</DIV>
</DIV>


<br>
if you have questions or program request, contact us at <a href="mailto:$config{NetEmail}"> $config{NetEmail}</a>
<br><br>
</center>

<DIV id="footer">
	<DIV class="content">
        <DIV class="copyright">
        	<P><BR>
        </DIV>        
    </DIV>
</DIV>

</body>
</html>
 
 
THEHTMLINDEX
}
