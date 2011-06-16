print $<.read.gsub(/^:ID:.*\n/,'').gsub(/^:PROPERTIES:\n:END:\n/,'')
