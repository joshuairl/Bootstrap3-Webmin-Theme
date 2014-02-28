sub theme_header {
	print '<!DOCTYPE HTML>' , "\n";
	print '<html>' , "\n";
	print '<head>' , "\n";
	print '<title>' , $_[0] , '</title>' , "\n";
	print '<meta charset="utf-8">' , "\n";
	print '<meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no">' . "\n";
	print '<link href="/assets/css/webmin.css" rel="stylesheet" type="text/css">' , "\n";
	print '<script src="/assets/js/webmin.js" type="text/javascript"></script>' , "\n";
	print '</head>' , "\n";
	print '<body>' , "\n";
	
if (@_ > 1) {
	print '<div class="container">' . "\n";
	my %this_module_info = &get_module_info(&get_module_name());
	print '<div class="panel panel-default" style="margin-top: 20px;">' . "\n";
	print '<div class="panel-heading">' . "\n";
	print "<table class='header' width=100%><tr>\n";
	if ($gconfig{'sysinfo'} == 2 && $remote_user) {
		print "<td id='headln1' colspan=3 align=center>\n";
		print &get_html_status_line(1);
		print "</td></tr> <tr>\n";
		}
	print "<td id='headln2l' width=15% valign=top align=left>";
	if ($ENV{'HTTP_WEBMIN_SERVERS'} && !$tconfig{'framed'}) {
		print "<a href='$ENV{'HTTP_WEBMIN_SERVERS'}'>",
		      "$text{'header_servers'}</a><br>\n";
		}
	if (!$_[5] && !$tconfig{'noindex'}) {
		my @avail = &get_available_module_infos(1);
		my $nolo = $ENV{'ANONYMOUS_USER'} ||
			      $ENV{'SSL_USER'} || $ENV{'LOCAL_USER'} ||
			      $ENV{'HTTP_USER_AGENT'} =~ /webmin/i;
		if ($gconfig{'gotoone'} && $main::session_id && @avail == 1 &&
		    !$nolo) {
			print "<a href='$gconfig{'webprefix'}/session_login.cgi?logout=1'>",
			      "$text{'main_logout'}</a><br>";
			}
		elsif ($gconfig{'gotoone'} && @avail == 1 && !$nolo) {
			print "<a href=$gconfig{'webprefix'}/switch_user.cgi>",
			      "$text{'main_switch'}</a><br>";
			}
		elsif (!$gconfig{'gotoone'} || @avail > 1) {
			print "<a href='$gconfig{'webprefix'}/?cat=",
			      $this_module_info{'category'},
			      "'>$text{'header_webmin'}</a><br>\n";
			}
		}
	if (!$_[4] && !$tconfig{'nomoduleindex'}) {
		my $idx = $this_module_info{'index_link'};
		my $mi = $module_index_link || "/".&get_module_name()."/$idx";
		my $mt = $module_index_name || $text{'header_module'};
		print "<a href=\"$gconfig{'webprefix'}$mi\">$mt</a><br>\n";
		}
	if (ref($_[2]) eq "ARRAY" && !$ENV{'ANONYMOUS_USER'} &&
	    !$tconfig{'nohelp'}) {
		print &hlink($text{'header_help'}, $_[2]->[0], $_[2]->[1]),
		      "<br>\n";
		}
	elsif (defined($_[2]) && !$ENV{'ANONYMOUS_USER'} &&
	       !$tconfig{'nohelp'}) {
		print &hlink($text{'header_help'}, $_[2]),"<br>\n";
		}
	if ($_[3]) {
		my %access = &get_module_acl();
		if (!$access{'noconfig'} && !$config{'noprefs'}) {
			my $cprog = $user_module_config_directory ?
					"uconfig.cgi" : "config.cgi";
			print "<a href=\"$gconfig{'webprefix'}/$cprog?",
			      &get_module_name()."\">",
			      $text{'header_config'},"</a><br>\n";
			}
		}
	print "</td>\n";
	if ($_[1]) {
		# Title is a single image
		print "<td id='headln2c' align=center width=70%>",
		      "<img alt=\"$_[0]\" src=\"$_[1]\"></td>\n";
		}
	else {
		# Title is just text
		my $ts = defined($tconfig{'titlesize'}) ?
				$tconfig{'titlesize'} : "+2";
		print "<td id='headln2c' align=center width=70%>",
		      ($ts ? "<font size=$ts>" : ""),$_[0],
		      ($ts ? "</font>" : "");
		print "<br>$_[9]\n" if ($_[9]);
		print "</td>\n";
		}
	print "<td id='headln2r' width=15% valign=top align=right>";
	print $_[6];
	print "</td></tr></table>\n";
	print $tconfig{'postheader'};
	print '</div>' . "\n";
	print '<div class="panel-body">' . "\n";
	}
$miniserv::page_capture = 1;
}
sub theme_footer {
for(my $i=0; $i+1<@_; $i+=2) {
	my $url = $_[$i];
	if ($url ne '/' || !$tconfig{'noindex'}) {
		if ($url eq '/') {
			$url = "/?cat=$this_module_info{'category'}";
			}
		elsif ($url eq '' && &get_module_name()) {
			$url = "/".&get_module_name()."/".
			       $this_module_info{'index_link'};
			}
		elsif ($url =~ /^\?/ && &get_module_name()) {
			$url = "/".&get_module_name()."/$url";
			}
		$url = "$gconfig{'webprefix'}$url" if ($url =~ /^\//);
		print "&nbsp;<a style='margin-bottom: 15px;' class='btn btn-primary' href=\"$url\"><i class='fa fa-arrow-left'></i> ",&text('main_return', $_[$i+1]),"</a>\n";
		}
	}
	#If you comment this </div>, decomment the </div> commented in theme_ui_pre_footer, index.cgi, body.cgi
	print "</div>\n";
	print '</body>' , "\n";
	print '</html>' , "\n";
}

sub theme_generate_icon {
my $icon = $_[0];
#$icon =~ s/.gif/.png/;
my $w = !defined($_[4]) ? "width=48" : $_[4] ? "width=$_[4]" : "";
my $h = !defined($_[5]) ? "height=48" : $_[5] ? "height=$_[5]" : "";
if ($tconfig{'noicons'}) {
	if ($_[2]) {
		print "$_[6]<a href=\"$_[2]\" $_[3]>$_[1]</a>$_[7]\n";
		}
	else {
		print "$_[6]$_[1]$_[7]\n";
		}
	}
elsif ($_[2]) {
	print "<table style=\" margin: 0 auto;\"><tr><td>\n",
	      "<a href=\"$_[2]\" $_[3]><img src=\"$icon\" alt=\"\" border=0 ",
	      "$w $h></a></td></tr></table>\n";
	print "$_[6]<a href=\"$_[2]\" $_[3]>$_[1]</a>$_[7]\n";
	}
else {
	print "<table style=\" margin: 0 auto;\><tr><td>\n",
	      "<img src=\"$icon\" alt=\"\" border=0 $w $h>",
	      "</td></tr></table>\n$_[6]$_[1]$_[7]\n";
	}
}

sub theme_icons_table {
	my $need_tr;
	my $cols = $_[3] ? $_[3] : 4;
	my $per = int(100.0 / $cols);
	
	print '<table class="icons-table icons_table" width="100%">' . "\n";
	print '<tr><td>';
	print '<div class="icons-table">' . "\n";
	print '<div class="row">' . "\n";
	for(my $i=0; $i<@{$_[0]}; $i++) {
		if ($i%$cols == 0) {
			
		}
		print '<div style="text-align: center;" class="col-xs-6 col-sm-4 col-md-3">' . "\n";
		&generate_icon($_[2]->[$i], $_[1]->[$i], $_[0]->[$i], ref($_[4]) ? $_[4]->[$i] : $_[4], $_[5], $_[6], $_[7]->[$i], $_[8]->[$i]);
		print '</div>' . "\n";
		if ($i%$cols == $cols-1) { 
			
		}
	}
	print '</div>' . "\n"; 
	while($i++%$cols) { print "<td width=$per%></td>\n"; $need_tr++; }
	print '</tr>' . "\n" if ($need_tr);
	print '</div>' . "\n";
	print '</tr></td>';
	print '</table>' . "\n";
}

sub theme_file_chooser_button
{
my $form = defined($_[2]) ? $_[2] : 0;
my $chroot = defined($_[3]) ? $_[3] : "/";
my $add = int($_[4]);
my ($w, $h) = (400, 300);
if ($gconfig{'db_sizefile'}) {
	($w, $h) = split(/x/, $gconfig{'db_sizefile'});
	}
return "<button class='btn btn-default' type=button onClick='ifield = form.$_[0]; chooser = window.open(\"$gconfig{'webprefix'}/chooser.cgi?add=$add&type=$_[1]&chroot=$chroot&file=\"+escape(ifield.value), \"chooser\", \"toolbar=no,menubar=no,scrollbars=no,resizable=yes,width=$w,height=$h\"); chooser.ifield = ifield; window.ifield = ifield'>...</button>\n";
}
sub theme_popup_window_button
{
my ($url, $w, $h, $scroll, $fields) = @_;
my $scrollyn = $scroll ? "yes" : "no";
my $rv = "<input class='btn btn-default' type=button onClick='";
foreach my $m (@$fields) {
	$rv .= "$m->[0] = form.$m->[1]; ";
	}
my $sep = $url =~ /\?/ ? "&" : "?";
$rv .= "chooser = window.open(\"$url\"";
foreach my $m (@$fields) {
	if ($m->[2]) {
		$rv .= "+\"$sep$m->[2]=\"+escape($m->[0].value)";
		$sep = "&";
		}
	}
$rv .= ", \"chooser\", \"toolbar=no,menubar=no,scrollbars=$scrollyn,resizable=yes,width=$w,height=$h\"); ";
foreach my $m (@$fields) {
	$rv .= "chooser.$m->[0] = $m->[0]; ";
	$rv .= "window.$m->[0] = $m->[0]; ";
	}
$rv .= "' value=\"...\">";
return $rv;
}
sub theme_ui_upload
{
my ($name, $size, $dis, $tags) = @_;
$size = &ui_max_text_width($size);
return "<input style='margin: 4px 0;' class='ui_upload' type=file name=\"".&quote_escape($name)."\" ".
       "size=$size ".
       ($dis ? "disabled=true" : "").
       ($tags ? " ".$tags : "").">";
}

# Thi is the theme.pl part dedicated to all theme functions.
# WARNING!!! Work in progress - Not all is implemented!!!
# All the # theme_ui_x are are not yet implemented theme functions.

################################# Theme table generation functions #################################

# theme_ui_table_start

# theme_ui_table_end

# theme_ui_table_row

# theme_ui_table_hr

# theme_ui_table_span

sub theme_ui_columns_start {
	my ($heads, $width, $noborder, $tdtags, $title) = @_;
	my ($rv, $i);
	
	$rv .= '<table class="table table-striped table-rounded">' . "\n";
	$rv .= '<thead>' . "\n";
	$rv .= '<tr>' . "\n";
	for($i=0; $i<@$heads; $i++) {
		$rv .= '<th>';
		$rv .= ($heads->[$i] eq '' ? '<br>' : $heads->[$i]);
		$rv .= '</th>' . "\n";
	}
	$rv .= '</tr>' . "\n";
	$rv .= '</thead>' . "\n";
	
	return $rv;
}

sub theme_ui_columns_row {
	my ($cols, $tdtags) = @_;
	my ($rv, $i);
	
	#$rv .= '<tbody>' . "\n";
	$rv .= '<tr>' . "\n";
	for($i=0; $i<@$cols; $i++) {
		$rv .= '<td>' . "\n";
		$rv .= ($cols->[$i] !~ /\S/ ? '<br>' : $cols->[$i]);
		$rv .= '</td>' . "\n";
	}	
	$rv .= '</tr>' . "\n";
	#$rv .= '</tbody>' . "\n";
	
	return $rv;
}

sub theme_ui_columns_header {
	my ($cols, $tdtags) = @_;
	my ($rv, $i);
	
	$rv .= '<thead>' . "\n";
	$rv .= '<tr>' . "\n";
	for($i=0; $i<@$cols; $i++) {
		$rv .= '<th>';
		$rv .= ($cols->[$i] eq '' ? '#' : $cols->[$i]);
		$rv .= '</th>' . "\n";
	}
	$rv .= '</tr>' . "\n";
	$rv .= '</thead>' . "\n";
	
	return $rv;
}

# theme_ui_checked_columns_row

# theme_ui_radio_columns_row

sub theme_ui_columns_end {
	my $rv;
	
	$rv .= '</table>' . "\n";
	
	return $rv;
}

# theme_ui_columns_table

# theme_ui_form_columns_table

################################# Theme form generation functions #################################

sub theme_ui_form_start {
	my ($script, $method, $target, $tags) = @_;
	my $rv;
	
	$rv .= '<form role="form" ';
	$rv .= 'action="' . &html_escape($script) . '" ';
	$rv .= ($method eq 'post' ? 'method="post" ' : $method eq 'form-data' ? 'method="post" enctype="multipart/form-data" ' : 'method="get" ');
	$rv .= ($target ? 'target="' . $target . '" ' : '');
	$rv .= ($tags ? $tags : '');
	$rv .= '>' . "\n";
	
	return $rv;
}

# theme_ui_form_end

sub theme_ui_textbox {
	my ($name, $value, $size, $dis, $max, $tags) = @_;
	my $rv;
	
	$rv .= '<input style="display: inline; width: auto;" class="form-control" type="text" ';
	$rv .= 'name="' . &quote_escape($name) . '" ';
	$rv .= 'value="' . &quote_escape($value) . '" ';
	$rv .= 'size="' . $size . '" ';
	$rv .= ($dis ? 'disabled="true" ' : '');
	$fv .= ($max ? 'maxlength="' . $max . '" ' : '');
	$rv .= ($tags ? $tags : '');
	$rv .= '>' . "\n";
	
	return $rv;
}

# theme_ui_filebox

# theme_ui_upload

sub theme_ui_password {
	my ($name, $value, $size, $dis, $max, $tags) = @_;
	my $rv;
	
	$rv .= '<input style="display: inline; width: auto;" class="form-control" type="password" ';
	$rv .= 'name="' . &quote_escape($name) . '" ';
	$rv .= 'value="' . &quote_escape($value) . '" ';
	$rv .= 'size="' . $size . '" ';
	$rv .= ($dis ? 'disabled="true" ' : '');
	$fv .= ($max ? 'maxlength="' . $max . '" ' : '');
	$rv .= ($tags ? $tags : '');
	$rv .= '>' . "\n";
	
	return $rv;
}

# theme_ui_hidden

# theme_ui_select

# theme_ui_multi_select

# theme_ui_multiselect_javascript

sub theme_ui_radio {
	my ($name, $value, $opts, $dis) = @_;
	my ($rv, $o);
	foreach $o (@$opts) {
		my $id = &quote_escape($name."_".$o->[0]);
		my $label = $o->[1] || $o->[0];
		my $after;
		if ($label =~ /^([\000-\377]*?)((<a\s+href|<input|<select|<textarea)[\000-\377]*)$/i) {
			$label = $1;
			$after = $2;
		}
		$rv .= '<input type="radio" ';
		$rv .= 'name="' . &quote_escape($name) . '" ';
		$rv .= 'value="' . &quote_escape($o->[0]) . '" ';
		$rv .= ($o->[0] eq $value ? 'checked ' : '');
		$rv .= ($dis ? 'disabled="true" ' : '');
		$rv .= 'id="' . $id . '" ';
		$rv .= $o->[2] .  ' ';
		$rv .= '>' . "\n";
		$rv .= '<label class="radio" ';
		$rv .= 'for="' . $id .'">' . "\n";
		$rv .= '<i class="fa"></i> ' . $label . "\n";
		$rv .= '</label>' . $after . "\n";
	}
	
	return $rv;
}

sub theme_ui_yesno_radio {
	my ($name, $value, $yes, $no, $dis) = @_;
	my $rv;
	
	$yes = 1 if (!defined($yes));
	$no = 0 if (!defined($no));
	$value = int($value);
	
	$rv .= &ui_radio($name, $value, [ [ $yes, $text{'yes'} ], [ $no, $text{'no'} ] ], $dis);
	
	return $rv;
}

sub theme_ui_checkbox {
	my ($name, $value, $label, $sel, $tags, $dis) = @_;
	my ($rv, $after);
	if ($label =~ /^([^<]*)(<[\000-\377]*)$/) {
		$label = $1;
		$after = $2;
	}
	$rv .= '<input type="checkbox" ';
	$rv .= 'name="' . &quote_escape($name) . '" ';
	$rv .= 'value="' . &quote_escape($value) . '" ';
	$rv .= ($sel ? 'checked ' : '');
	$rv .= ($dis ? 'disabled="true" ' : '');
	$rv .= 'id="' . &quote_escape("${name}_${value}") . '" ';
	$rv .= ($tags ? $tags .  ' ' : '');
	$rv .= '>' . "\n";
	$rv .= '<label class="checkbox" ';
	$rv .= 'for="' . &quote_escape("${name}_${value}") .'">' . "\n";
	$rv .= '<i class="fa"></i> ' . $label . "\n";
	$rv .= '</label>' . "\n";
	
	return $rv;
}

sub theme_ui_oneradio {
	my ($name, $value, $label, $sel, $tags, $dis) = @_;
	my ($rv, $after);
	if ($label =~ /^([^<]*)(<[\000-\377]*)$/) {
		$label = $1;
		$after = $2;
	}
	$rv .= '<input type="radio" ';
	$rv .= 'name="' . &quote_escape($name) . '" ';
	$rv .= 'value="' . &quote_escape($value) . '" ';
	$rv .= ($sel ? 'checked ' : '');
	$rv .= ($dis ? 'disabled="true" ' : '');
	$rv .= 'id="' . &quote_escape("${name}_${value}") . '" ';
	$rv .= ($tags ? $tags .  ' ' : '');
	$rv .= '>' . "\n";
	$rv .= '<label class="radio" ';
	$rv .= 'for="' . &quote_escape("${name}_${value}") .'">' . "\n";
	$rv .= '<i class="fa"></i> ' . $label . "\n";
	$rv .= '</label>' . "\n";
	
	return $rv;
}

sub theme_ui_textarea {
	my ($name, $value, $rows, $cols, $wrap, $dis, $tags) = @_;
	my $rv;
	$cols = &ui_max_text_width($cols, 1);
	
	$rv .= '<textarea style="display: inline; width: auto;" class="form-control" ';
	$rv .= 'name="' . &quote_escape($name) . '" ';
	$rv .= 'rows="' . $rows . '" ';
	$rv .= 'cols="' . $cols . '" ';
	$rv .= ($wrap ? 'wrap="' . $wrap . '" ' : '');
	$rv .= ($dis ? 'disabled="true" ' : '');
	$rv .= ($tags ? $tags : '');
	$rv .= '>' . "\n";
	$rv .= &html_escape($value) . "\n";
	$rv .= '</textarea>' . "\n";
	
	return $rv;
}

# theme_ui_user_textbox

# theme_ui_group_textbox

# theme_ui_opt_textbox

sub theme_ui_submit {
	my ($label, $name, $dis, $tags) = @_;
	my ($rv, $fa);
	my $btntype = 'btn-default';
	 
	if ($name eq 'delete') {
		$btntype = 'btn-danger';
		#$fa = '<i class="fa fa-times"></i>';
	} elsif ($name eq 'stop') {
		$btntype = 'btn-danger';
		#$fa = '<i class="fa fa-exclamation"></i>';
	} elsif ($name eq 'start') {
		$btntype = 'btn-success';
		#$fa = '<i class="fa fa-check"></i>';
	} elsif ($name eq 'restart') {
		$btntype = 'btn-warning';
		#$fa = '<i class="fa fa-refresh"></i>';
	}
	
	$rv .= '<button type="submit" class="btn ' . $btntype . '" ';
	$rv .= ($name ne '' ? 'name="' . &quote_escape($name) . '" ' : '');
	$rv .= ($dis ? ' disabled="disabled"' : '');
	$rv .= ($tags ? ' ' . $tags : ''). '>';
	$rv .= $fa . ' ' . &quote_escape($label);
	$rv .= '</button>' . "\n";
	
	return $rv;
}

sub theme_ui_reset {
	my ($label, $dis) = @_;
	my $rv;
	
	$rv .= '<button class="btn btn-default" type="reset" ';
	$rv .= ($dis ? 'disabled="disabled">' : '>');
	$rv .= &quote_escape($label);
	$rv .= '</button>' . "\n";
	
	return $rv;
}

sub theme_ui_button {
	my ($label, $name, $dis, $tags) = @_;
	my $rv;
	
	$rv .= '<button type="button" class="btn btn-default" ';
	$rv .= ($name ne '' ? 'name="' . &quote_escape($name) . '" ' : '');
	$rv .= ($dis ? 'disabled="disabled"' : '');
	$rv .= ($tags ? ' ' . $tags : ''). '>';
	$rv .= &quote_escape($label);
	$rv .= '</button>' . "\n";
	
	return $rv;
}

# theme_ui_date_input

# theme_ui_buttons_start

# theme_ui_buttons_end

# theme_ui_buttons_row

# theme_ui_buttons_hr

################################# Theme header and footer functions #################################

sub theme_ui_post_header {
	my ($text) = @_;
	
	my $rv;
	#$rv .= '<hr>' . "\n";
	
	return $rv;
}

sub theme_ui_pre_footer {
	my $rv;
	
	#$rv .= '<hr>' . "\n";
	$rv .= '</div>' . "\n";
	$rv .= '</div>' . "\n";
	#$rv .= '</div>' . "\n";
	
	return $rv;
}

# theme_ui_print_header

# theme_ui_print_unbuffered_header

# theme_ui_print_footer

# theme_ui_config_link

# theme_ui_print_endpage

# theme_ui_subheading

# theme_ui_links_row

################################# Theme collapsible section / tab functions #################################

# theme_ui_hidden_javascript

# theme_ui_hidden_start

# theme_ui_hidden_end

# theme_ui_hidden_table_row_start

# theme_ui_hidden_table_row_end

# theme_ui_hidden_table_start

# theme_ui_hidden_table_end

sub theme_ui_tabs_start {
	my ($tabs, $name, $sel, $border) = @_;
	my $rv;
	
	$rv .= '<ul class="nav nav-tabs">' . "\n";
	foreach my $t (@$tabs) {
		my $tabid = "tab_".$t->[0];
		if ($t->[0] eq $sel) {
			$rv .= '<li class="active"><a data-toggle="tab" href="#' . $t->[0] . '">' . $t->[1] . '</a></li>' . "\n";
		} else {
			$rv .= '<li><a data-toggle="tab" href="#' . $t->[0] . '">' . $t->[1] . '</a></li>' . "\n";
		}
	}
	$rv .= '</ul>' . "\n";
	$rv .= '<div class="tab-content">' . "\n";
	$main::ui_tabs_selected = $sel;
	
	return $rv;
}

sub theme_ui_tabs_end {
	my ($border) = @_;
	my $rv;
	
	$rv .= '</div>' . "\n";
	
	return $rv;
}

sub theme_ui_tabs_start_tab {
	my ($name, $tab) = @_;
	my $rv;
	my $defclass = $tab eq $main::ui_tabs_selected ? 'active' : '';
	
	$rv .= '<div id="' . $tab . '" class="tab-pane ' . $defclass . '">' . "\n";
	
	return $rv;
}

# theme_ui_tabs_start_tabletab

sub theme_ui_tabs_end_tab {
	my $rv;
	
	$rv .= '</div>' . "\n";
	
	return $rv;
}

# theme_ui_tabs_end_tabletab

# theme_ui_radio_selector

################################# Theme collapsible section / tab functions #################################

# theme_ui_grid_table

# theme_ui_radio_table

# theme_ui_up_down_arrows

sub theme_ui_hr {
	my $rv;
	
	$rv .= '<hr>' . "\n";
	
	return $rv;
}

# theme_ui_nav_link

# theme_ui_confirmation_form !!!!! NB: Not available to override ?????

sub theme_ui_alert_box {
	my ($msg, $class) = @_;
	my ($rv, $type, $tmsg, $fa);
	
	if ($class eq "success") { $type = 'alert-success', $tmsg = 'Well done!', $fa = 'fa-check'; }
	elsif ($class eq "info") { $type = 'alert-info', $tmsg = 'Heads up!', $fa = 'fa-info'; }
	elsif ($class eq "warn") { $type = 'alert-warning', $tmsg = 'Warning!', $fa = 'fa-exclamation-triangle'; }
	elsif ($class eq "danger") { $type = 'alert-danger', $tmsg = 'Oh snap!', $fa = 'fa-bolt'; }
	
	$rv .= '<div class="alert ' . $type . '">' . "\n";
	$rv .= '<i class="fa fa-fw ' . $fa . '"></i> <strong>' . $tmsg . '</strong>';
	$rv .= '<br>' . "\n";
	$rv .= $msg . "\n";
	$rv .= '</div>' . "\n";
	
	return $rv;
}

# theme_ui_page_flipper

# theme_js_redirect