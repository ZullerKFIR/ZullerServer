base64 = {}
base64.PADCHAR = "="
base64.ALPHA = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
base64.getbyte64 = (s, i) ->
  
  # This is oddly fast, except on Chrome/V8.
  #  Minimal or no improvement in performance by using a
  #   object with properties mapping chars to value (eg. 'A': 0)
  idx = base64.ALPHA.indexOf(s.charAt(i))
  throw "Cannot decode base64"  if idx is -1
  idx

base64.decode = (s) ->
  
  # convert to string
  s = "" + s
  getbyte64 = base64.getbyte64
  pads = undefined
  i = undefined
  b10 = undefined
  imax = s.length
  return s  if imax is 0
  throw "Cannot decode base64"  unless imax % 4 is 0
  pads = 0
  if s.charAt(imax - 1) is base64.PADCHAR
    pads = 1
    pads = 2  if s.charAt(imax - 2) is base64.PADCHAR
    
    # either way, we want to ignore this last block
    imax -= 4
  x = []
  i = 0
  while i < imax
    b10 = (getbyte64(s, i) << 18) | (getbyte64(s, i + 1) << 12) | (getbyte64(s, i + 2) << 6) | getbyte64(s, i + 3)
    x.push String.fromCharCode(b10 >> 16, (b10 >> 8) & 0xff, b10 & 0xff)
    i += 4
  switch pads
    when 1
      b10 = (getbyte64(s, i) << 18) | (getbyte64(s, i + 1) << 12) | (getbyte64(s, i + 2) << 6)
      x.push String.fromCharCode(b10 >> 16, (b10 >> 8) & 0xff)
    when 2
      b10 = (getbyte64(s, i) << 18) | (getbyte64(s, i + 1) << 12)
      x.push String.fromCharCode(b10 >> 16)
  decodeURIComponent escape(x.join(""))

base64.getbyte = (s, i) ->
  x = s.charCodeAt(i)
  throw "INVALID_CHARACTER_ERR: DOM Exception 5"  if x > 255
  x

base64.encode = (s) ->
  throw "SyntaxError: Not enough arguments"  unless arguments_.length is 1
  s = unescape(encodeURIComponent(s))
  padchar = base64.PADCHAR
  alpha = base64.ALPHA
  getbyte = base64.getbyte
  i = undefined
  b10 = undefined
  x = []
  
  # convert to string
  s = "" + s
  imax = s.length - s.length % 3
  return s  if s.length is 0
  i = 0
  while i < imax
    b10 = (getbyte(s, i) << 16) | (getbyte(s, i + 1) << 8) | getbyte(s, i + 2)
    x.push alpha.charAt(b10 >> 18)
    x.push alpha.charAt((b10 >> 12) & 0x3F)
    x.push alpha.charAt((b10 >> 6) & 0x3f)
    x.push alpha.charAt(b10 & 0x3f)
    i += 3
  switch s.length - imax
    when 1
      b10 = getbyte(s, i) << 16
      x.push alpha.charAt(b10 >> 18) + alpha.charAt((b10 >> 12) & 0x3F) + padchar + padchar
    when 2
      b10 = (getbyte(s, i) << 16) | (getbyte(s, i + 1) << 8)
      x.push alpha.charAt(b10 >> 18) + alpha.charAt((b10 >> 12) & 0x3F) + alpha.charAt((b10 >> 6) & 0x3f) + padchar
  x.join ""