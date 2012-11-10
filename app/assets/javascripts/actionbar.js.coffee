# handle position fixed problem
ns = {}
ns.ie6 = do ->
  $el = $('<div><!--[if IE 6]><i></i><![endif]--></div>')
  return if $el.find('i').length then true else false

# following block was from jQuery mobile.
# https://github.com/jquery/jquery-mobile/blob/master/js/widgets/fixedToolbar.js

# Browser detection! Weeee, here we go...
# Unfortunately, position:fixed is costly, not to mention probably impossible, to feature-detect accurately.
# Some tests exist, but they currently return false results in critical devices and browsers, which could lead to a broken experience.
# Testing fixed positioning is also pretty obtrusive to page load, requiring injected elements and scrolling the window
# The following function serves to rule out some popular browsers with known fixed-positioning issues
# This is a plugin option like any other, so feel free to improve or overwrite it
ns.isBlackListedMobile = `function() {

  var w = window,
    ua = navigator.userAgent,
    platform = navigator.platform,
    // Rendering engine is Webkit, and capture major version
    wkmatch = ua.match( /AppleWebKit\/([0-9]+)/ ),
    wkversion = !!wkmatch && wkmatch[ 1 ],
    ffmatch = ua.match( /Fennec\/([0-9]+)/ ),
    ffversion = !!ffmatch && ffmatch[ 1 ],
    operammobilematch = ua.match( /Opera Mobi\/([0-9]+)/ ),
    omversion = !!operammobilematch && operammobilematch[ 1 ];

  if(
    // iOS 4.3 and older : Platform is iPhone/Pad/Touch and Webkit version is less than 534 (ios5)
    ( ( platform.indexOf( "iPhone" ) > -1 || platform.indexOf( "iPad" ) > -1 || platform.indexOf( "iPod" ) > -1 ) && wkversion && wkversion < 534 ) ||
    // Opera Mini
    ( w.operamini && ({}).toString.call( w.operamini ) === "[object OperaMini]" ) ||
    ( operammobilematch && omversion < 7458 )	||
    //Android lte 2.1: Platform is Android and Webkit version is less than 533 (Android 2.2)
    ( ua.indexOf( "Android" ) > -1 && wkversion && wkversion < 533 ) ||
    // Firefox Mobile before 6.0 -
    ( ffversion && ffversion < 6 ) ||
    // WebOS less than 3
    ( "palmGetResource" in window && wkversion && wkversion < 534 )	||
    // MeeGo
    ( ua.indexOf( "MeeGo" ) > -1 && ua.indexOf( "NokiaBrowser/8.5.0" ) > -1 ) ) {
    return true;
  }

  return false;

}`

# at last, can I use position fixed or not?
ns.positionFixedUnavailable = ns.ie6 or ns.isBlackListedMobile()

if ns.positionFixedUnavailable
  $('.navbar-fixed-top').removeClass('fixed-available')
  $('body').css('padding-top', '')
else
  $('.navbar-fixed-top').addClass('fixed-available')
  $('body').css('padding-top', '50px')

# dropdown fix for iOS
$('body').on 'touchstart.dropdown.data-api', '.dropdown-menu', (e) ->
  e.stopPropagation()
  null

enable_to_back = (url) ->
  $link = $('.actionbar a.brand')
  $link.addClass('backable')
  if url?
    $link.attr('href', url)
  else if (not $link.attr('href')?) or ($link.attr('href') == '#')
    $link.attr('href', 'javascript:history.back();')
